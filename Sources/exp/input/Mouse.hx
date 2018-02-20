package exp.input;

import exp.utils.Event;
import kha.input.Mouse as KhaMouse;
import exp.math.Point;
import exp.Float32;

class Mouse {
    static public var isEnabled(default, null):Bool = false;
    static public var isLocked(get, null):Bool;

    static public var position:Point = Point.create(0, 0);
    static public var x(get, set):Float32;
    static public var y(get, set):Float32;

    static public var movementX:Int = 0;
    static public var movementY:Int = 0;

    static public var onRightPressed:Event<Int->Int->Void>;
    static public var onRightReleased:Event<Int->Int->Void>;
    static public var onRightDown:Event<Int->Int->Void>;

    static public var onLeftPressed:Event<Int->Int->Void>;
    static public var onLeftReleased:Event<Int->Int->Void>;
    static public var onLeftDown:Event<Int->Int->Void>;

    static public var onCenterPressed:Event<Int->Int->Void>;
    static public var onCenterReleased:Event<Int->Int->Void>;
    static public var onCenterDown:Event<Int->Int->Void>;

    static public var onWheelMove:Event<Int->Void>;
    static public var onMove:Event<Int->Int->Void>;

    static private var _pressedButtons:Map<MouseButton, Bool> = new Map<MouseButton, Bool>();
    static private var _releasedButtons:Map<MouseButton, Bool> = new Map<MouseButton, Bool>();
    static private var _downButtons:Map<MouseButton, Float32> = new Map<MouseButton, Float32>();

    static public function enable() {
        _pressedButtons = [MouseButton.LEFT => false, MouseButton.CENTER => false, MouseButton.RIGHT => false];
        _downButtons = [MouseButton.LEFT => -1, MouseButton.CENTER => -1, MouseButton.RIGHT => -1];
        _releasedButtons = [MouseButton.LEFT => false, MouseButton.CENTER => false, MouseButton.RIGHT => false];

        KhaMouse.get().notify(_buttonDownHandler, _buttonUpHandler, _moveHandler, _wheelHandler, _leaveHandler);
        isEnabled = true;

        Gecko.onUpdate += _update;
    }

    static public function disable() {
        Gecko.onUpdate -= _update;

        KhaMouse.get().remove(_buttonDownHandler, _buttonUpHandler, _moveHandler, _wheelHandler, _leaveHandler);
        isEnabled = false;
    }

    static public function _update(dt:Float32) {

    }

    inline static public function wasPressed(button:MouseButton) : Bool {
        return _pressedButtons[button];
    }

    inline static public function wasReleased(button:MouseButton) : Bool {
        return _releasedButtons[button];
    }

    static private function _buttonDownHandler(button:Int, x:Int, y:Int) {
        position.x = x;
        position.y = y;
        _pressedButtons.set(button, true);
        _downButtons.set(button, 0);
    }

    static private function _buttonUpHandler(button:Int, x:Int, y:Int) {
        position.x = x;
        position.y = y;
        _pressedButtons.set(button, false);
        _downButtons.set(button, -1);
        _releasedButtons.set(button, true);
    }

    static public function isDown(button:MouseButton, duration:Float32 = -1) : Bool {
        if(duration != -1){
            return _downButtons[button] != -1 && _downButtons[button] <= duration;
        }
        return _downButtons[button] != -1;
    }

    inline static public function downDuration(button:MouseButton) : FastFloat {
        return _downButtons[button];
    }

    inline static function get_x():Float32 {
        return position.x;
    }

    inline static function set_x(value:Float32):Float32 {
        return position.x = value;
    }

    inline static function set_y(value:Float32):Float32 {
        return position.y = value;
    }

    inline static function get_y():Float32 {
        return position.y;
    }

    inline static public function lock() {
        KhaMouse.get().lock();
    }

    inline static public function unlock(){
        KhaMouse.get().unlock();
    }

    inline static private function get_isLocked() : Bool {
        return KhaMouse.get().isLocked();
    }
}