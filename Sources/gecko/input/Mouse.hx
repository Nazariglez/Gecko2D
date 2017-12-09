package gecko.input;

import kha.input.Mouse as KhaMouse;
import gecko.math.Point;
import gecko.math.FastFloat;
import gecko.utils.EventEmitter;

@:enum abstract MouseButton(Int) from Int to Int {
    var LEFT = 0;
    var RIGHT = 1;
    var CENTER = 2;
}

class Mouse {
    static private inline var EVENT_RIGHT_PRESSED = "right_pressed";
    static private inline var EVENT_RIGHT_RELEASED = "right_released";
    static private inline var EVENT_RIGHT_DOWN = "right_down";

    static private inline var EVENT_LEFT_PRESSED = "left_pressed";
    static private inline var EVENT_LEFT_RELEASED = "left_released";
    static private inline var EVENT_LEFT_DOWN = "left_down";

    static private inline var EVENT_CENTER_PRESSED = "center_pressed";
    static private inline var EVENT_CENTER_RELEASED = "center_released";
    static private inline var EVENT_CENTER_DOWN = "center_down";

    static private inline var EVENT_WHEEL_MOVE = "wheel_move";
    static private inline var EVENT_MOVE = "move";

    static public var onRightPressed:Event<Int->Int->Void>;
    static public var onRightPressedOnce:Event<Int->Int->Void>;
    static public var onRightReleased:Event<Int->Int->Void>;
    static public var onRightReleasedOnce:Event<Int->Int->Void>;
    static public var onRightDown:Event<Int->Int->Void>;
    static public var onRightDownOnce:Event<Int->Int->Void>;

    static public var onLeftPressed:Event<Int->Int->Void>;
    static public var onLeftPressedOnce:Event<Int->Int->Void>;
    static public var onLeftReleased:Event<Int->Int->Void>;
    static public var onLeftReleasedOnce:Event<Int->Int->Void>;
    static public var onLeftDown:Event<Int->Int->Void>;
    static public var onLeftDownOnce:Event<Int->Int->Void>;

    static public var onCenterPressed:Event<Int->Int->Void>;
    static public var onCenterPressedOnce:Event<Int->Int->Void>;
    static public var onCenterReleased:Event<Int->Int->Void>;
    static public var onCenterReleasedOnce:Event<Int->Int->Void>;
    static public var onCenterDown:Event<Int->Int->Void>;
    static public var onCenterDownOnce:Event<Int->Int->Void>;

    static public var onWheelMove:Event<Int->Void>;
    static public var onWheelMoveOnce:Event<Int->Void>;
    static public var onMove:Event<Int->Int->Void>;
    static public var onMoveOnce:Event<Int->Int->Void>;

    static private function _bindEvents() {
        if(_eventEmitter == null){
            _eventEmitter = new EventEmitter();
            onRightPressed = _eventEmitter.bind(new Event(EVENT_RIGHT_PRESSED));
            onRightPressedOnce = _eventEmitter.bind(new Event(EVENT_RIGHT_PRESSED, true));
            onRightReleased = _eventEmitter.bind(new Event(EVENT_RIGHT_RELEASED));
            onRightReleasedOnce = _eventEmitter.bind(new Event(EVENT_RIGHT_RELEASED, true));
            onRightDown = _eventEmitter.bind(new Event(EVENT_RIGHT_DOWN));
            onRightDownOnce = _eventEmitter.bind(new Event(EVENT_RIGHT_DOWN, true));

            onLeftPressed = _eventEmitter.bind(new Event(EVENT_LEFT_PRESSED));
            onLeftPressedOnce = _eventEmitter.bind(new Event(EVENT_LEFT_PRESSED, true));
            onLeftReleased = _eventEmitter.bind(new Event(EVENT_LEFT_RELEASED));
            onLeftReleasedOnce = _eventEmitter.bind(new Event(EVENT_LEFT_RELEASED, true));
            onLeftDown = _eventEmitter.bind(new Event(EVENT_LEFT_DOWN));
            onLeftDownOnce = _eventEmitter.bind(new Event(EVENT_LEFT_DOWN, true));

            onCenterPressed = _eventEmitter.bind(new Event(EVENT_CENTER_PRESSED));
            onCenterPressedOnce = _eventEmitter.bind(new Event(EVENT_CENTER_PRESSED, true));
            onCenterReleased = _eventEmitter.bind(new Event(EVENT_CENTER_RELEASED));
            onCenterReleasedOnce = _eventEmitter.bind(new Event(EVENT_CENTER_RELEASED, true));
            onCenterDown = _eventEmitter.bind(new Event(EVENT_CENTER_DOWN));
            onCenterDownOnce = _eventEmitter.bind(new Event(EVENT_CENTER_DOWN, true));

            onWheelMove = _eventEmitter.bind(new Event(EVENT_WHEEL_MOVE));
            onWheelMoveOnce = _eventEmitter.bind(new Event(EVENT_WHEEL_MOVE, true));
            onMove = _eventEmitter.bind(new Event(EVENT_MOVE));
            onMoveOnce = _eventEmitter.bind(new Event(EVENT_MOVE, true));
        }
    }

    static private var _eventEmitter:EventEmitter;

