package gecko.input;



class HotKey extends BaseObject {
    public var key:KeyCode = KeyCode.Unknown;

    public var wasPressed(get, null):Bool;
    public var wasReleased(get, null):Bool;
    public var isDown(get, null):Bool;
    public var downDuration(get, null):Float;

    public var isControlDown(get, null):Bool;
    public var isAltDown(get, null):Bool;
    public var isShiftDown(get, null):Bool;

    public function init(key:KeyCode) {
        this.key = key;
    }

    override public function beforeDestroy() {
        super.beforeDestroy();
        key = KeyCode.Unknown;
    }

    inline function get_downDuration() : Float {
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