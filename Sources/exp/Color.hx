package exp;

import gecko.math.Random;
import kha.FastFloat;

abstract Color(Int) from Int from UInt to Int to UInt {
	public static inline var AliceBlue : Color = 0xF0F8FF;
	public static inline var AntiqueWhite : Color = 0xFAEBD7;
	public static inline var Aqua : Color = 0x00FFFF;
	public static inline var Aquamarine : Color = 0x7FFFD4;
	public static inline var Azure : Color = 0xF0FFFF;
	public static inline var Beige : Color = 0xF5F5DC;
	public static inline var Bisque : Color = 0xFFE4C4;
	public static inline var Black : Color = 0x000000;
	public static inline var BlanchedAlmond : Color = 0xFFEBCD;
	public static inline var Blue : Color = 0x0000FF;
	public static inline var BlueViolet : Color = 0x8A2BE2;
	public static inline var Brown : Color = 0xA52A2A;
	public static inline var BurlyWood : Color = 0xDEB887;
	public static inline var CadetBlue : Color = 0x5F9EA0;
	public static inline var Chartreuse : Color = 0x7FFF00;
	public static inline var Chocolate : Color = 0xD2691E;
	public static inline var Coral : Color = 0xFF7F50;
	public static inline var CornflowerBlue : Color = 0x6495ED;
	public static inline var Cornsilk : Color = 0xFFF8DC;
	public static inline var Crimson : Color = 0xDC143C;
	public static inline var Cyan : Color = 0x00FFFF;
	public static inline var DarkBlue : Color = 0x00008B;
	public static inline var DarkCyan : Color = 0x008B8B;
	public static inline var DarkGoldenRod : Color = 0xB8860B;
	public static inline var DarkGray : Color = 0xA9A9A9;
	public static inline var DarkGrey : Color = 0xA9A9A9;
	public static inline var DarkGreen : Color = 0x006400;
	public static inline var DarkKhaki : Color = 0xBDB76B;
	public static inline var DarkMagenta : Color = 0x8B008B;
	public static inline var DarkOliveGreen : Color = 0x556B2F;
	public static inline var DarkOrange : Color = 0xFF8C00;
	public static inline var DarkOrchid : Color = 0x9932CC;
	public static inline var DarkRed : Color = 0x8B0000;
	public static inline var DarkSalmon : Color = 0xE9967A;
	public static inline var DarkSeaGreen : Color = 0x8FBC8F;
	public static inline var DarkSlateBlue : Color = 0x483D8B;
	public static inline var DarkSlateGray : Color = 0x2F4F4F;
	public static inline var DarkSlateGrey : Color = 0x2F4F4F;
	public static inline var DarkTurquoise : Color = 0x00CED1;
	public static inline var DarkViolet : Color = 0x9400D3;
	public static inline var DeepPink : Color = 0xFF1493;
	public static inline var DeepSkyBlue : Color = 0x00BFFF;
	public static inline var DimGray : Color = 0x696969;
	public static inline var DimGrey : Color = 0x696969;
	public static inline var DodgerBlue : Color = 0x1E90FF;
	public static inline var FireBrick : Color = 0xB22222;
	public static inline var FloralWhite : Color = 0xFFFAF0;
	public static inline var ForestGreen : Color = 0x228B22;
	public static inline var Fuchsia : Color = 0xFF00FF;
	public static inline var Gainsboro : Color = 0xDCDCDC;
	public static inline var GhostWhite : Color = 0xF8F8FF;
	public static inline var Gold : Color = 0xFFD700;
	public static inline var GoldenRod : Color = 0xDAA520;
	public static inline var Gray : Color = 0x808080;
	public static inline var Grey : Color = 0x808080;
	public static inline var Green : Color = 0x008000;
	public static inline var GreenYellow : Color = 0xADFF2F;
	public static inline var HoneyDew : Color = 0xF0FFF0;
	public static inline var HotPink : Color = 0xFF69B4;
	public static inline var IndianRed : Color = 0xCD5C5C;
	public static inline var Indigo  : Color = 0x4B0082;
	public static inline var Ivory : Color = 0xFFFFF0;
	public static inline var Khaki : Color = 0xF0E68C;
	public static inline var Lavender : Color = 0xE6E6FA;
	public static inline var LavenderBlush : Color = 0xFFF0F5;
	public static inline var LawnGreen : Color = 0x7CFC00;
	public static inline var LemonChiffon : Color = 0xFFFACD;
	public static inline var LightBlue : Color = 0xADD8E6;
	public static inline var LightCoral : Color = 0xF08080;
	public static inline var LightCyan : Color = 0xE0FFFF;
	public static inline var LightGoldenRodYellow : Color = 0xFAFAD2;
	public static inline var LightGray : Color = 0xD3D3D3;
	public static inline var LightGrey : Color = 0xD3D3D3;
	public static inline var LightGreen : Color = 0x90EE90;
	public static inline var LightPink : Color = 0xFFB6C1;
	public static inline var LightSalmon : Color = 0xFFA07A;
	public static inline var LightSeaGreen : Color = 0x20B2AA;
	public static inline var LightSkyBlue : Color = 0x87CEFA;
	public static inline var LightSlateGray : Color = 0x778899;
	public static inline var LightSlateGrey : Color = 0x778899;
	public static inline var LightSteelBlue : Color = 0xB0C4DE;
	public static inline var LightYellow : Color = 0xFFFFE0;
	public static inline var Lime : Color = 0x00FF00;
	public static inline var LimeGreen : Color = 0x32CD32;
	public static inline var Linen : Color = 0xFAF0E6;
	public static inline var Magenta : Color = 0xFF00FF;
	public static inline var Maroon : Color = 0x800000;
	public static inline var MediumAquaMarine : Color = 0x66CDAA;
	public static inline var MediumBlue : Color = 0x0000CD;
	public static inline var MediumOrchid : Color = 0xBA55D3;
	public static inline var MediumPurple : Color = 0x9370DB;
	public static inline var MediumSeaGreen : Color = 0x3CB371;
	public static inline var MediumSlateBlue : Color = 0x7B68EE;
	public static inline var MediumSpringGreen : Color = 0x00FA9A;
	public static inline var MediumTurquoise : Color = 0x48D1CC;
	public static inline var MediumVioletRed : Color = 0xC71585;
	public static inline var MidnightBlue : Color = 0x191970;
	public static inline var MintCream : Color = 0xF5FFFA;
	public static inline var MistyRose : Color = 0xFFE4E1;
	public static inline var Moccasin : Color = 0xFFE4B5;
	public static inline var NavajoWhite : Color = 0xFFDEAD;
	public static inline var Navy : Color = 0x000080;
	public static inline var OldLace : Color = 0xFDF5E6;
	public static inline var Olive : Color = 0x808000;
	public static inline var OliveDrab : Color = 0x6B8E23;
	public static inline var Orange : Color = 0xFFA500;
	public static inline var OrangeRed : Color = 0xFF4500;
	public static inline var Orchid : Color = 0xDA70D6;
	public static inline var PaleGoldenRod : Color = 0xEEE8AA;
	public static inline var PaleGreen : Color = 0x98FB98;
	public static inline var PaleTurquoise : Color = 0xAFEEEE;
	public static inline var PaleVioletRed : Color = 0xDB7093;
	public static inline var PapayaWhip : Color = 0xFFEFD5;
	public static inline var PeachPuff : Color = 0xFFDAB9;
	public static inline var Peru : Color = 0xCD853F;
	public static inline var Pink : Color = 0xFFC0CB;
	public static inline var Plum : Color = 0xDDA0DD;
	public static inline var PowderBlue : Color = 0xB0E0E6;
	public static inline var Purple : Color = 0x800080;
	public static inline var RebeccaPurple : Color = 0x663399;
	public static inline var Red : Color = 0xFF0000;
	public static inline var RosyBrown : Color = 0xBC8F8F;
	public static inline var RoyalBlue : Color = 0x4169E1;
	public static inline var SaddleBrown : Color = 0x8B4513;
	public static inline var Salmon : Color = 0xFA8072;
	public static inline var SandyBrown : Color = 0xF4A460;
	public static inline var SeaGreen : Color = 0x2E8B57;
	public static inline var SeaShell : Color = 0xFFF5EE;
	public static inline var Sienna : Color = 0xA0522D;
	public static inline var Silver : Color = 0xC0C0C0;
	public static inline var SkyBlue : Color = 0x87CEEB;
	public static inline var SlateBlue : Color = 0x6A5ACD;
	public static inline var SlateGray : Color = 0x708090;
	public static inline var SlateGrey : Color = 0x708090;
	public static inline var Snow : Color = 0xFFFAFA;
	public static inline var SpringGreen : Color = 0x00FF7F;
	public static inline var SteelBlue : Color = 0x4682B4;
	public static inline var Tan : Color = 0xD2B48C;
	public static inline var Teal : Color = 0x008080;
	public static inline var Thistle : Color = 0xD8BFD8;
	public static inline var Tomato : Color = 0xFF6347;
	public static inline var Turquoise : Color = 0x40E0D0;
	public static inline var Violet : Color = 0xEE82EE;
	public static inline var Wheat : Color = 0xF5DEB3;
	public static inline var White : Color = 0xFFFFFF;
	public static inline var WhiteSmoke : Color = 0xF5F5F5;
	public static inline var Yellow : Color = 0xFFFF00;
	public static inline var YellowGreen : Color = 0x9ACD32;

	private static inline var invMaxChannelValue: FastFloat = 1 / 255;

	//todo add more colors
	//todo added utilities like multiply, screen, saturate, etc...

	private function new(value: Int) {
		this = value;
	}

	inline public static function fromValue(value: Int): Color {
		return new Color(value);
	}

	inline public static function fromBytes(r:Int, g:Int, b:Int) : Int {
		return (r << 16) | (g << 8) | b;
	}

	inline public static function fromFloats(r: FastFloat, g: FastFloat, b: FastFloat): Int {
		return (Std.int(r * 255) << 16) | (Std.int(g * 255) << 8) | Std.int(b * 255);
	}

	inline public static function random() : Color {
		return fromBytes(Random.getUpTo(255), Random.getUpTo(255), Random.getUpTo(255));
	}

	public static function fromString(value: String) {
		if ((value.length == 7) && StringTools.fastCodeAt(value, 0) == "#".code) {
			var colorValue = Std.parseInt("0x" + value.substr(1));
			return fromValue(colorValue);
		} else {
			throw "Invalid Color string: '" + value + "'";
		}
	}

	@:to inline public function toARGB() : kha.Color {
		return this + 0xFF000000;
	}

	public var RedByte(get, set):Int;
	
	private inline function get_RedByte(): Int {
		return (this & 0xff0000) >>> 16;
	}

	private inline function set_RedByte(i: Int): Int {
		this = (i << 16) | (GreenByte << 8) | BlueByte;
		return i;
	}
	
	public var GreenByte(get, set):Int;

	private inline function get_GreenByte(): Int {
		return (this & 0x00ff00) >>> 8;
	}

	private inline function set_GreenByte(i: Int): Int {
		this = (RedByte << 16) | (i << 8) | BlueByte;
		return i;
	}
	
	public var BlueByte(get, set):Int;
	private inline function get_BlueByte(): Int {
		return this & 0x0000ff;
	}
	
	private inline function set_BlueByte(i: Int): Int {
		this = (RedByte << 16) | (GreenByte << 8) | i;
		return i;
	}

	public var RedValue(get, set):FastFloat;
	
	private inline function get_RedValue() : FastFloat {
		return get_RedByte() * invMaxChannelValue;
	}

	private inline function set_RedValue(f: FastFloat): FastFloat {
		this = (Std.int(f * 255) << 16) | (Std.int(GreenValue * 255) << 8) | Std.int(BlueValue * 255);
		return f;
	}

	public var GreenValue(get, set):FastFloat;
	
	private inline function get_GreenValue() : FastFloat {
		return get_GreenByte() * invMaxChannelValue;
	}

	private inline function set_GreenValue(f: FastFloat): FastFloat {
		this = (Std.int(RedValue * 255) << 16) | (Std.int(f * 255) << 8) | Std.int(BlueValue * 255);
		return f;
	}

	public var BlueValue(get, set):FastFloat;
	
	private inline function get_BlueValue() : FastFloat {
		return get_BlueByte() * invMaxChannelValue;
	}

	private inline function set_BlueValue(f: FastFloat): FastFloat {
		this = (Std.int(RedValue * 255) << 16) | (Std.int(GreenValue * 255) << 8) | Std.int(f * 255);
		return f;
	}
}