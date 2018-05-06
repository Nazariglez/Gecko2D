package gecko.input;


import gecko.utils.Event;
import kha.input.Keyboard as KhaKeyboard;

#if !macro @:build(gecko.macros.KeyboardBuilder.build()) #end
class Keyboard {
    static private var _instance:Keyboard = new Keyboard();

    static public var onPressed:Event<KeyCode->Void>;
    static public var onReleased:Event<KeyCode->Void>;
    static public var onDown:Event<KeyCode->Float->Void>;

    private function new(){
        onPressed = Event.create();
        onReleased = Event.create();
        onDown = Event.create();
    }

    static public var isEnabled(default, null):Bool = false;

    static private var _pressedKeys:Map<KeyCode, Bool> = new Map();
    static private var _releasedKeys:Map<KeyCode, Bool> = new Map();
    static private var _downKeys:Map<KeyCode, Float> = new Map();

    static private var _hotKeys:Map<KeyCode, HotKey> = new Map();
    static private var _combos:Map<String, ComboKey> = new Map();
    
    static public function enable() {
        _pressedKeys = new Map();
        _downKeys = new Map();
        _releasedKeys = new Map();

        KhaKeyboard.get().notify(_keyDownHandler, _keyUpHandler, null);
        isEnabled = true;

        Gecko.onUpdate += update;
    }

    static public function disable() {
        Gecko.onUpdate -= update;

        isEnabled = false;
        KhaKeyboard.get().remove(_keyDownHandler, _keyUpHandler, null);
    }

    static public function getHotKey(key:KeyCode) : HotKey {
        if(_hotKeys.exists(key)){
            return _hotKeys[key];
        }

        var k = HotKey.create(key);
        _hotKeys.set(key, k);
        return k;
    }

    static public function bindCombo(combo:String, listener:Void->Void, timeTreshold:Float = 750){
        if(!_combos.exists(combo)){
            _combos[combo] = ComboKey.create(combo, timeTreshold);
        }

        _combos[combo].onTrigger += listener;
    }

    static public function unbindCombo(combo:String, listener:Void->Void) {
        if(_combos.exists(combo)){

            _combos[combo].onTrigger -= listener;

            if(_combos[combo].length == 0){
                _combos.remove(combo);
                _combos[combo].destroy();
            }
        }
    }

    static public function update(delta:Float){ //TODO AVOID USE .keys(), it's better use arrays
        for(key in _pressedKeys.keys()){
            onPressed.emit(key);
            _pressedKeys.remove(key);
        }

        for(key in _downKeys.keys()){
            _downKeys[key] += delta;
            onDown.emit(key, _downKeys[key]);
        }

        for(key in _releasedKeys.keys()){
            onReleased.emit(key);
            _releasedKeys.remove(key);
        }
    }

    static private function _keyDownHandler(key:KeyCode) {
        _pressedKeys.set(key, true);
        _downKeys.set(key, 0);

    }

    static private function _keyUpHandler(key:KeyCode) {
        _pressedKeys.remove(key);
        _downKeys.remove(key);

        _releasedKeys.set(key, true);
    }

    inline static public function wasPressed(key:KeyCode) : Bool {
        return _pressedKeys.exists(key);
    }

    inline static public function wasReleased(key:KeyCode) : Bool {
        return _releasedKeys.exists(key);
    }

    static public function isDown(key:KeyCode, duration:Float = -1) : Bool {
        if(duration != -1){
            return _downKeys.exists(key) && _downKeys[key] <= duration;
        }
        return _downKeys.exists(key);
    }

    inline static public function downDuration(key:KeyCode) : Float {
        return _downKeys.exists(key) ? _downKeys[key] : -1;
    }
}
