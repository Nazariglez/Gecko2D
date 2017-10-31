package k2d.math;

class VectorG<T> {
    public var x:T;
    public var y:T;

    public function new(x:T, y:T) {
        this.x = x;
        this.y = y;
    }

    @:extern public inline function set(x:T, y:T) {
        this.x = x;
		this.y = (y == null) ? x : y;
    }

    @:extern public inline function clone(vec:VectorG<T>) : VectorG<T> {
        return new VectorG<T>(x, y);
    }

    @:extern public inline function copy(vec:VectorG<T>) : Void {
		set(vec.x, vec.y);
	}

    @:extern public inline function isEqual(vec:VectorG<T>) : Bool {
		return (x == vec.x && y == vec.y);
	}
}