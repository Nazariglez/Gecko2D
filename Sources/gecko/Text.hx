package gecko;

import gecko.math.FastFloat;
import gecko.resources.Font;
import gecko.render.Renderer;
import gecko.render.HorizontalTextAlign;
import gecko.render.VerticalTextAlign;

class Text extends Entity {
    public var font(get, set):Font;
    private var _font:Font;

    public var fontName(get, set):String;
    private var _fontName:String = "";

    public var text(get, set):String;
    private var _text:String = "";

    public var fontSize(get, set):Int;
    private var _fontSize:Int = 10;

    public var lineSpacing(get, set):Int;
    private var _lineSpacing:Int = 0;

    public var lineWidth(get, set):Int;
    private var _lineWidth:Int = 0;

    public var align(get, set):String;
    private var _align:String = "left";

    private var _splitRegex = ~/(?:\r\n|\r|\n)/g;
    private var _dirty:Bool = false;
    private var _parsedText:Array<String> = [];
    private var _parsedLineHeight:Float = 0;
    private var _parsedAlign:HorizontalTextAlign;
    private var _parsedOriginX:FastFloat = 0;

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

    private function _updateText() {
        _dirty = false;

        _parsedText = _splitInLines(_text);
        _parsedLineHeight = _font.height(_fontSize) + _lineSpacing;

        _setSize();

        switch(_align){
            case "center":
                _parsedAlign = HorizontalTextAlign.TextCenter;
                _parsedOriginX = size.x/2;
            case "right":
                _parsedAlign = HorizontalTextAlign.TextRight;
                _parsedOriginX = size.x;
            default:
                _parsedAlign = HorizontalTextAlign.TextLeft;
                _parsedOriginX = 0;
        }

        updateTransform();
    }

    private function _splitInLines(txt:String) : Array<String> {
        var lines = _splitRegex.split(txt);
        if(lineWidth <= 0){
            return lines;
        }

        var spaceWidth = _font.width(_fontSize, " ");
        var parsedLines:Array<String> = [];

        for(ln in lines){
            var words = ln.split(" ");
            var lnWidth:Float = 0;

            var result = "";
            var i = 0;
            for(word in words){
                var ww = _font.width(_fontSize, word);

                if(i < words.length-1){
                    ww += spaceWidth;
                }

                lnWidth += ww;

                if(lnWidth <= _lineWidth){
                    if(i == 0){
                        result += word;
                    }else{
                        result += " " + word;
                    }
                }else{
                    result += "\n" + word;
                    lnWidth = 0;
                }

                i++;
            }

            parsedLines.push(result);
        }

        return parsedLines.join("\n").split("\n");
    }

    public override function render(r:Renderer) {
        if(_dirty){
            _updateText();
        }

        r.applyTransform(matrixTransform);

        if(font != null){
            r.font = _font;
            r.fontSize = _fontSize;
            for(i in 0..._parsedText.length){
                r.drawAlignedString(_parsedText[i], _parsedOriginX, _parsedLineHeight*i, _parsedAlign, VerticalTextAlign.TextTop);
            }
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
        _dirty = true;
        return _font;
    }

    function get_text() : String {
        return _text;
    }

    function set_text(text:String) : String {
        _text = text;
        _dirty = true;
        return _text;
    }

    function get_fontSize() : Int {
        return _fontSize;
    }

    function set_fontSize(v:Int) : Int {
        _fontSize = v;
        _dirty = true;
        return _fontSize;
    }

    private inline function _setSize() {
        if(_font != null){

            var max:Float = -1;
            for(line in _parsedText){
                var ww = _font.width(_fontSize, line);
                if(ww > max){
                    max = ww;
                }
            }

            size.set(
                max,
                (_font.height(_fontSize)+_lineSpacing)*_parsedText.length-_lineSpacing
            );

        }
    }

    function get_lineSpacing():Int {
        return _lineSpacing;
    }

    function set_lineSpacing(value:Int):Int {
        _dirty = true;
        return _lineSpacing = value;
    }

    function get_lineWidth():Int {
        return _lineWidth;
    }

    function set_lineWidth(value:Int):Int {
        _dirty = true;
        return _lineWidth = value;
    }

    function get_align():String {
        return _align;
    }

    function set_align(value:String):String {
        _dirty = true;
        return _align = value;
    }
}