# POST Image handler

This library wraps the common code that is needed to handle images when they are submitted to an application over the internet.


## Lapis Example

```lua
for i=0 do
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
