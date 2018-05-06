package gecko.math;



class Rect extends BaseObject {
	inline public static function fromSquare(side): Rect {
		return Rect.fromRectangle(side, side);
	}

	inline public static function fromRectangle(width, height): Rect {
		return Rect.create(0, 0, width, height);
	}

	//todo add observer?
	public var x: Float = 0;
	public var y: Float = 0;
	public var width: Float = 0;
	public var height: Float = 0;

	public var top(get, null): Float;
	public var bottom(get, null): Float;
	public var left(get, null): Float;
	public var right(get, null): Float;
	public var centerX(get, null): Float;
	public var centerY(get, null): Float;

	public function init(x: Float = 0, y: Float = 0, width: Float = 0, height: Float = 0) {
		set(x, y, width, height);
	}

	override public function beforeDestroy(){
		super.beforeDestroy();

		clear();
	}

	// Methods
	public function set(x: Float, y: Float, width: Float, height: Float) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	public function clear() {
		x = 0;
		y = 0;
		width = 0;
		height = 0;
	}

	public function copy(rect: Rect) {
		x = rect.x;
		y = rect.y;
		width = rect.width;
		height = rect.height;
	}

	inline public function clone(): Rect {
		return Rect.create(x, y, width, height);
	}

	public function contains(x: Float, y: Float) : Bool {
		if(this.width <= 0 || this.height <= 0){
			return false;
		}

		if(x >= this.x && x < this.x+this.width) {
			if(y >= this.y && y < this.y+this.height){
				return true;
			}
		}

		return false;
	}

	inline public function containsPoint(point: Point) : Bool {
		return contains(point.x, point.y);
	}

	public function containsRect(rect: Rect) : Bool {
		return contains(rect.x, rect.y)
			&& contains(rect.x, rect.y + rect.height)
			&& contains(rect.x + rect.width, rect.y)
			&& contains(rect.x + rect.width, rect.y + rect.height);
	}

	public function intersect(rect: Rect) : Bool {
		return contains(rect.x, rect.y)
			|| contains(rect.x, rect.y + rect.height)
			|| contains(rect.x + rect.width, rect.y)
			|| contains(rect.x + rect.width, rect.y + rect.height);
	}

	inline function get_top() : Float {
		return y;
	}

	inline function get_bottom() : Float {
		return y + height;
	}

	inline function get_left() : Float {
		return x;
	}

	inline function get_right() : Float {
		return x + width;
	}

	inline function get_centerX():Float {
		return x + width/2;
	}

	inline function get_centerY():Float {
		return y + height/2;
	}
}