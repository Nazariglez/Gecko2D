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
}