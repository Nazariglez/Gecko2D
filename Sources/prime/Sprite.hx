package prime;

import kha.Image;
import kha.graphics2.Graphics;
import kha.Color;

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