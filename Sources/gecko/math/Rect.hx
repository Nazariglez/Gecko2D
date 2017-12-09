package gecko.math;

import kha.math.Vector2;

class Rect {
	//todo add observer
	public var x: FastFloat;
	public var y: FastFloat;
	public var width: FastFloat;
	public var height: FastFloat;

	public var top(get, null): FastFloat;
	public var bottom(get, null): FastFloat;
	public var left(get, null): FastFloat;
	public var right(get, null): FastFloat;

	public function new(x: FastFloat = 0, y: FastFloat = 0, width: FastFloat = 0, height: FastFloat = 0) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	// Methods
	public function set(x: FastFloat, y: FastFloat, width: FastFloat, height: FastFloat): Rect {
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

	public function contains(x: FastFloat, y: FastFloat) : Bool {
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

	// Static Constructors
	public static function fromSquare(side): Rect {
		return Rect.fromRectangle(side, side);
	}

	public static function fromRectangle(width, height): Rect {
		return new Rect(0, 0, width, height);
	}

	function get_top() : FastFloat {
		return y;
	}

	function get_bottom() : FastFloat {
		return y + height;
	}

	function get_left() : FastFloat {
		return x;
	}

	function get_right() : FastFloat {
		return x + width;
	}
}