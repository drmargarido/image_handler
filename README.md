# POST Image handler

This library wraps the common code that is needed to handle images when they are submitted to an application over the internet.


## Usage Example - [Lapis](http://leafo.net/lapis/)

```lua
local get_image = require "image_handler".get_image
local save_image = require "image_handler".save_image

POST = function(self)
    -- Get the form posted image data from the request
    local filename = self.params.photo.filename
    local content = self.params.photo.content

    -- Get the photo
    local photo = get_image(filename, content)
    
    -- Check result
    if not photo then
        print("Received an invalid photo")
        return { status=400 }
    end

    -- Save the new image in the base_folder
    save_image(photo)

    return { status=200 }
end
```


## Methods

* __get_image(image_name, image_content)__ - Checks if the filename format is in the extensions whitelist, validates if the received image content has any content. Return nil in case of error, or in case of success a table with:
```lua
{
    name = "Random generated name so it can be stored",
    extension = "Extension of the received file",
    width = "Image Width",
    height = "Image Height",
    content = "Binary image received content",
    fullname = "Image name + extension"
}
```
* __save_image(image)__ - Receives the image table obtained from get_image and saves the image with the generated name in the configurated base_folder.

* __delete_image(image_name)__ - Receives an image fullname and deletes it from the configurated base_folder.

* __set_base_folder(path)__ - Changes the base folder of the images. (default "./")

* __set_allowed_formats(formats)__ - Sets a new table with the allowed image formats. (default {".jpg", ".png", ".jpeg", ".bmp"})


## Dependencies

* [magick](https://github.com/leafo/magick) - For checking image content and gathering the image width and height.

* [printable_chars](https://github.com/drmargarido/printable_chars) - To help in the generation of random file names.

* Since it uses the /dev/urandom to generate file names, it can only run on a Unix based system.

## Installation

Magic depends on LuaJIT and MagickWand.
On Ubuntu, to use ImageMagick, you might run:
```sh
sudo apt-get install luajit
sudo apt-get install libmagickwand-dev
```

Use LuaRocks to install the lua packages:
```sh
sudo apt-get install luarocks
luarocks install image_handler
```

## Testing

To run the unit tests the busted tool is needed. You can install it with luarocks:
```sh
luarocks install busted
```

To run the unit tests we need to tell busted to use luajit.
We can test with the following command.
```sh
busted --lua /usr/bin/luajit spec
```