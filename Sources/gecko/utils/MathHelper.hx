package gecko.utils;

class MathHelper {


    inline public static function toDegrees(radians:Float32) : Float32 {
        return radians * 180/Math.PI;
    }

    inline public static function toRadians(degrees:Float32) : Float32 {
        return degrees * Math.PI/180;
    }

    inline public static function clamp(value:Float32, min:Float32, max:Float32) : Float32 {
        return value < min ? min : value > max ? max : value;
    }

    inline public static function clampInt(value:Int, min:Int, max:Int) : Int {
        return value < min ? min : value > max ? max : value;
    }
}