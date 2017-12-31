package gecko.tween;

import gecko.math.FastFloat;

class Easing {
    static public function linear() : Ease {
        return function(t:FastFloat) : FastFloat {
            return t;
        }
    }

    static public function inQuad() : Ease {
        return function(t:FastFloat) : FastFloat {
            return t*t;
        }
    }

    static public function outQuad() : Ease {
        return function(t:FastFloat) : FastFloat {
            return t*(2-t);
        }
    }

    static public function inOutQuad() : Ease {
        return function(t:FastFloat) : FastFloat {
            t *= 2;
            if ( t < 1 ) return 0.5 * t * t;
            return - 0.5 * ( --t * ( t - 2 ) - 1 );
        }
    }

    static public function inCubic() : Ease {
        return function(t:FastFloat) : FastFloat {
            return t * t * t;
        }
    }

    static public function outCubic() : Ease {
        return function(t:FastFloat) : FastFloat {
            return --t * t * t + 1;
        }
    }

    static public function inOutCubic() : Ease {
        return function(t:FastFloat) : FastFloat {
            t *= 2;
            if ( t < 1 ) return 0.5 * t * t * t;
            t -= 2;
            return 0.5 * ( t * t * t + 2 );
        }
    }

    static public function inQuart() : Ease {
        return function(t:FastFloat) : FastFloat {
            return t * t * t * t;
        }
    }

    static public function outQuart() : Ease {
        return function(t:FastFloat) : FastFloat {
            return 1 - ( --t * t * t * t );
        }
    }

    static public function inOutQuart() : Ease {
        return function(t:FastFloat) : FastFloat {
            t *= 2;
            if ( t < 1) return 0.5 * t * t * t * t;
            t -= 2;
            return - 0.5 * ( t * t * t * t - 2 );
        }
    }

    static public function inQuint() : Ease {
        return function(t:FastFloat) : FastFloat {
            return t * t * t * t * t;
        }
    }

    static public function outQuint() : Ease {
        return function(t:FastFloat) : FastFloat {
            return --t * t * t * t * t + 1;
        }
    }

    static public function inOutQuint() : Ease {
        return function(t:FastFloat) : FastFloat {
            t *= 2;
            if ( t < 1 ) return 0.5 * t * t * t * t * t;
            t -= 2;
            return 0.5 * ( t * t * t * t * t + 2 );
        }
    }

    static public function inSine() : Ease {
        return function(t:FastFloat) : FastFloat {
            return 1 - Math.cos( t * Math.PI / 2 );
        }
    }

    static public function outSine() : Ease {
        return function(t:FastFloat) : FastFloat {
            return Math.sin( t * Math.PI / 2 );
        }
    }

    static public function inOutSine() : Ease {
        return function(t:FastFloat) : FastFloat {
            return 0.5 * ( 1 - Math.cos( Math.PI * t ) );
        }
    }

    static public function inExpo() : Ease {
        return function(t:FastFloat) : FastFloat {
            return t == 0 ? 0 : Math.pow( 1024, t - 1 );
        }
    }

    static public function outExpo() : Ease {
        return function(t:FastFloat) : FastFloat {
            return t == 1 ? 1 : 1 - Math.pow( 2, - 10 * t );
        }
    }

    static public function inOutExpo() : Ease {
        return function(t:FastFloat) : FastFloat {
            if ( t == 0 ) return 0;
            if ( t == 1 ) return 1;
            t *= 2;
            if ( t < 1 ) return 0.5 * Math.pow( 1024, t - 1 );
            return 0.5 * ( - Math.pow( 2, - 10 * ( t - 1 ) ) + 2 );
        }
    }

    static public function inCirc() : Ease {
        return function(t:FastFloat) : FastFloat {
            return 1 - Math.sqrt( 1 - t * t );
        }
    }

    static public function outCirc() : Ease {
        return function(t:FastFloat) : FastFloat {
            return Math.sqrt( 1 - ( --t * t ) );
        }
    }

