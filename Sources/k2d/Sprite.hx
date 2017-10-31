package k2d;

import kha.Image;
import k2d.render.Renderer2D;

class Sprite extends Actor {
    public var texture(get, set):Image;
    private var _texture:Image;

    public override function new(img:Image){
        super();
        this.texture = img;
    }

    public override function render(r:Renderer2D) {
        super.render(r);
        r.drawImage(texture, -size.x*0.5, -size.y*0.5);
    }

    public function get_texture() : Image {
		return _texture;
	}

	public function set_texture(img:Image) : Image {
		size.set(img.width, img.height);
		return _texture = img;
	}
}