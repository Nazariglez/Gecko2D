package gecko.math;

class Point {
	private var _x:FastFloat = 0;
	private var _y:FastFloat = 0;
	
	public var x(get, set):FastFloat;
	public var y(get, set):FastFloat;

	private var _observer:Point -> Void = function(point:Point) : Void {};
	private var _isObserved:Bool = false;
	public var isObserved(get, null):Bool;

	public inline function new(x:FastFloat = 0, y:FastFloat = 0) {
		set(x,y);
	}

	public function setObserver(cb:Point -> Void) : Void {
		_isObserved = true;
		_observer = cb;
	}

	public function removeObserver() : Void {
		_isObserved = false;
	}

	@:extern public inline function set(x:FastFloat, ?y:FastFloat) {
		this.x = x;
		this.y = (y == null) ? x : y;
	}

	@:extern public inline function clone(point:Point) : Point {
		return new Point(x, y);
	}

	@:extern public inline function copy(point:Point) : Void {
		set(point.x, point.y);
	}

	@:extern public inline function isEqual(point:Point) : Bool {
		return (x == point.x && y == point.y);
	}

    @:extern public inline function add(point:Point) : Void {
        set(x + point.x, y + point.y);
    }

    @:extern public inline function sub(point:Point) : Void {
        set(x - point.x, y - point.y);
    }

    @:extern public inline function mult(value:FastFloat) : Void {
        set(x * value, y * value);
    }

    @:extern public inline function div(value:FastFloat) : Void {
        mult(1 / value);
    }

    @:extern public inline function dot(point:Point) : FastFloat {
        return x * point.x + y * point.y;
    }

	function get_x() : FastFloat {
		return _x;
	}

	function set_x(value:FastFloat) : FastFloat {
		_x = value;
		if(_isObserved)_observer(this);
		return _x;
	}

	function get_y() : FastFloat {
		return _y;
	}

	function set_y(value:FastFloat) : FastFloat {
		_y = value;
		if(_isObserved)_observer(this);
		return _y;
	}

	function get_isObserved() : Bool {
		return _isObserved;
	}
}