import k2d.Game;
import k2d.math.Rect;

import kha.Framebuffer;

class Main extends Game {
	override public function onUpdate(delta: Float) {
		trace("u:", _loop.delta);
	}

	override public function onRender(framebuffer: Framebuffer) {
	}

	public static function main() {
		new Main("k2d game", Rect.fromRectangle(800, 600))
			.run();
	}
}
