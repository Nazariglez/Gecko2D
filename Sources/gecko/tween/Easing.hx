package gecko.tween;



class Easing {
    inline static public function linear(t:Float) : Float {
        return t;
    }

    inline static public function inQuad(t:Float) : Float {
        return t*t;
    }

    inline static public function outQuad(t:Float) : Float {
        return t*(2-t);
    }

    static public function inOutQuad(t:Float) : Float {
        t *= 2;
        if ( t < 1 ) return 0.5 * t * t;
        return - 0.5 * ( --t * ( t - 2 ) - 1 );
    }

    inline static public function inCubic(t:Float) : Float {
        return t * t * t;
    }

    inline static public function outCubic(t:Float) : Float {
        return --t * t * t + 1;
    }

    static public function inOutCubic(t:Float) : Float {
        t *= 2;
        if ( t < 1 ) return 0.5 * t * t * t;
        t -= 2;
        return 0.5 * ( t * t * t + 2 );
    }

    inline static public function inQuart(t:Float) : Float {
        return t * t * t * t;
    }

    inline static public function outQuart(t:Float) : Float {
        return 1 - ( --t * t * t * t );
    }

    static public function inOutQuart(t:Float) : Float {
        t *= 2;
        if ( t < 1) return 0.5 * t * t * t * t;
        t -= 2;
        return - 0.5 * ( t * t * t * t - 2 );
    }

    inline static public function inQuint(t:Float) : Float {
        return t * t * t * t * t;
    }

    inline static public function outQuint(t:Float) : Float {
        return --t * t * t * t * t + 1;
    }

    static public function inOutQuint(t:Float) : Float {
        t *= 2;
        if ( t < 1 ) return 0.5 * t * t * t * t * t;
        t -= 2;
        return 0.5 * ( t * t * t * t * t + 2 );
    }

    static public function inSine(t:Float) : Float {
        return 1 - Math.cos( t * Math.PI / 2 );
    }

    inline static public function outSine(t:Float) : Float {
        return Math.sin( t * Math.PI / 2 );
    }

    inline static public function inOutSine(t:Float) : Float {
        return 0.5 * ( 1 - Math.cos( Math.PI * t ) );
    }

    inline static public function inExpo(t:Float) : Float {
        return t == 0 ? 0 : Math.pow( 1024, t - 1 );
    }

    inline static public function outExpo(t:Float) : Float {
        return t == 1 ? 1 : 1 - Math.pow( 2, - 10 * t );
    }

    static public function inOutExpo(t:Float) : Float {
        if ( t == 0 ) return 0;
        if ( t == 1 ) return 1;
        t *= 2;
        if ( t < 1 ) return 0.5 * Math.pow( 1024, t - 1 );
        return 0.5 * ( - Math.pow( 2, - 10 * ( t - 1 ) ) + 2 );
    }

    inline static public function inCirc(t:Float) : Float {
        return 1 - Math.sqrt( 1 - t * t );
    }

    inline static public function outCirc(t:Float) : Float {
        return Math.sqrt( 1 - ( --t * t ) );
    }

    static public function inOutCirc(t:Float) : Float {
        t *= 2;
        if ( t < 1) return - 0.5 * ( Math.sqrt( 1 - t * t) - 1);
        return 0.5 * ( Math.sqrt( 1 - (t - 2) * (t - 2)) + 1);
    }

    static public function inElastic(t:Float) : Float {
        if ( t == 0 ) return 0;
        if ( t == 1 ) return 1;

        var s:Float;
        var a:Float = 1;
        var p:Float = 0.4;

        if ( a <= 1 ) {
            a = 1;
            s = p / 4;
        }else{
            s = p * Math.asin( 1 / a ) / ( 2 * Math.PI );
        }
        return - ( a * Math.pow( 2, 10 * (t-1) ) * Math.sin( ( (t-1) - s ) * ( 2 * Math.PI ) / p ) );
    }

    static public function outElastic(t:Float) : Float {
        if ( t == 0 ) return 0;
        if ( t == 1 ) return 1;

        var s:Float;
        var a:Float = 1;
        var p:Float = 0.4;

        if ( a <= 1 ) {
            a = 1;
            s = p / 4;
        }else{
            s = p * Math.asin( 1 / a ) / ( 2 * Math.PI );
        }
        return ( a * Math.pow( 2, - 10 * t) * Math.sin( ( t - s ) * ( 2 * Math.PI ) / p ) + 1 );
    }

    static public function inOutElastic(t:Float) : Float {
        if ( t == 0 ) return 0;
        if ( t == 1 ) return 1;

        var s:Float;
        var a:Float = 1;
        var p:Float = 0.4;

        if ( a < 1 ) {
            a = 1;
            s = p / 4;
        }else{
            s = p * Math.asin( 1 / a ) / ( 2 * Math.PI );
        }

        t *= 2;
        if ( t < 1 ){
            return - 0.5 * ( a * Math.pow( 2, 10 * ( t - 1 ) ) * Math.sin( ( (t-1) - s ) * ( 2 * Math.PI ) / p ) );
        }
        return a * Math.pow( 2, -10 * ( t - 1 ) ) * Math.sin( ( (t-1) - s ) * ( 2 * Math.PI ) / p ) * 0.5 + 1;
    }

    inline static public function inBack(t:Float) : Float {
        return t * t * ( ( 1.70158 + 1 ) * t - 1.70158 );
    }

    inline static public function outBack(t:Float) : Float {
        return --t * t * ( ( 1.70158 + 1 ) * t + 1.70158 ) + 1;
    }

    static public function inOutBack(t:Float) : Float {
        var v = 1.70158;
        var s = v*1.525;
        t *= 2;
        if ( t < 1 ) {
            return 0.5 * ( t * t * ( ( s + 1 ) * t - s ) );
        }

        return 0.5 * ( ( t - 2 ) * (t-2) * ( ( s + 1 ) * (t-2) + s ) + 2 );
    }

    inline static public function inBounce(t:Float) : Float {
        return 1 - Easing.outBounce( 1 - t );
    }

    static public function outBounce(t:Float) : Float {
        if ( t < ( 1 / 2.75 ) ) {
            return 7.5625 * t * t;
        } else if ( t < ( 2 / 2.75 ) ) {
            t = ( t - ( 1.5 / 2.75 ) );
            return 7.5625 * t * t + 0.75;
        } else if ( t < ( 2.5 / 2.75 ) ) {
            t = (t - ( 2.25 / 2.75 ));
            return 7.5625 * t * t + 0.9375;
        }

        t -= ( 2.625 / 2.75 );
        return 7.5625 * t * t + 0.984375;
    }

    static public function inOutBounce(t:Float) : Float {
         if ( t < 0.5 ) {
             return Easing.inBounce( t * 2 ) * 0.5;
         }
        return Easing.outBounce( t * 2 - 1 ) * 0.5 + 0.5;
    }
}