package gecko.math;

class Vector2g<T> { //todo add observer
    public var x(get, set):T;
    private var _x:T;
    public var y(get, set):T;
    private var _y:T;

    private var _observer:Vector2g<T> -> Void;
    public var isObserved(default, null):Bool;

    inline public function new(x:T, y:T) {
        set(x, y);
    }

    public function setObserver(cb:Vector2g<T> -> Void) : Void {
        isObserved = true;
        _observer = cb;
    }

    public function removeObserver() : Void {
        isObserved = false;
    }

    public inline function set(x:T, ?y:T) {
        this.x = x;
		this.y = (y == null) ? x : y;
    }

    public inline function clone(vec:Vector2g<T>) : Vector2g<T> {
        return new Vector2g<T>(x, y);
    }

    public inline function copy(vec:Vector2g<T>) : Void {
		set(vec.x, vec.y);
	}

    public inline function isEqual(vec:Vector2g<T>) : Bool {
		return (x == vec.x && y == vec.y);
	}

    inline function get_x():T {
        return _x;
    }

    function set_x(value:T):T {
        if(value == _x)return _x;
        _x = value;
        if(isObserved)_observer(this);
        return value;
    }

    inline function set_y(value:T):T {
        if(value == _y)return _y;
        _y = value;
        if(isObserved)_observer(this);
        return value;
    }

    inline function get_y():T {
        return _y;
    }
}