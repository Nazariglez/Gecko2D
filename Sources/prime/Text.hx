package prime;

import kha.Font;

class Text extends Actor {
	public var font:Font;
	public var size:Int = 10;
	public var text:String = "";

	public function new(text:String, font:Font, size:Int = 10) {
		super();

		this.font = font;
		this.size = size;
	}

	override function render(r:Renderer) : Void {
		super.render(r);
		r.font = font;
		r.fontSize = size;
		r.drawString(text, 0, 0);
	}
}