    static public function inOutCirc() : Ease {
        return function(t:FastFloat) : FastFloat {
            t *= 2;
            if ( t < 1) return - 0.5 * ( Math.sqrt( 1 - t * t) - 1);
            return 0.5 * ( Math.sqrt( 1 - (t - 2) * (t - 2)) + 1);
        }
    }

    static public function inElastic(a : FastFloat = 0.1, p : FastFloat = 0.4) : Ease {
        return function(t:FastFloat) : FastFloat {
            if ( t == 0 ) return 0;
            if ( t == 1 ) return 1;
            
            var s:FastFloat;

            if ( a < 1 ) { 
                a = 1; 
                s = p / 4; 
            }else{
                s = p * Math.asin( 1 / a ) / ( 2 * Math.PI );
            }
            return - ( a * Math.pow( 2, 10 * (t-1) ) * Math.sin( ( (t-1) - s ) * ( 2 * Math.PI ) / p ) );
        }
    }

    static public function outElastic(a : FastFloat = 0.1, p : FastFloat = 0.4) : Ease {
        return function(t:FastFloat) : FastFloat {
            if ( t == 0 ) return 0;
            if ( t == 1 ) return 1;
            
            var s:FastFloat;

            if ( a < 1 ) { 
                a = 1;
                s = p / 4;
            }else{
                s = p * Math.asin( 1 / a ) / ( 2 * Math.PI );
            }
            return ( a * Math.pow( 2, - 10 * t) * Math.sin( ( t - s ) * ( 2 * Math.PI ) / p ) + 1 );
        }
    }

    static public function inOutElastic(a : FastFloat = 0.1, p : FastFloat = 0.4) : Ease {
        return function(t:FastFloat) : FastFloat {
            if ( t == 0 ) return 0;
            if ( t == 1 ) return 1;
            
            var s:FastFloat;

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
    }

    static public function inBack(v : FastFloat = 1.70158) : Ease {
        return function(t:FastFloat) : FastFloat {
            return t * t * ( ( v + 1 ) * t - v );
        }
    }

    static public function outBack(v : FastFloat = 1.70158) : Ease {
        return function(t:FastFloat) : FastFloat {
            return --t * t * ( ( v + 1 ) * t + v ) + 1;
        }
    }

    static public function inOutBack(v : FastFloat = 1.70158) : Ease {
        return function(t:FastFloat) : FastFloat {
            var s = v*1.525;
            t *= 2;
            if ( t < 1 ) {
                return 0.5 * ( t * t * ( ( s + 1 ) * t - s ) );
            }

            return 0.5 * ( ( t - 2 ) * (t-2) * ( ( s + 1 ) * (t-2) + s ) + 2 );
        }
    }

    static public function inBounce() : Ease {
        return function(t:FastFloat) : FastFloat {
            return 1 - Easing.outBounce()( 1 - t );
        }
    }

    static public function outBounce() : Ease {
        return function(t:FastFloat) : FastFloat {
            if ( t < ( 1 / 2.75 ) ) {
                return 7.5625 * t * t;
            } else if ( t < ( 2 / 2.75 ) ) {
                t = ( t - ( 1.5 / 2.75 ) );
                return 7.5625 * t * t + 0.75;
            } else if ( t < ( 2.5 / 2.75 ) ) {
                t = (t - ( 2.25 / 2.75 ));
                return 7.5625 * t * t + 0.9375;
            } else {
                t -= ( 2.625 / 2.75 );
                return 7.5625 * t * t + 0.984375;
            }
        }
    }

    static public function inOutBounce() : Ease {
        return function(t:FastFloat) : FastFloat {
             if ( t < 0.5 ) {
                 return Easing.inBounce()( t * 2 ) * 0.5;
             }
            return Easing.outBounce()( t * 2 - 1 ) * 0.5 + 0.5;
        }
    }
}