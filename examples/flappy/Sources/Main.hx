package;

import gecko.ScreenMode;
import gecko.Gecko;

class Main {
	public static function main() {
		Gecko.init(_onReady, {
			width: 288,
			height: 512,
			maximizable: true,
			resizable: true,
			screen: {
				width: 288,
				height: 512,
				mode: ScreenMode.AspectFit
			}
		});
	}

	private static function _onReady() {
		var game = new Game();
	}
}
