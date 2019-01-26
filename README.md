# POST Image handler

This library wraps the common code that is needed to handle images when they are submitted to an application over the internet.


## Usage Example - [Lapis](http://leafo.net/lapis/)

```lua
local get_image = require "post_image.get_image"
local save_image = require "post_image.save_image"

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

* __get_image__ - Checks if the filename format is in the extensions whitelist, validates if the received image content has any content. Return nil in case of error, or in case of success a table with:
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
* __save_image__ - Receives the image table obtained from get_image and saves the image with the generated name in the configurated base_folder.
* __delete_image__ - Receives an image fullname and deletes it from the configurated base_folder.
* __set_base_folder__ - Changes the base folder of the images. (default "./")
* __set_allowed_formats__ - Sets a new table with the allowed image formats. (default {".jpg", ".png", ".jpeg", ".bmp"})
