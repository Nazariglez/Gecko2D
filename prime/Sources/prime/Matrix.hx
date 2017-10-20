package prime;

import kha.math.FastMatrix3;

class Matrix {
	public var local:FastMatrix3 = FastMatrix3.identity();
	public var world:FastMatrix3 = FastMatrix3.identity();

	private var _cx:Float = 1;
	private var _sx:Float = 0;
	private var _cy:Float = 0;
	private var _sy:Float = 1;

	private var _aW:Float = 0;
	private var _aH:Float = 0;
	private var _pW:Float = 0;
	private var _pH:Float = 0;

	private var _scX:Float = 0;
	private var _scY:Float = 0;
	private var _anX:Float = 0;
	private var _anY:Float = 0;
	private var _piX:Float = 0;
	private var _piY:Float = 0;

	public function new(){}

	public function updateSkew(actor:Actor) : Void {
		_cx = Math.cos(actor.rotation + actor.skew.y);
		_sx = Math.sin(actor.rotation + actor.skew.y);
		_cy = -Math.sin(actor.rotation - actor.skew.x);
		_sy = Math.cos(actor.rotation - actor.skew.x);
	}

	public function updateLocal(actor:Actor) : Void {
		_scX = actor.scale.x * (actor.flipX ? -1 : 1);
		_scY = actor.scale.y * (actor.flipY ? -1 : 1);
		_anX = actor.flipX ? 1-actor.anchor.x : actor.anchor.x;
		_anY = actor.flipY ? 1-actor.anchor.y : actor.anchor.y;
		_piX = actor.flipX ? 1-actor.pivot.x : actor.pivot.x;
		_piY = actor.flipY ? 1-actor.pivot.y : actor.pivot.y;

		local._00 = _cx * _scX;
		local._01 = _sx * _scX;
		local._10 = _cy * _scY;
		local._11 = _sy * _scY;

		_aW = _anX * actor.size.x;
		_aH = _anY * actor.size.y;
		_pW = _piX * actor.size.x;
		_pH = _piY * actor.size.y;

		local._20 = actor.position.x - _aW * _scX + _pW * _scX;
		local._21 = actor.position.y - _aH * _scY + _pH * _scY;
		
		if(_pW != 0 || _pH != 0){
			local._20 -= _pW * local._00 + _pH * local._10;
			local._21 -= _pW * local._01 + _pH * local._11;
		}
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

	public function update(actor:Actor, parentMatrix:FastMatrix3) : Void {
		updateLocal(actor);
		updateWorld(parentMatrix);
	}

}