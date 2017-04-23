package prime;

import kha.graphics2.Graphics;
import kha.math.FastMatrix3;

class Actor {
	public var position:Point = new Point();
	public var scale:Point = new Point();
	public var rotation:Float = 0;
	public var visible:Bool = true;

	private var _matrix:FastMatrix3 = FastMatrix3.identity();

	public function new(){
		_matrix._00 = 2;
		_matrix._11 = 2;
		_matrix._22 = 1;
	}

	public function update(delta:Float) : Void {}
	public function render(g:Graphics) : Void {
		if(!visible)return;
		g.transformation.setFrom(_matrix);
	}
}