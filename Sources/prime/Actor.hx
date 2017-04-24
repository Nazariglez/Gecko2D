package prime;

import kha.graphics2.Graphics;

class Actor {
	public var position:Point = new Point();
	public var scale:Point = new Point(1,1);
	public var skew:Point = new Point();
	public var pivot:Point = new Point();
	public var anchor:Point = new Point(0.5);
	public var visible:Bool = true;
	public var alpha:Float = 1;
	public var worldAlpha:Float = 1;
	public var zIndex:Int = 0;
	public var parent:Actor;
	public var matrix:Matrix = new Matrix();

	public var rotation(get, set):Float;

	private var _rotation:Float = 0;

	public function new(){
		skew.setObserver(_skewObserver);
	}

	private function _skewObserver(point:Point) : Void {
		matrix.updateSkew(point, _rotation);
	}

	private function _updateMatrix() : Void {
		if(parent == null){
			matrix.updateLocal(position, scale, pivot);
			matrix.world.setFrom(matrix.local);
			worldAlpha = alpha;
		}else{
			matrix.update(position, scale, pivot, parent.matrix.world);
			worldAlpha = parent.worldAlpha * alpha;
		}
	}

	public function update(delta:Float) : Void {}
	public function render(g:Graphics) : Void {
		if(!visible)return;
		_updateMatrix();
		g.opacity = worldAlpha;
		g.transformation.setFrom(matrix.world);
	}

	function get_rotation() : Float {
		return _rotation;
	}

	function set_rotation(value:Float) : Float {
		matrix.updateSkew(skew, value);
		return _rotation = value;
	}
}