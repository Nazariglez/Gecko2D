package k2d;

import k2d.resources.Font;
import k2d.render.Renderer2D;

class Text extends Entity {
    public var font(get, set):Font;
    private var _font:Font;

    public var fontName(get, set):String;
    private var _fontName:String = "";

    public var fontSize:Int = 1;
    public var text:String = "";

    static public function fromFont(text:String, fnt:Font) : Text {
        var t = new Text(text);
        t.font = fnt;
        return t;
    }

    public override function new(text:String, ?fntName:String) {
        super();
        this.text = text;
        if(fntName != null) {
            this.fontName = fntName;
        }
    }

    public override function render(r:Renderer2D) {
        super.render(r);
        if(font != null){
            r.font = _font;
            r.fontSize = fontSize;
            r.drawString(text, 0, 0);
        }
    }

    function get_fontName() : String {
        return _fontName;
    }

    function set_fontName(name:String) : String {
        if(!Assets.fonts.exists(name)){
            throw new k2d.Error('Font $name not loaded...'); //todo better use log than error?
            return "";
        }

        this.font = Assets.fonts[name];
        return this._fontName = name;
    }

    function get_font() : Font {
        return _font;
    }

    function set_font(fnt:Font) : Font {
        //todo check size here
        return _font = fnt;
    }
}