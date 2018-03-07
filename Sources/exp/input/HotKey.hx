package exp.input;

import exp.macros.IAutoPool;
import exp.Float32;

class HotKey implements IAutoPool {
    public var key:KeyCode;

    public var wasPressed(get, null):Bool;
    public var wasReleased(get, null):Bool;
    public var isDown(get, null):Bool;
    public var downDuration(get, null):Float32;

    public var isControlDown(get, null):Bool;
    public var isAltDown(get, null):Bool;
    public var isShiftDown(get, null):Bool;

    public function new(){}

    public function init(key:KeyCode) {
        this.key = key;
    }

    public function beforeDestroy() {
        key = null;
    }

    inline function get_downDuration() : Float32 {
        return Keyboard.downDuration(key);
    }

    inline function get_wasPressed() : Bool {
        return Keyboard.wasPressed(key);
    }

    inline function get_wasReleased() : Bool {
        return Keyboard.wasReleased(key);
    }

    inline function get_isDown() : Bool {
        return Keyboard.isDown(key);
    }

    inline function get_isControlDown() : Bool {
        return Keyboard.isDown(KeyCode.Control);
    }

    inline function get_isShiftDown() : Bool {
        return Keyboard.isDown(KeyCode.Shift);
    }

    inline function get_isAltDown() : Bool {
        return Keyboard.isDown(KeyCode.Alt);
    }
}