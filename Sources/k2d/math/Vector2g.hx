package k2d.math;

class Vector2g<T> {
    public var x:T;
    public var y:T;

    public function new(x:T, y:T) {
        set(x, y);
    }

    @:extern public inline function set(x:T, ?y:T) {
        this.x = x;
		this.y = (y == null) ? x : y;
    }

    @:extern public inline function clone(vec:Vector2g<T>) : Vector2g<T> {
        return new Vector2g<T>(x, y);
    }

    @:extern public inline function copy(vec:Vector2g<T>) : Void {
		set(vec.x, vec.y);
	}

    @:extern public inline function isEqual(vec:Vector2g<T>) : Bool {
		return (x == vec.x && y == vec.y);
	}
}