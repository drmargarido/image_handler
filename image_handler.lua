-- Random name generation configuration
local printable_chars = require "printable_chars".printable_chars
local blacklist_chars = require "printable_chars".blacklist_chars
local chars_to_blacklist = {
    "\"", "'", "?", "<", ">", ".", "#", "$", "´", "`",
    ":", "*", "^", ";", "+", "@", " ", ")", "}", "{", "~",
    "(", "[", "]", "\\", "%", "!", "=", "&", "|", "/", ","
}
blacklist_chars(chars_to_blacklist)

-- Image handling library
local magick = require "magick"

-- Default formats whitelist
local ALLOWED_IMAGE_EXTENSIONS = {
    [".jpg"] = true,
    [".png"] = true,
    [".jpeg"] = true,
    [".bmp"] = true
}

local base_folder = "./"


--[[    Private helpers     ]]--
local function file_exists(filename)
    local ok, err, code = os.rename(filename, filename)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end

    return ok, err
end

local function get_filename_format(filename)
    local extension = filename:match("^.+(%..+)$")
    if extension then
        extension = string.lower(extension)
    end

    return extension
end


local function get_random_filename()
    -- Read random chars from /dev/urandom to generate an id
    local urandom = io.open("/dev/urandom", "r")
    local random_data = urandom:read(32)
    local random_id = printable_chars(random_data)
    urandom:close()

    return string.format("%s%s", os.time(), random_id)
end


--[[    Configuration methods   ]]--

-- Define the image formats whitelist
local function set_allowed_formats(formats)
    local new_formats = {}
    for i, format in ipairs(formats) do
        new_formats[format] = true
    end

    ALLOWED_IMAGE_EXTENSIONS = new_formats
end

-- Set the folder where the images will managed
local function set_base_folder(path)
    base_folder = path or "./"
end


--[[    Image controlling methods   ]]--
local function get_image(image_name, image_content)
    local image = {}
    image.extension = get_filename_format(image_name)

    local random_filename, exists
    repeat
        random_filename = get_random_filename()
        exists, _ = file_exists(base_folder .. random_filename .. image.extension)
    until not exists
    image.name = random_filename

    if not ALLOWED_IMAGE_EXTENSIONS[image.extension] then
        print("Invalid logo image received")
        return nil
    end

    if #image_content == 0 then
        print("The received content has size 0")
        return nil
    end

    local _image = magick.load_image_from_blob(image_content)
    if not _image then
        print("The received image has no content")
        return nil    
    end

    image.width  = _image:get_width()
    image.height = _image:get_height()
    image.content = image_content
    image.fullname = image.name .. image.extension

    return image
end

local function save_image(image)
    local file = io.open(base_folder .. image.fullname, "w")
    file:write(image.content)
    file:close()
end

local function delete_image(image_name)
    os.remove(base_folder .. image_name)
end

return {
    -- Configuration
    set_allowed_formats = set_allowed_formats,
    set_base_folder = set_base_folder,

    -- Image control logic
    get_image = get_image,
    save_image = save_image,
    delete_image = delete_image
}