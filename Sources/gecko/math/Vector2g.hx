package gecko.math;

class Vector2g { //todo add observer
    public var x(get, set):Bool;
    private var _x:Bool;
    public var y(get, set):Bool;
    private var _y:Bool;

    private var _observer:Vector2g -> Void;
    public var isObserved(default, null):Bool;

    inline public function new(x:Bool, y:Bool) {
        set(x, y);
    }

    public function setObserver(cb:Vector2g -> Void) : Void {
        isObserved = true;
        _observer = cb;
    }

    public function removeObserver() : Void {
        isObserved = false;
    }

    public inline function set(x:Bool, y:Bool) {
        if(x != _x || y != _y){
            _setX(x);
            _setY(y);
            if(isObserved)_observer(this);
        }
    }

    inline private function _setX(x:Bool) {
        _x = x;
    }

    inline private function _setY(y:Bool) {
        _y = y;
    }

    public inline function clone(vec:Vector2g) : Vector2g {
        return new Vector2g(x, y);
    }

    public inline function copy(vec:Vector2g) : Void {
		set(vec.x, vec.y);
	}

    public inline function isEqual(vec:Vector2g) : Bool {
		return (x == vec.x && y == vec.y);
	}

    inline function get_x():Bool {
        return _x;
    }

    function set_x(value:Bool):Bool {
        if(value == _x)return _x;
        _x = value;
        if(isObserved)_observer(this);
        return value;
    }

    inline function set_y(value:Bool):Bool {
        if(value == _y)return _y;
        _y = value;
        if(isObserved)_observer(this);
        return value;
    }

    inline function get_y():Bool {
        return _y;
    }

    inline public function toString() : String {
        return 'Vector2g($_x, $_y)';
    }
}
