package k2d.input;

import k2d.math.FastFloat;
import k2d.utils.EventEmitter;
import kha.input.Keyboard as KhaKeyboard;

class Keyboard {
    static private inline var EVENT_PRESSED = "pressed";
    static private inline var EVENT_RELEASED = "released";
    static private inline var EVENT_DOWN = "down";

    static public var onPressed:Event<KeyCode->Void>;
    static public var onPressedOnce:Event<KeyCode->Void>;
    static public var onReleased:Event<KeyCode->Void>;
    static public var onReleasedOnce:Event<KeyCode->Void>;
    static public var onDown:Event<KeyCode->FastFloat->Void>;
    static public var onDownOnce:Event<KeyCode->FastFloat->Void>;

    static private function _bindEvents() {
        if(_eventEmitter == null){
            _eventEmitter = new EventEmitter();
            onPressed = _eventEmitter.bind(new Event(EVENT_PRESSED));
            onPressedOnce = _eventEmitter.bind(new Event(EVENT_PRESSED, true));
            onReleased = _eventEmitter.bind(new Event(EVENT_RELEASED));
            onReleasedOnce = _eventEmitter.bind(new Event(EVENT_RELEASED, true));
            onDown = _eventEmitter.bind(new Event(EVENT_DOWN));
            onDownOnce = _eventEmitter.bind(new Event(EVENT_DOWN, true));
        }
    }

    static public var isEnabled(get, null):Bool;
    static private var _isEnabled:Bool = false;

    static private var _eventEmitter:EventEmitter;
    static private var _pressedKeys:Map<KeyCode, Bool>;
    static private var _releasedKeys:Map<KeyCode, Bool>;
    static private var _downKeys:Map<KeyCode, FastFloat>;

    //todo allow combos -> https://craig.is/killing/mice
    static public function enable() {
        _bindEvents();
        _pressedKeys = new Map<KeyCode, Bool>();
        _downKeys = new Map<KeyCode, FastFloat>();
        _releasedKeys = new Map<KeyCode, Bool>();

        KhaKeyboard.get().notify(_keyDownHandler, _keyUpHandler, null);
        _isEnabled = true;
    }

    static public function disable() {
        _isEnabled = false;
        KhaKeyboard.get().remove(_keyDownHandler, _keyUpHandler, null);
    }

    static public function update(dt:FastFloat){
        for(key in _downKeys.keys()){
            _downKeys[key] += dt*1000;
            _eventEmitter.emit(EVENT_DOWN, [key, _downKeys[key]]);
        }

        for(key in _pressedKeys.keys()){
            _pressedKeys.remove(key);
        }

        for(key in _releasedKeys.keys()){
            _releasedKeys.remove(key);
        }
    }

    static private function _keyDownHandler(key:KeyCode) {
        _pressedKeys.set(key, true);
        _downKeys.set(key, 0);

        _eventEmitter.emit(EVENT_PRESSED, [key]);
    }

    static private function _keyUpHandler(key:KeyCode) {
        _pressedKeys.remove(key);
        _downKeys.remove(key);

        _releasedKeys.set(key, true);

        _eventEmitter.emit(EVENT_RELEASED, [key]);
    }

    static public function wasPressed(key:KeyCode) : Bool {
        return _pressedKeys.exists(key);
    }

    static public function wasReleased(key:KeyCode) : Bool {
        return _releasedKeys.exists(key);
    }

    static public function isDown(key:KeyCode, duration:FastFloat = -1) : Bool {
        if(duration != -1){
            return _downKeys.exists(key) && _downKeys[key] <= duration;
        }
        return _downKeys.exists(key);
    }

    static private function get_isEnabled() : Bool {
        return _isEnabled;
    }
}