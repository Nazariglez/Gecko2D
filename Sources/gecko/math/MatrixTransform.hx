package gecko.math;

import gecko.Entity;
import gecko.Color;

class MatrixTransform {
    public var local:Matrix = Matrix.identity();
    public var world:Matrix = Matrix.identity();
	public var tint:Int = Color.WHITE;
	public var alpha:FastFloat = 1;

    private var _cx:FastFloat = 1;
	private var _sx:FastFloat = 0;
	private var _cy:FastFloat = 0;
	private var _sy:FastFloat = 1;

	private var _aW:FastFloat = 0;
	private var _aH:FastFloat = 0;
	private var _pW:FastFloat = 0;
	private var _pH:FastFloat = 0;

	private var _scX:FastFloat = 0;
	private var _scY:FastFloat = 0;
	private var _anX:FastFloat = 0;
	private var _anY:FastFloat = 0;
	private var _piX:FastFloat = 0;
	private var _piY:FastFloat = 0;

	private var _midSizeX:FastFloat = 0;
	private var _midSizeY:FastFloat = 0;
    
    public function new(){}

    public inline function updateSkew(entity:Entity) : Void {
		_cx = Math.cos(entity.rotation + entity.skew.y);
		_sx = Math.sin(entity.rotation + entity.skew.y);
		_cy = -Math.sin(entity.rotation - entity.skew.x);
		_sy = Math.cos(entity.rotation - entity.skew.x);
	}

    public inline function updateLocal(entity:Entity) : Void {
		//TODO check the methods in kha graphics to rotate, opacity and push transform, maybe will be faster?
		_scX = entity.scale.x * (entity.flip.x ? -1 : 1);
		_scY = entity.scale.y * (entity.flip.y ? -1 : 1);
		_anX = entity.flip.x ? 1-entity.anchor.x : entity.anchor.x;
		_anY = entity.flip.y ? 1-entity.anchor.y : entity.anchor.y;
		_piX = entity.flip.x ? 1-entity.pivot.x : entity.pivot.x;
		_piY = entity.flip.y ? 1-entity.pivot.y : entity.pivot.y;

		local._00 = _cx * _scX;
		local._01 = _sx * _scX;
		local._10 = _cy * _scY;
		local._11 = _sy * _scY;

		_aW = _anX * entity.size.x;
		_aH = _anY * entity.size.y;
		_pW = _piX * entity.size.x;
		_pH = _piY * entity.size.y;

		local._20 = entity.position.x - _aW * _scX + _pW * _scX;
		local._21 = entity.position.y - _aH * _scY + _pH * _scY;
		
		if(_pW != 0 || _pH != 0){
			local._20 -= _pW * local._00 + _pH * local._10;
			local._21 -= _pW * local._01 + _pH * local._11;
		}
	}

	public inline function updateWorld(pm:Matrix) : Void {
		world._00 = (local._00 * pm._00) + (local._01 * pm._10);
		world._01 = (local._00 * pm._01) + (local._01 * pm._11);
		world._10 = (local._10 * pm._00) + (local._11 * pm._10);
		world._11 = (local._10 * pm._01) + (local._11 * pm._11);

		world._20 = (local._20 * pm._00) + (local._21 * pm._10) + pm._20;
		world._21 = (local._20 * pm._01) + (local._21 * pm._11) + pm._21;
	}

	public function applyInverse(point:Point, newPoint:Point = null) : Point {
		if(newPoint == null){
			newPoint = new Point(0,0);
		}

		var id = 1 / ((world._00 * world._11) + (world._10 * -world._01));
		newPoint.x = (world._11 * id * point.x) + (-world._10 * id * point.y) + (((world._21 * world._10) - (world._20 * world._11)) * id);
		newPoint.y = (world._00 * id * point.y) + (-world._01 * id * point.x) + (((-world._21 * world._00) + (world._20 * world._01)) * id);

		return newPoint;
	}
}