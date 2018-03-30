package gecko.math;

import gecko.macros.IAutoPool;
import kha.math.Vector2;
import gecko.Float32;

//@:poolAmount(100)
class Point implements IAutoPool {
	private var _vec2:Vector2 = new Vector2(); //used to draw polyigons in the kha api avoiding allocate new vectors each tme
	
	public var x(get, set):Float32;
	private var _x:Float32 = 0;
	public var y(get, set):Float32;
	private var _y:Float32 = 0;

	private var _observer:Point -> Void;
	public var isObserved(default, null):Bool;

	public function new(){}

	public function init(x:Float32 = 0, y:Float32 = 0) {
		set(x,y);
	}

	public function beforeDestroy(){
		_observer = null;
		isObserved = false;
		_setX(0);
		_setY(0);
	}

	inline private function _setX(value:Float32) {
		_vec2.x = _x = value;
	}

	inline private function _setY(value:Float32) {
		_vec2.y = _y = value;
	}

	public inline function getVec2() : Vector2 {
		return _vec2;
	}

	public function setObserver(cb:Point -> Void) : Void {
		isObserved = true;
		_observer = cb;
	}

	public function removeObserver() : Void {
		isObserved = false;
	}

	public function set(x:Float32, y:Float32) {
		if(x != this._x || y != this._y){
			_setX(x);
			_setY(y);
			if(isObserved)_observer(this);
		}
	}

	public inline function clone() : Point {
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

	inline public function toString() : String {
		return 'Point($_x, $_y)';
	}

	inline function get_x() : Float32 {
		return _x;
	}

	function set_x(value:Float32) : Float32 {
		if(value == _x)return _x;
		_vec2.x = _x = value;
		if(isObserved)_observer(this);
		return value;
	}

	inline function get_y() : Float32 {
		return _y;
	}

	function set_y(value:Float32) : Float32 {
		if(value == _y)return _y;
		_vec2.y = _y = value;
		if(isObserved)_observer(this);
		return value;
	}
}