package exp.math;

import exp.macros.IAutoPool;
import kha.math.Vector2;
import exp.Float32;

@:poolAmount(100)
class Point implements IAutoPool {
	private var _vec2:Vector2 = new Vector2(); //used to draw polyigons in the kha api avoiding allocate new vectors each tme
	
	public var x(get, set):Float32;
	private var _x:Float32 = 0;
	public var y(get, set):Float32;
	private var _y:Float32 = 0;

	private var _observer:Point -> Void;
	private var _isObserved:Bool = false;
	public var isObserved(get, null):Bool;

	public function new(){}

	public function init(x:Float32 = 0, y:Float32 = 0) {
		set(x,y);
	}

	public function destroy(avoidPool:Bool = false) {
		_observer = null;
		_isObserved = false;
		_vec2.x = 0;
		_vec2.y = 0;
		if(!avoidPool)__toPool__();
	}

	private function __toPool__(){}

	public inline function getVec2() : Vector2 {
		return _vec2;
	}

	public function setObserver(cb:Point -> Void) : Void {
		_isObserved = true;
		_observer = cb;
	}

	public function removeObserver() : Void {
		_isObserved = false;
	}

	public inline function set(x:Float32, ?y:Float32) {
		this.x = x;
		this.y = (y == null) ? x : y;
	}

	public inline function clone(point:Point) : Point {
		return Point.create(x, y);
	}

	public inline function copy(point:Point) : Void {
		set(point.x, point.y);
	}

	public inline function isEqual(point:Point) : Bool {
		return (x == point.x && y == point.y);
	}

    public inline function add(point:Point) : Void {
        set(x + point.x, y + point.y);
    }

    public inline function sub(point:Point) : Void {
        set(x - point.x, y - point.y);
    }

    public inline function mult(value:Float32) : Void {
        set(x * value, y * value);
    }

    public inline function div(value:Float32) : Void {
        mult(1 / value);
    }

    public inline function dot(point:Point) : Float32 {
        return x * point.x + y * point.y;
    }

	inline function get_x() : Float32 {
		return _x;
	}

	function set_x(value:Float32) : Float32 {
		_vec2.x = _x = value;
		if(_isObserved)_observer(this);
		return value;
	}

	inline function get_y() : Float32 {
		return _y;
	}

	function set_y(value:Float32) : Float32 {
		_vec2.y = _y = value;
		if(_isObserved)_observer(this);
		return value;
	}

	inline function get_isObserved() : Bool {
		return _isObserved;
	}
}