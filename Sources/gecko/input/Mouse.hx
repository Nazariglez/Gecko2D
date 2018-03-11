package gecko.input;

import gecko.components.core.TransformComponent;
import gecko.utils.Event;
import kha.input.Mouse as KhaMouse;
import gecko.math.Point;
import gecko.Float32;

class Mouse {
    static public var isEnabled(default, null):Bool = false;
    static public var isLocked(get, null):Bool;

    static public var position:Point = Point.create(0, 0);
    static public var x(get, set):Float32;
    static public var y(get, set):Float32;

    static public var movementX:Int = 0;
    static public var movementY:Int = 0;

    static public var onRightPressed:Event<Float32->Float32->Void> = Event.create();
    static public var onRightReleased:Event<Float32->Float32->Void> = Event.create();
    static public var onRightDown:Event<Float32->Float32->Void> = Event.create();

    static public var onLeftPressed:Event<Float32->Float32->Void> = Event.create();
    static public var onLeftReleased:Event<Float32->Float32->Void> = Event.create();
    static public var onLeftDown:Event<Float32->Float32->Void> = Event.create();

    static public var onCenterPressed:Event<Float32->Float32->Void> = Event.create();
    static public var onCenterReleased:Event<Float32->Float32->Void> = Event.create();
    static public var onCenterDown:Event<Float32->Float32->Void> = Event.create();

    static public var onWheelMove:Event<Float32->Void> = Event.create();
    static public var onMove:Event<Float32->Float32->Void> = Event.create();

    static private var _pressedButtons:Array<Bool> = [false, false, false];
    static private var _releasedButtons:Array<Bool> = [false, false, false];
    static private var _downButtons:Array<Float32> = [-1, -1, -1];

    //todo limit fps to 30 by default to check buttons state?

    static public function enable() {
        _resetStateButtons();

        KhaMouse.get().notify(_buttonDownHandler, _buttonUpHandler, _moveHandler, _wheelHandler, _leaveHandler);
        isEnabled = true;

        Gecko.onUpdate += _update;
    }

    static public function disable() {
        Gecko.onUpdate -= _update;

        KhaMouse.get().remove(_buttonDownHandler, _buttonUpHandler, _moveHandler, _wheelHandler, _leaveHandler);
        isEnabled = false;
    }

    inline static public function _resetStateButtons() {
        for(i in 0..._pressedButtons.length){
            _pressedButtons[i] = false;
        }

        for(i in 0..._releasedButtons.length){
            _releasedButtons[i] = false;
        }

        for(i in 0..._downButtons.length){
            _downButtons[i] = -1;
        }
    }

    static public function _update(dt:Float32) {
        for(i in 0..._pressedButtons.length){
            if(_pressedButtons[i]){
                switch(i){
                    case MouseButton.LEFT: onLeftPressed.emit(x, y);
                    case MouseButton.RIGHT: onRightPressed.emit(x, y);
                    case MouseButton.CENTER: onCenterPressed.emit(x, y);
                }
                _pressedButtons[i] = false;
            }
        }

        for(i in 0..._downButtons.length){
            if(_downButtons[i] != -1){
                _downButtons[i] += dt;
                switch(i){
                    case MouseButton.LEFT: onLeftDown.emit(x, y);
                    case MouseButton.RIGHT: onRightDown.emit(x, y);
                    case MouseButton.CENTER: onCenterDown.emit(x, y);
                }
            }
        }

        for(i in 0..._releasedButtons.length){
            if(_releasedButtons[i]){
                switch(i){
                    case MouseButton.LEFT: onLeftReleased.emit(x, y);
                    case MouseButton.RIGHT: onRightReleased.emit(x, y);
                    case MouseButton.CENTER: onCenterReleased.emit(x, y);
                }
                _releasedButtons[i] = false;
            }
        }
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
        _pressedButtons[button] = true;
        _downButtons[button] = 0;
    }

    static private function _buttonUpHandler(button:Int, x:Int, y:Int) {
        position.x = x;
        position.y = y;
        _pressedButtons[button] = false;
        _downButtons[button] = -1;
        _releasedButtons[button] =  true;
    }

    static private function _moveHandler(x:Int, y:Int, movementX:Int, movementY:Int) {
        position.x = x;
        position.y = y;
        Mouse.movementX = movementX;
        Mouse.movementY = movementY;
        onMove.emit(x, y);
    }

    static private function _wheelHandler(delta:Int) {
        onWheelMove.emit(delta);
    }

    static private function _leaveHandler(){
        //todo if kha_html5...
    }

    static public function isOverEntity(transform:TransformComponent, cachePoint:Point = null) : Bool {
        if(cachePoint == null)cachePoint = Point.create();

        transform.screenToLocal(Mouse.position, cachePoint);
        if(cachePoint.x > 0 && cachePoint.x < transform.size.x){
            if(cachePoint.y > 0 && cachePoint.y < transform.size.y){
                return true;
            }
        }
        return false;
    }

    static public function isDown(button:MouseButton, duration:Float32 = -1) : Bool {
        if(duration != -1){
            return _downButtons[button] != -1 && _downButtons[button] <= duration;
        }
        return _downButtons[button] != -1;
    }

    inline static public function downDuration(button:MouseButton) : Float32 {
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