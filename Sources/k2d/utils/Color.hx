package k2d.utils;

import kha.FastFloat;

abstract Color(Int) from Int from UInt to Int to UInt {
	public static inline var BLACK: Color = 0x000000;
	public static inline var WHITE: Color = 0xffffff;
	
	public static inline var RED: Color = 0xff0000;
	public static inline var GREEN: Color = 0x00ff00;
	public static inline var BLUE: Color = 0x0000ff;

	public static inline var CYAN: Color = 0x00ffff;
	public static inline var MAGENTA: Color = 0xff00ff;
	public static inline var YELLOW: Color = 0xffff00;

	public static inline var PURPLE: Color = 0x800080;
	public static inline var PINK: Color = 0xffc0cb;
	public static inline var ORANGE: Color = 0xffa500;

	//todo add more colors
	//todo added utilities like multiply, screen, saturate, etc...

	public static inline function fromBytes(r:Int, g:Int, b:Int) : Int {
		return (r << 16) | (g << 8) | b;
	}

	public static function fromFloats(r: FastFloat, g: FastFloat, b: FastFloat): Int {
		return (Std.int(r * 255) << 16) | (Std.int(g * 255) << 8) | Std.int(b * 255);
	}
}