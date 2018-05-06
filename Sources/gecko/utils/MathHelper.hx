package gecko.utils;

import gecko.math.Matrix;
class MathHelper {
    static private var _deg2rad:Float = Math.PI/180;
    static private var _rad2deg:Float = 180/Math.PI;

    inline public static function toDegrees(radians:Float) : Float {
        return radians * MathHelper._rad2deg;
    }

    inline public static function toRadians(degrees:Float) : Float {
        return degrees * MathHelper._deg2rad;
    }

    inline public static function clamp(value:Float, min:Float, max:Float) : Float {
        return value < min ? min : value > max ? max : value;
    }

    inline public static function clampInt(value:Int, min:Int, max:Int) : Int {
        return value < min ? min : value > max ? max : value;
    }

    inline public static function lerp(value:Float, start:Float, end:Float) : Float {
        return (1 - value) * start + value * end;
    }

    inline public static function inverseLerp(value:Float, start:Float, end:Float) : Float {
        return (value-start)/(end-start);
    }

    inline public static function inheritTransform(matrix:Matrix, child:Matrix, parent:Matrix) {
        matrix._00 = (child._00 * parent._00) + (child._01 * parent._10);
        matrix._01 = (child._00 * parent._01) + (child._01 * parent._11);
        matrix._10 = (child._10 * parent._00) + (child._11 * parent._10);
        matrix._11 = (child._10 * parent._01) + (child._11 * parent._11);

        matrix._20 = (child._20 * parent._00) + (child._21 * parent._10) + parent._20;
        matrix._21 = (child._20 * parent._01) + (child._21 * parent._11) + parent._21;

    }
}