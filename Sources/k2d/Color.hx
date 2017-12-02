package k2d;

import kha.FastFloat;
import k2d.math.Random;

abstract Color(Int) from Int from UInt to Int to UInt {
	public static inline var BLACK: Color = 0x000000;
	public static inline var WHITE: Color = 0xFFFFFF;
	
	public static inline var RED: Color = 0xFF0000;
	public static inline var GREEN: Color = 0x00FF00;
	public static inline var BLUE: Color = 0x0000FF;

	public static inline var CYAN: Color = 0x00FFFF;
	public static inline var MAGENTA: Color = 0xFF00FF;
	public static inline var YELLOW: Color = 0xFFFF00;

	public static inline var PURPLE: Color = 0x800080;
	public static inline var PINK: Color = 0xFFC0CB;
	public static inline var ORANGE: Color = 0xFFA500;

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