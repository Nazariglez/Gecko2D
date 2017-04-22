package prime;

import kha.graphics2.Graphics;

class Actor {
	public var position:Point = new Point();
	public var scale:Point = new Point();
	public var rotation:Float = 0;

	public function new(){}

	public function update(delta:Float) : Void {}
	public function render(g:Graphics) : Void {}
}