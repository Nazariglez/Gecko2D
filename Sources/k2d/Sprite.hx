package k2d;

import kha.Image;
import k2d.render.Renderer2D;
import k2d.Assets;

class Sprite extends Actor {
    public var image(get, set):Image;
    private var _image:Image;

    static public function fromImage(img:Image) : Sprite {
        var s = new Sprite();
        s.image = img;
        return s;
    }

    public override function new(?img:String){
        super();
        if(img != null){
            this.image = Assets.images[img];
        }
    }

    public override function render(r:Renderer2D) {
        super.render(r);
        if(image != null){
            r.drawImage(image, -size.x*0.5, -size.y*0.5);
        }
    }

    public function get_image() : Image {
		return _image;
	}

	public function set_image(img:Image) : Image {
		size.set(img.width, img.height);
		return _image = img;
	}
}