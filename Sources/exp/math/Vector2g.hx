package exp.math;

class Vector2g<T> { //todo add observer
    public var x:T;
    public var y:T;

    inline public function new(x:T, y:T) {
        set(x, y);
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
}