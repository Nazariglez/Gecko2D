package;

import gecko.Gecko;

class Main {
	public static function main() {
		Gecko.init(_onReady, {
			width: 800,
			height: 600,
			bgColor: 0x26004d
		});
	}

	private static function _onReady() {
		var game = new Game();
	}
}
