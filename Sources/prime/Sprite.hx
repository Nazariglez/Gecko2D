package prime;

import kha.Image;

class Sprite extends Actor {
	public var image:Image;

	public function new(image:Image) {
		super();
		this.image = image;
	}

	override function render(renderer:Renderer) : Void {
		super.render(renderer);
		renderer.drawImage(image, 0, 0);
	}

	override function calculateBounds() : Void {
		if(image != null){
			_bounds.x = -image.width * anchor.x;
			_bounds.y = -image.height * anchor.y;
			_bounds.width = _bounds.x + image.width;
			_bounds.height = _bounds.y + image.height;
		}
	}

	override function get_width() : Int {
		if(image == null){
			return 0;
		}

		return image.width;
	}

	override function get_height() : Int {
		if(image == null) {
			return 0;
		}

		return image.height;
	}
}