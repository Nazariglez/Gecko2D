package k2d.math;

class Point {
	private var _x:Float = 0;
	private var _y:Float = 0;
	
	public var x(get, set):Float;
	public var y(get, set):Float;

	private var _observer:Point -> Void = function(point:Point) : Void {};
	private var _isObserved:Bool = false;
	public var isObserved(get, null):Bool;

	public inline function new(x:Float = 0, y:Float = 0) {
		set(x,y);
	}

	public function setObserver(cb:Point -> Void) : Void {
		_isObserved = true;
		_observer = cb;
	}

	public function removeObserver() : Void {
		_isObserved = false;
	}

	@:extern public inline function set(x:Float, ?y:Float) {
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

    @:extern public inline function mult(value:Float) : Void {
        set(x * value, y * value);
    }

    @:extern public inline function div(value:Float) : Void {
        mult(1 / value);
    }

    @:extern public inline function dot(point:Point) : Float {
        return x * point.x + y * point.y;
    }

	function get_x() : Float {
		return _x;
	}

	function set_x(value:Float) : Float {
		_x = value;
		if(_isObserved)_observer(this);
		return _x;
	}

	function get_y() : Float {
		return _y;
	}

	function set_y(value:Float) : Float {
		_y = value;
		if(_isObserved)_observer(this);
		return _y;
	}

	function get_isObserved() : Bool {
		return _isObserved;
	}
}