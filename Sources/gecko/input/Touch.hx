package gecko.input;

import gecko.Float32;
import gecko.math.Point;
import gecko.utils.Event;
import kha.input.Surface;

class Touch {
    static private var _instance:Touch = new Touch();

    static public var onPressed:Event<Int->Float32->Float32->Void>;
    static public var onReleased:Event<Int->Float32->Float32->Void>;
    static public var onDown:Event<Int->Float32->Float32->Void>;
    static public var onMove:Event<Int->Float32->Float32->Void>;

    static private var _pressed:Map<Int, Bool> = new Map();
    static private var _released:Map<Int, Bool> = new Map();
    static private var _down:Map<Int, Float32> = new Map();

    static public var pointers:Array<Point> = [];
    static private var _pointers:Map<Int, Point> = new Map();

    static public var isEnabled(default, null):Bool;

    private function new() {
        onPressed = Event.create();
        onReleased = Event.create();
        onDown = Event.create();
        onMove = Event.create();
    }

    static public function enable() {
        _pressed = new Map();
        _down = new Map();
        _released = new Map();

        Surface.get().notify(_downHandler, _upHandler, _moveHandler);

        isEnabled = true;

        Gecko.onUpdate += update;
    }

    static public function disable() {
        Gecko.onUpdate -= update;

        isEnabled = false;
        Surface.get().remove(_downHandler, _upHandler, _moveHandler);
    }

    /*static public function enableGestures() {
        //todo gestures
    }

    static public function disableGestures() {
        //todo gestures
    }*/

    inline static public function getPosition(touch:Int) : Point {
        return (_pointers.exists(touch)&&_down.exists(touch)) ? _pointers[touch] : null;
    }

    static public function update(delta:Float32) {
        for(index in _pressed.keys()) {
            onPressed.emit(index, _pointers[index].x, _pointers[index].y);
            _pressed.remove(index);
        }

        while(pointers.pop() != null){}

        for(index in _down.keys()) {
            _down[index] += Gecko.ticker.delta;
            onDown.emit(index, _pointers[index].x, _pointers[index].y);
            pointers[index] = _pointers[index];
        }

        for(index in _released.keys()) {
            onReleased.emit(index, _pointers[index].x, _pointers[index].y);
            _released.remove(index);
        }
    }

    inline static public function wasPressed(touch:Int) : Bool {
        return _pressed.exists(touch);
    }

    inline static public function wasReleased(touch:Int) : Bool {
        return _released.exists(touch);
    }

    static public function isDown(touch:Int, duration:Float32 = -1) : Bool {
        if(duration != -1) {
            return _down.exists(touch) && _down[touch] >= duration;
        }

        return _down.exists(touch);
    }

    inline static public function downDuration(touch:Int) : Float32 {
        return _down.exists(touch) ? _down[touch] : -1;
    }

    static public function isOverEntity(touch:Int, transform:Transform, cachePoint:Point = null) : Bool {
        var pos = getPosition(touch);
        if(pos == null){
            return false;
        }


        if(cachePoint == null)cachePoint = Point.create();

        transform.screenToLocal(pos, cachePoint);
        if(cachePoint.x > 0 && cachePoint.x < transform.size.x){
            if(cachePoint.y > 0 && cachePoint.y < transform.size.y){
                return true;
            }
        }

        return false;
    }

    static private function _downHandler(index:Int, x:Int, y:Int) {
        _pressed.set(index, true);
        _down.set(index, 0);

        if(!_pointers.exists(index)){
            _pointers.set(index, Point.create(0,0));
        }

        _pointers[index].set(x, y);
    }

    static private function _upHandler(index:Int, x:Int, y:Int) {
        _pressed.remove(index);
        _down.remove(index);

        _released.set(index, true);

        _pointers[index].set(x, y);
    }

    static private function _moveHandler(index:Int, x:Int, y:Int) {
        _pointers[index].set(x, y);
        onMove.emit(index, x, y);
    }
}