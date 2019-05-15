-- Handle Image methods
local image_handler = require "image_handler"
local get_image = image_handler.get_image
local save_image = image_handler.save_image
local delete_image = image_handler.delete_image
local set_base_folder = image_handler.set_base_folder
local set_allowed_formats = image_handler.set_allowed_formats

-- Image Binary Content
local file = io.open("spec/image_data", "rb")
local image_binary_data = file:read("*a")
file:close()

-- Example of image posting structure using lapis
local request_mock = {
    content = image_binary_data,
    filename = "mvm_cover.png"
}

-- Base folder were the images will be stored
local BASE_FOLDER = "./spec/"
set_base_folder(BASE_FOLDER)

describe("Handle image post", function()
    it("handles the received binary image data", function()
        local image = get_image(request_mock.filename, request_mock.content)
        assert.same(".png", image.extension)
        assert.same(315, image.width)
        assert.same(250, image.height)
    end)

    it("ignores posted images that dont have any content", function()
        local image = get_image(request_mock.filename, "")
        assert.same(nil, image)
    end)

    it("blocks not allowed images formats", function()
        local image = get_image("mvm_cover.svg", request_mock.content)
        assert.same(nil, image)
    end)

    it("stores the received image in the filesystem", function()
        local image = get_image(request_mock.filename, request_mock.content)
        save_image(image)

        -- Check if the image now exists in the filesystem
        local filename = image.name..image.extension
        local ok, err, code = os.rename(BASE_FOLDER..filename, BASE_FOLDER..filename)
        assert.is_true(ok)

        delete_image(filename)
    end)

    it("generates a random name for each stored image", function()
        local image = get_image(request_mock.filename, request_mock.content)
        local image2 = get_image(request_mock.filename, request_mock.content)
        assert.is.falsy(image.name == image2.name)
    end)
end)

describe("Module configuration", function()
    it("can set the allowed image formats", function()
        -- Allow only jpg
        set_allowed_formats({".jpg"})
        
        local image = get_image(request_mock.filename, request_mock.content)
        assert.same(nil, image)
    end)
end)