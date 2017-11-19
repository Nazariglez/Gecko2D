package k2d.resources;

import k2d.math.Rect;

class Texture {
    public var trim:Rect;
    public var image:Image;

    public var width(get, null):Int;
    function get_width() : Int {
        return cast trim.width;
    }

    public var height(get, null):Int;
    function get_height() : Int {
        return cast trim.height;
    }

    public function new(img:Image, ?trim:Rect) {
        image = img;
        if(trim != null){
            this.trim = trim;
        } else {
            this.trim = new Rect(0, 0, img.width, img.height);
        }
    }

    public function unload() {
        //image.unload();
    }

}