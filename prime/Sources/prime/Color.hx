package prime;

import kha.FastFloat;

abstract Color(Int) from Int from UInt to Int to UInt {
	public static inline var Black: Color = 0x000000;
	public static inline var White: Color = 0xffffff;
	public static inline var Red: Color = 0xff0000;
	public static inline var Blue: Color = 0x0000ff;
	public static inline var Green: Color = 0x00ff00;
	public static inline var Magenta: Color = 0xff00ff;
	public static inline var Yellow: Color = 0xffff00;
	public static inline var Cyan: Color = 0x00ffff;
	public static inline var Purple: Color = 0x800080;
	public static inline var Pink: Color = 0xffc0cb;
	public static inline var Orange: Color = 0xffa500;

	//todo add more colors
	//todo added utilities like multiply, screen, saturate, etc...

	public static inline function fromBytes(r:Int, g:Int, b:Int) : Int {
		return (r << 16) | (g << 8) | b;
	}

	public static function fromFloats(r: FastFloat, g: FastFloat, b: FastFloat): Int {
		return (Std.int(r * 255) << 16) | (Std.int(g * 255) << 8) | Std.int(b * 255);
	}
}