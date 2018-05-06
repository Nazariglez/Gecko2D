package gecko.math;

import kha.math.Vector2;


//@:poolAmount(100)
class Point extends BaseObject {
	private var _vec2:Vector2 = new Vector2(); //used to draw polyigons in the kha api avoiding allocate new vectors each tme
	
	public var x(get, set):Float;
	private var _x:Float = 0;
	public var y(get, set):Float;
	private var _y:Float = 0;

	private var _observer:Point -> Void;
	public var isObserved(default, null):Bool;

	public function init(x:Float = 0, y:Float = 0) {
		set(x,y);
	}

	override public function beforeDestroy(){
		super.beforeDestroy();

		_observer = null;
		isObserved = false;
		_setX(0);
		_setY(0);
	}

	inline private function _setX(value:Float) {
		_vec2.x = _x = value;
	}

	inline private function _setY(value:Float) {
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

	public function set(x:Float, y:Float) {
		if(x != this._x || y != this._y){
			_setX(x);
			_setY(y);
			if(isObserved)_observer(this);
		}
	}

	inline public function setFloor(x:Float, y:Float) {
		set(Math.floor(x), Math.floor(y));
	}

	inline public function setCeil(x:Float, y:Float) {
		set(Math.ceil(x), Math.ceil(y));
	}

	inline public function setRound(x:Float, y:Float) {
		set(Math.round(x), Math.round(y));
	}

	inline public function floor() {
		set(Math.floor(_x), Math.floor(_y));
	}

	inline public function ceil() {
		set(Math.ceil(_x), Math.ceil(_y));
	}

	inline public function round() {
		set(Math.round(_x), Math.round(_y));
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

    public inline function mult(value:Float) : Void {
        set(x * value, y * value);
    }

    public inline function div(value:Float) : Void {
        mult(1 / value);
    }

    public inline function dot(point:Point) : Float {
        return x * point.x + y * point.y;
    }

	inline public function toString() : String {
		return 'Point($_x, $_y)';
	}

	inline function get_x() : Float {
		return _x;
	}

	function set_x(value:Float) : Float {
		if(value == _x)return _x;
		_vec2.x = _x = value;
		if(isObserved)_observer(this);
		return value;
	}

	inline function get_y() : Float {
		return _y;
	}

	function set_y(value:Float) : Float {
		if(value == _y)return _y;
		_vec2.y = _y = value;
		if(isObserved)_observer(this);
		return value;
	}
}