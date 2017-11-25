package k2d.resources;

import k2d.math.Rect;
import k2d.math.Point;

typedef TexturePackerPoint = {
    var x:Int;
    var y:Int;
};

typedef TexturePackerSize = {
    var w:Int;
    var h:Int;
};

typedef TexturePackerRect = {
    > TexturePackerPoint,
    > TexturePackerSize,
};

typedef TexturePackerData = {
    var frame:TexturePackerRect;
    var rotated:Bool;
    var trimmed:Bool;
    var spriteSourceSize:TexturePackerRect;
    var pivot:TexturePackerPoint;
    var sourceSize:TexturePackerSize;
};

typedef TexturePacker = {
    var frames:Map<String, TexturePackerData>;
    var meta:Dynamic;
};

class Texture {
    public var image:Image;
    public var frame:Rect;

    public var trimmed(get, null):Bool;
    public var trim:Rect;

    //todo rotate and pivot for texture packer
    public var rotated:Bool = false; //todo
    public var pivot:Point; //todo

    public var width(get, null):Int;
    private var _width:Int;

    public var height(get, null):Int;
    private var _height:Int;

    static public function fromTexturePacker(img:Image, data:TexturePackerData) : Texture {
        var frame:Rect = null;
        var trim:Rect = null;
        
        if(data.rotated) {
            frame = new Rect(data.frame.x, data.frame.y, data.frame.h, data.frame.w);
        }else{
            frame = new Rect(data.frame.x, data.frame.y, data.frame.w, data.frame.h);
        }

        if(data.trimmed){
            trim = new Rect(data.spriteSourceSize.x, data.spriteSourceSize.y, data.spriteSourceSize.w, data.spriteSourceSize.h);
        }

        var texture = new Texture(img, frame, data.sourceSize.w, data.sourceSize.h, trim);

        texture.rotated = data.rotated;
        texture.pivot = new Point(data.pivot.x, data.pivot.y);

        return texture;
    }

    public function new(img:Image, ?frame:Rect, ?width:Null<Int>, ?height:Null<Int>, ?trim:Rect) {
        image = img;
        if(frame != null){
            this.frame = frame;
        }else{
            this.frame = new Rect(0, 0, image.width, image.height);
        }

        if(trim != null){
            this.trim = trim;
        }

        _width = width != null ? width : image.width;
        _height = height != null ? height : image.height;
    }

    public function unload() {
        //image.unload();
    }

    function get_trimmed() : Bool {
        return trim != null;
    }

    function get_width() : Int {
        return _width;
    }

    function get_height() : Int {
        return _height;
    }

}