    static public var isEnabled(get, null):Bool;
    static private var _isEnabled:Bool = false;

    static public var isLocked(get, null):Bool;
    
    static public var position:Point = new Point(0, 0);
    static public var x(get, set):FastFloat;
    static public var y(get, set):FastFloat;

    static public var movementX:Int = 0;
    static public var movementY:Int = 0;

    static private var _pressedButtons:Map<MouseButton, Bool>;
    static private var _releasedButtons:Map<MouseButton, Bool>;
    static private var _downButtons:Map<MouseButton, FastFloat>;

    static public function enable() {
        //todo html5 mouseEnter and MouseLeave

        _bindEvents();
        _pressedButtons = [MouseButton.LEFT => false, MouseButton.CENTER => false, MouseButton.RIGHT => false];
        _downButtons = [MouseButton.LEFT => -1, MouseButton.CENTER => -1, MouseButton.RIGHT => -1];
        _releasedButtons = [MouseButton.LEFT => false, MouseButton.CENTER => false, MouseButton.RIGHT => false];
        
        KhaMouse.get().notify(_buttonDownHandler, _buttonUpHandler, _moveHandler, _wheelHandler, _leaveHandler);
        _isEnabled = true;
    }

    static public function disable() {
        KhaMouse.get().remove(_buttonDownHandler, _buttonUpHandler, _moveHandler, _wheelHandler, _leaveHandler);
        _isEnabled = false;
    }

    static public function update(delta:FastFloat) {
        for(btn in _pressedButtons.keys()) {
            if(_pressedButtons[btn]){
                switch(btn){
                    case MouseButton.LEFT: _eventEmitter.emit(EVENT_LEFT_PRESSED, [x, y]);
                    case MouseButton.CENTER: _eventEmitter.emit(EVENT_CENTER_PRESSED, [x, y]);
                    case MouseButton.RIGHT: _eventEmitter.emit(EVENT_RIGHT_PRESSED, [x, y]);
                }
                _pressedButtons[btn] = false;
            }
        }
        
        for(btn in _downButtons.keys()) {
            if(_downButtons[btn] != -1){
                _downButtons[btn] += delta;
                switch(btn){
                    case MouseButton.LEFT: _eventEmitter.emit(EVENT_LEFT_DOWN, [x, y]);
                    case MouseButton.CENTER: _eventEmitter.emit(EVENT_CENTER_DOWN, [x, y]);
                    case MouseButton.RIGHT: _eventEmitter.emit(EVENT_RIGHT_DOWN, [x, y]);
                }
            }
        }

        for(btn in _releasedButtons.keys()) {
            if(_releasedButtons[btn]){
                switch(btn){
                    case MouseButton.LEFT: _eventEmitter.emit(EVENT_LEFT_RELEASED, [x, y]);
                    case MouseButton.CENTER: _eventEmitter.emit(EVENT_CENTER_RELEASED, [x, y]);
                    case MouseButton.RIGHT: _eventEmitter.emit(EVENT_RIGHT_RELEASED, [x, y]);
                }
                _releasedButtons[btn] = false;
            }
        }
    }

    static public function lock() {
        KhaMouse.get().lock();
    }

    static public function unlock(){
        KhaMouse.get().unlock();
    }

    static public function wasPressed(button:MouseButton) : Bool {
        return _pressedButtons[button];
    }

    static public function wasReleased(button:MouseButton) : Bool {
        return _releasedButtons[button];
    }

    static public function isDown(button:MouseButton, duration:FastFloat = -1) : Bool {
        if(duration != -1){
            return _downButtons[button] != -1 && _downButtons[button] <= duration;
        }
        return _downButtons[button] != -1;
    }

    static public function downDuration(button:MouseButton) : FastFloat {
        return _downButtons[button];
    }

    static public function isOverEntity(entity:Entity, pos:Point = null) : Bool {
        if(pos == null){
            pos = Mouse.position;
        }
        var point = entity.matrixTransform.applyInverse(pos); //todo pass a temp point
        if(point.x > 0 && point.x < entity.size.x){
            if(point.y > 0 && point.y < entity.size.y){
                return true;
            }
        }
        return false;
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

    static private function _moveHandler(x:Int, y:Int, movementX:Int, movementY:Int) {
        position.x = x;
        position.y = y;
        Mouse.movementX = movementX;
        Mouse.movementY = movementY;
        _eventEmitter.emit(EVENT_MOVE, [x, y]);
    }

    static private function _wheelHandler(delta:Int) {
        _eventEmitter.emit(EVENT_WHEEL_MOVE, [delta]);
    }

    static private function _leaveHandler() {
        //trace("leave");
        //#if kha_js
        //_eventEmitter.emit(EVENT_CANVAS_LEAVE);
        //#end
    }

    static private function get_isEnabled() : Bool {
        return _isEnabled;
    }

    static private function get_isLocked() : Bool {
        return KhaMouse.get().isLocked();
    }

    static private function get_x() : FastFloat {
        return position.x;
    }

    static private function set_x(value:FastFloat) : FastFloat {
        return position.x = value;
    }

    static private function get_y() : FastFloat {
        return position.y;
    }

    static private function set_y(value:FastFloat) : FastFloat {
        return position.y = value;
    }
}