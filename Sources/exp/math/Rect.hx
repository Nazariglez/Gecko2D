package exp.math;

import exp.macros.IAutoPool;
import exp.Float32;

class Rect implements IAutoPool {
	//todo add observer?
	public var x: Float32 = 0;
	public var y: Float32 = 0;
	public var width: Float32 = 0;
	public var height: Float32 = 0;

	public var top(get, null): Float32;
	public var bottom(get, null): Float32;
	public var left(get, null): Float32;
	public var right(get, null): Float32;

	public function new(){}

	public function init(x: Float32 = 0, y: Float32 = 0, width: Float32 = 0, height: Float32 = 0) {
		set(x, y, width, height);
	}

	public function beforeDestroy(){
		clear();
	}
	public function destroy(){}

	// Methods
	public function set(x: Float32, y: Float32, width: Float32, height: Float32) {
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

	inline public function clone(rect: Rect): Rect {
		return Rect.create(x, y, width, height);
	}

	public function contains(x: Float32, y: Float32) : Bool {
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

	// Static Constructors
	inline public static function fromSquare(side): Rect {
		return Rect.fromRectangle(side, side);
	}

	inline public static function fromRectangle(width, height): Rect {
		return Rect.create(0, 0, width, height);
	}

	inline function get_top() : Float32 {
		return y;
	}

	inline function get_bottom() : Float32 {
		return y + height;
	}

	inline function get_left() : Float32 {
		return x;
	}

	inline function get_right() : Float32 {
		return x + width;
	}
}