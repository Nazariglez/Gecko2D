package k2d.math;

import kha.math.Vector2;

class Vec2Pool {
    static public var maxLen:Int = 500; //max objects stored
    static public var discard:Int = 3; //discard 1:N when put

    static private var _instance:Vec2Pool = new Vec2Pool();
    private var _objects:Array<Vector2> = [];
    private var _count:Int = 0;

    static public function get() : Vector2 {
        if(Vec2Pool._instance._objects.length > 0){
            var v = Vec2Pool._instance._objects.shift();
            v.x = 0;
            v.y = 0;
            return v;
        }

        return new Vector2(0, 0);
    }

    static public function put(v:Vector2) {
        if(Vec2Pool._instance._objects.length >= Vec2Pool.maxLen){
            return;
        }

        if(Vec2Pool.discard >= 0) {
            Vec2Pool._instance._count++;

            if((Vec2Pool._instance._count%Vec2Pool.discard) == 0){
                //discard this instance

                if(Vec2Pool._instance._count > Vec2Pool.maxLen){
                    Vec2Pool._instance._count = 0;
                }

                return;
            }
        }

        Vec2Pool._instance._objects.push(v);
    }

    static public function clean() {
        Vec2Pool._instance._objects = [];
    }

    static public function length() : Int {
        return Vec2Pool._instance._objects.length;
    }
    
    private function new(){}
}