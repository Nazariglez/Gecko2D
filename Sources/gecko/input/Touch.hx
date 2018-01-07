package gecko.input;

import gecko.utils.Event;
import gecko.math.Point;
import gecko.math.FastFloat;
import gecko.utils.EventEmitter;
import kha.input.Surface;

class Touch {
    static private var _instance:Touch = new Touch();

    static private inline var EVENT_PRESSED = "pressed";
    static private inline var EVENT_RELEASED = "released";
    static private inline var EVENT_DOWN = "down";
    static private inline var EVENT_MOVE = "move";

    static public var onPressed:Event<Int->Int->Int>;
    static public var onPressedOnce:Event<Int->Int->Int>;

    static public var onReleased:Event<Int->Int->Int>;
    static public var onReleasedOnce:Event<Int->Int->Int>;

    static public var onDown:Event<Int->Int->Int>;
    static public var onDownOnce:Event<Int->Int->Int>;

    static public var onMove:Event<Int->Int->Int>;
    static public var onMoveOnce:Event<Int->Int->Int>;

    static private var _eventEmitter:EventEmitter = new EventEmitter();
    static private var _pressed:Map<Int, Bool> = new Map<Int, Bool>();
    static private var _released:Map<Int, Bool> = new Map<Int, Bool>();
    static private var _down:Map<Int, FastFloat> = new Map<Int, FastFloat>();

    static public var pointers:Array<Point> = [];
    static private var _pointers:Map<Int, Point> = new Map<Int, Point>();

    static public var isEnabled(get, null):Bool;
    static private var _isEnabled:Bool = false;

    static private function _bindEvents() {
        if(_eventEmitter != null){
            onPressed = _eventEmitter.bind(new Event(EVENT_PRESSED));
            onPressedOnce = _eventEmitter.bind(new Event(EVENT_PRESSED, true));

            onReleased = _eventEmitter.bind(new Event(EVENT_RELEASED));
            onReleasedOnce = _eventEmitter.bind(new Event(EVENT_RELEASED, true));

            onDown = _eventEmitter.bind(new Event(EVENT_DOWN));
            onDownOnce = _eventEmitter.bind(new Event(EVENT_DOWN, true));

            onMove = _eventEmitter.bind(new Event(EVENT_MOVE));
            onMoveOnce = _eventEmitter.bind(new Event(EVENT_MOVE, true));
        }
    }

    private function new() {
        Touch._bindEvents();
    }

    static public function enable() {
        _pressed = new Map<Int, Bool>();
        _down = new Map<Int, FastFloat>();
        _released = new Map<Int, Bool>();

        Surface.get().notify(_downHandler, _upHandler, _moveHandler);

        _isEnabled = true;
    }

    static public function disable() {
        _isEnabled = false;
        Surface.get().remove(_downHandler, _upHandler, _moveHandler);
    }

    /*static public function enableGestures() {
        //todo gestures
    }

    static public function disableGestures() {
        //todo gestures
    }*/

    static public function getPosition(touch:Int) : Point {
        return (_pointers.exists(touch)&&_down.exists(touch)) ? _pointers[touch] : null;
    }

    static public function update(delta:FastFloat) {
        for(index in _pressed.keys()) {
            _eventEmitter.emit(EVENT_PRESSED, [index, _pointers[index].x, _pointers[index].y]);
            _pressed.remove(index);
        }

        while(pointers.length > 0){
            pointers.pop();
        }

        for(index in _down.keys()) {
            _down[index] += delta;
            _eventEmitter.emit(EVENT_DOWN, [index, _pointers[index].x, _pointers[index].y]);
            pointers[index] = _pointers[index];
        }

        for(index in _released.keys()) {
            _eventEmitter.emit(EVENT_RELEASED, [index, _pointers[index].x, _pointers[index].y]);
            _released.remove(index);
        }
    }

    static public function wasPressed(touch:Int) : Bool {
        return _pressed.exists(touch);
    }

    static public function wasReleased(touch:Int) : Bool {
        return _released.exists(touch);
    }

    static public function isDown(touch:Int, duration:FastFloat = -1) : Bool {
        if(duration != -1) {
            return _down.exists(touch) && _down[touch] >= duration;
        }

        return _down.exists(touch);
    }

    static public function downDuration(touch:Int) : FastFloat {
        return _down.exists(touch) ? _down[touch] : -1;
    }

    static public function isOverEntity(touch:Int, entity:Entity) : Bool {
        var pos = getPosition(touch);
        if(pos == null){
            return false;
        }

        return Mouse.isOverEntity(entity, pos);
    }

    static private function _downHandler(index:Int, x:Int, y:Int) {
        _pressed.set(index, true);
        _down.set(index, 0);

        if(!_pointers.exists(index)){
            _pointers.set(index, new Point(0,0));
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
        _eventEmitter.emit(EVENT_MOVE, [index, x, y]);
    }

    static function get_isEnabled():Bool {
        return _isEnabled;
    }
}