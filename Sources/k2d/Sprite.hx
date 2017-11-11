package k2d;

import k2d.math.FastFloat;
import k2d.resources.Image;
import k2d.render.Renderer;

class Sprite extends Container {
    public var image(get, set):Image;
    private var _image:Image;

    public var imageName(get, set):String;
    private var _imageName:String = "";

    static public function fromImage(img:Image) : Sprite {
        var s = new Sprite();
        s.image = img;
        return s;
    }

    public override function new(?imgName:String){
        super();
        if(imgName != null){
            this.imageName = imgName;
        }
    }

    private override inline function _setSize(width:FastFloat, height:FastFloat) {
        if(_image != null){
            size.x = _image.width > width ? _image.width : width;
            size.y = _image.height > height ? _image.height : height;
        } else {
            size.set(width, height);
        }
    }

    public override function render(r:Renderer) {
        r.applyTransform(matrixTransform);

        if(image != null){
            r.drawImage(image, 0,0);
        }

        super.render(r);
    }

    function get_imageName() : String {
        return _imageName;
    }

    function set_imageName(name:String) : String {
        if(!Assets.images.exists(name)){
            throw new k2d.Error('Image $name not loaded...'); //todo better use log than error?
            return "";
        }

        this.image = Assets.images[name];
        return this._imageName = name;
    }

    function get_image() : Image {
		return _image;
	}

	function set_image(img:Image) : Image {
        if(img != null){
            size.set(img.width, img.height);
        }
		return _image = img;
	}
}