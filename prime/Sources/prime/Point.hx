package prime;

//todo inherits from vector2?
class Point {
	private var _x:Float = 0;
	private var _y:Float = 0;
	
	public var x(get, set):Float;
	public var y(get, set):Float;

	private var _observer:Point -> Void = function(point:Point) : Void {};
	private var _isObserved:Bool = false;
	public var isObserved(get, null):Bool;

	public function new(x:Float = 0, y:Float = 0) {
		set(x,y);
	}

	public function setObserver(cb:Point -> Void) : Void {
		_isObserved = true;
		_observer = cb;
	}

	public function removeObserver() : Void {
		_isObserved = false;
	}

	public function set(x:Float, ?y:Float) {
		this.x = x;
		this.y = (y == null) ? x : y;
	}

	public function clone(point:Point) : Point {
		return new Point(this.x, this.y);
	}

	public function copy(point:Point) : Void {
		this.set(point.x, point.y);
	}

	public function isEqual(point:Point) : Bool {
		return (x == point.x && y == point.y);
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

	function toString() : String {
		return "Point(" + _x + "," + _y + ")";
	}
}