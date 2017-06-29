package prime;

import kha.Image;

class Sprite extends Actor {
	private var _image:Image;
	public var image(get, set):Image;

	public function new(image:Image) {
		super();
		this.image = image;
	}

	override function render(renderer:Renderer) : Void {
		super.render(renderer);
		renderer.drawImage(image, 0, 0);
		renderer.color = Color.Cyan;
		renderer.drawRect(0, 0, bounds.width, bounds.height, 1);
		renderer.color = Color.White;
	}

	public function get_image() : Image {
		return _image;
	}

	public function set_image(img:Image) : Image {
		size.set(img.width, img.height);
		return _image = img;
	}
}