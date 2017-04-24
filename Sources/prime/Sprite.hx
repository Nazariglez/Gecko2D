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

	override function render(graphics:Graphics) : Void {
		super.render(graphics);
		graphics.drawImage(image, 0, 0);
	}
}