package gecko;

import gecko.resources.Font;
import gecko.render.Renderer;
import gecko.render.HorizontalTextAlign;
import gecko.render.VerticalTextAlign;

typedef TextOptions = {
    //todo wrap text lines, align, text, font, size, etc...
};

class Text extends Entity {
    public var font(get, set):Font;
    private var _font:Font;

    public var fontName(get, set):String;
    private var _fontName:String = "";

    public var text(get, set):String;
    private var _text:String = "";

    public var fontSize(get, set):Int;
    private var _fontSize:Int = 10;


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

    public override function render(r:Renderer) {
        r.applyTransform(matrixTransform);

        if(font != null){
            r.font = _font;
            r.fontSize = fontSize;
            r.drawAlignedString(text, 0, 0, HorizontalTextAlign.TextLeft, VerticalTextAlign.TextTop);
        }

        super.render(r);
    }

    function get_fontName() : String {
        return _fontName;
    }

    function set_fontName(name:String) : String {
        if(!Assets.fonts.exists(name)){
            throw new Error('Font $name not loaded...'); //todo better use log than error?
            return "";
        }

        this.font = Assets.fonts[name];
        return this._fontName = name;
    }

    function get_font() : Font {
        return _font;
    }

    function set_font(fnt:Font) : Font {
        _font = fnt;
        _setSize();
        return _font;
    }

    function get_text() : String {
        return _text;
    }

    function set_text(text:String) : String {
        _text = text;
        _setSize();
        return _text;
    }

    function get_fontSize() : Int {
        return _fontSize;
    }

    function set_fontSize(v:Int) : Int {
        _fontSize = v;
        _setSize();
        return _fontSize;
    }

    private inline function _setSize() {
        if(_font != null){
            size.set(
                _font.width(_fontSize, _text), 
                _font.height(_fontSize)
            );
        }
    }
}