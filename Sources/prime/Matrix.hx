package prime;

import kha.math.FastMatrix3;

class Matrix {
	public var local:FastMatrix3 = FastMatrix3.identity();
	public var world:FastMatrix3 = FastMatrix3.identity();

	private var _cx:Float = 1;
	private var _sx:Float = 0;
	private var _cy:Float = 0;
	private var _sy:Float = 1;

	public function new(){}

	public function updateSkew(skew:Point, rotation:Float) : Void {
		_cx = Math.cos(rotation + skew.y);
		_sx = Math.sin(rotation + skew.y);
		_cy = -Math.sin(rotation - skew.x);
		_sy = Math.cos(rotation - skew.x);
	}

	public function updateLocal(position:Point, scale:Point, pivot:Point) : Void {
		local._00 = _cx * scale.x;
		local._01 = _sx * scale.x;
		local._10 = _cy * scale.y;
		local._11 = _sy * scale.y;

		local._20 = position.x - ((pivot.x * local._00) + (pivot.y * local._10));
		local._21 = position.y - ((pivot.x * local._01) + (pivot.y * local._11));
	}

	public function updateWorld(parentMatrix:FastMatrix3) : Void {
		var pm = parentMatrix;
		world._00 = (local._00 * pm._00) + (local._01 * pm._10);
		world._01 = (local._00 * pm._01) + (local._01 * pm._11);
		world._10 = (local._10 * pm._00) + (local._11 * pm._10);
		world._11 = (local._10 * pm._01) + (local._11 * pm._11);

		world._20 = (local._20 * pm._00) + (local._21 * pm._10) + pm._20;
		world._21 = (local._20 * pm._01) + (local._21 * pm._11) + pm._21;
	}

	public function update(position:Point, scale:Point, pivot:Point, parentMatrix:FastMatrix3) : Void {
		updateLocal(position, scale, pivot);
		updateWorld(parentMatrix);
	}

}