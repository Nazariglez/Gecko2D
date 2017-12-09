package gecko.input;

import gecko.math.FastFloat;
import gecko.utils.EventEmitter;
import kha.input.Keyboard as KhaKeyboard;

#if !macro @:build(gecko.input.KeyboardBuilder.build()) #end
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

    static private var _hotKeys:Map<KeyCode, HotKey> = new Map<KeyCode, HotKey>();
    static private var _combos:Map<String, ComboKey> = new Map<String, ComboKey>();
    
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

    static public function getHotKey(key:KeyCode) : HotKey {
        if(_hotKeys.exists(key)){
            return _hotKeys[key];
        }

        var k = new HotKey(key);
        _hotKeys.set(key, k);
        return k;
    }

    static public function bindCombo(combo:String, listener:Void->Void, timeTreshold:Float = 750){
        if(!_combos.exists(combo)){
            _combos[combo] = new ComboKey(combo, timeTreshold);
        }
        
        _combos[combo].addListener(listener);
    }

    static public function unbindCombo(combo:String, listener:Void->Void) {
        if(_combos.exists(combo)){
            _combos[combo].removeListener(listener);
            if(_combos[combo].length == 0){
                _combos[combo].destroy();
                _combos.remove(combo);
            }
        }
    }

    static public function update(delta:FastFloat){
        for(key in _pressedKeys.keys()){
            _eventEmitter.emit(EVENT_PRESSED, [key]);
            _pressedKeys.remove(key);
        }

        var dtms = delta*1000;
        for(key in _downKeys.keys()){
            _downKeys[key] += dtms;
            _eventEmitter.emit(EVENT_DOWN, [key, _downKeys[key]]);
        }

        for(key in _releasedKeys.keys()){
            _eventEmitter.emit(EVENT_RELEASED, [key]);
            _releasedKeys.remove(key);
        }
    }

    static private function _keyDownHandler(key:KeyCode) {
        _pressedKeys.set(key, true);
        _downKeys.set(key, 0);

        //_eventEmitter.emit(EVENT_PRESSED, [key]);
    }

    static private function _keyUpHandler(key:KeyCode) {
        _pressedKeys.remove(key);
        _downKeys.remove(key);

        _releasedKeys.set(key, true);

        //_eventEmitter.emit(EVENT_RELEASED, [key]);
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

    static public function downDuration(key:KeyCode) : FastFloat {
        return _downKeys.exists(key) ? _downKeys[key] : -1;
    }

    static private function get_isEnabled() : Bool {
        return _isEnabled;
    }
}
