package;

import gecko.Gecko;

class Main {
	public static function main() {
		Gecko.init(_onReady, {
			width: 800, 
			height: 600,
			maximizable: true,
			resizable: true,
			screen: {
				width: 800,
				height: 600,
				mode: gecko.ScreenMode.AspectFit
			}
		});
	}

	private static function _onReady() {
		var game = new Game();
	}
}
