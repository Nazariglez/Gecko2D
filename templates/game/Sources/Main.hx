package;

import gecko.Gecko;
import gecko.GeckoOptions;

class Main {
	public static function main() {
		var options:GeckoOptions = {
			width: 800,
			height: 600
		};
		Gecko.init(Game, options);
	}
}
