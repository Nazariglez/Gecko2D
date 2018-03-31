package gecko.utils;

import gecko.math.Matrix;
class MathHelper {
    static private var _deg2rad:Float32 = Math.PI/180;
    static private var _rad2deg:Float32 = 180/Math.PI;

    inline public static function toDegrees(radians:Float32) : Float32 {
        return radians * MathHelper._rad2deg;
    }

    inline public static function toRadians(degrees:Float32) : Float32 {
        return degrees * MathHelper._deg2rad;
    }

    inline public static function clamp(value:Float32, min:Float32, max:Float32) : Float32 {
        return value < min ? min : value > max ? max : value;
    }

    inline public static function clampInt(value:Int, min:Int, max:Int) : Int {
        return value < min ? min : value > max ? max : value;
    }

    inline public static function lerp(value:Float32, start:Float32, end:Float32) : Float32 {
        return (1 - value) * start + value * end;
    }

    inline public static function inverseLerp(value:Float32, start:Float32, end:Float32) : Float32 {
        return (value-start)/(end-start);
    }
}