package;

import kha.Framebuffer;
import kha.FastFloat;
import exp.Gecko;

class Main {
	public static function main() {
		Gecko.init(_onReady, _onRender, _onUpdate, {});
	}

	private static function _onReady() {
		trace("lel");
	}

	private static function _onRender(f:Framebuffer) {

	}

	private static function _onUpdate() {

	}
}
