package;

import gecko.Gecko;
import gecko.ScreenMode;

class Main {
	public static function main() {
		Gecko.init(_onReady, {
			width: 800,
			height: 600,
			bgColor: 0x26004d,
			maximizable: true,
			resizable: true,
			screen: {
				width: 800,
				height: 600,
				mode: ScreenMode.AspectFit
			}
		});
	}

	private static function _onReady() {
		var game = new Game();
	}
}
