package prime;

import kha.Font;

class Text extends Actor {
	public var font:Font;
	public var fontSize:Int = 10;
	public var text:String = "";

	public function new(text:String, font:Font, fontSize:Int = 10) {
		super();

		this.text = text;
		this.font = font;
		this.fontSize = fontSize;
	}

	override function render(r:Renderer) : Void {
		super.render(r);
		r.font = font;
		r.fontSize = fontSize;
		r.drawString(text, 0, 0);
	}

	override function get_width() : Float {
		if(font == null){
			return 0;
		}

		return font.width(fontSize, text);
	}

	override function get_height() : Float {
		if(font == null){
			return 0;
		}

		return font.height(fontSize);
	}
}