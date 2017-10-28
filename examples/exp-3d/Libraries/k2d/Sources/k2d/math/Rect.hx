package k2d.math;

import kha.math.Vector2;

class Rect {
	public var x: Float;
	public var y: Float;
	public var width: Float;
	public var height: Float;

	public var top(get, null): Float;
	public var bottom(get, null): Float;
	public var left(get, null): Float;
	public var right(get, null): Float;

	public function new(x: Float = 0, y: Float = 0, width: Float = 0, height: Float = 0) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	// Getters
	public function get_top() : Float {
		return y;
	}

	public function get_bottom() : Float {
		return y + height;
	}

	public function get_left() : Float {
		return x;
	}

	public function get_right() : Float {
		return x + width;
	}

	// Methods
	public function set(x: Float, y: Float, width: Float, height: Float): Rect {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;

		return this;
	}

	public function clear(): Rect {
		this.x = this.y = this.width = this.height = 0;
		return this;
	}

	public function copy(rect: Rect): Rect {
		this.x = rect.x;
		this.y = rect.y;
		this.width = rect.width;
		this.height = rect.height;

		return this;
	}

	public function clone(rect: Rect): Rect {
		return new Rect(this.x, this.y, this.width, this.height);
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

	public function containsVector2(point: Vector2) : Bool {
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

	function toString() : String {
		return "Rectangle(${x}, ${y}, ${width}, ${height})";
	}

	// Static Constructors
	public static function fromSquare(side): Rect {
		return Rect.fromRectangle(side, side);
	}

	public static function fromRectangle(width, height): Rect {
		return new Rect(0, 0, width, height);
	}
}