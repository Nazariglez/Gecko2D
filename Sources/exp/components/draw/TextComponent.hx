package exp.components.draw;

import exp.render.VerticalTextAlign;
import exp.render.Graphics;
import exp.render.HorizontalTextAlign;
import exp.resources.Font;
import exp.Float32;

class TextComponent extends DrawComponent {
    public var font(default, null):Font;

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
    private var _parsedText:Array<String> = [];
    private var _parsedLineHeight:Float32 = 0;
    private var _parsedAlign:HorizontalTextAlign;
    private var _parsedOriginX:Float32 = 0;

    public var width(default, null):Float32 = 0;
    public var height(default, null):Float32 = 0;

    public function init(text:String, fontName:String, fontSize:Int, align:String = "left") {
        this.fontName = fontName;
        this.text = text;
        this.fontSize = fontSize;
        this.align = align;

        onAddedToEntity += _setTransformSize;
    }

    private function _setTransformSize(e:Entity) {
        _updateText();
    }

    override public function reset() {
        text = "";
        fontSize = 10;
        font = null;
        onAddedToEntity -= _setTransformSize;
    }

    public override function draw(g:Graphics) {
        if(font == null)return;

        g.font = font;
        g.fontSize = _fontSize;
        for(i in 0..._parsedText.length){
            g.drawAlignedText(_parsedText[i], _parsedOriginX, _parsedLineHeight*i, _parsedAlign, VerticalTextAlign.TextTop);
        }
    }

    private function _updateText() {
        if(font == null)return;

        _parsedText = _splitInLines(_text);
        _parsedLineHeight = font.height(_fontSize) + _lineSpacing;

        _setSize();

        switch(_align){
            case "center":
                _parsedAlign = HorizontalTextAlign.TextCenter;
                _parsedOriginX = width/2;
            case "right":
                _parsedAlign = HorizontalTextAlign.TextRight;
                _parsedOriginX = width;
            default:
                _parsedAlign = HorizontalTextAlign.TextLeft;
                _parsedOriginX = 0;
        }

    }

    private function _splitInLines(txt:String) : Array<String> {
        var lines = _splitRegex.split(txt);
        if(lineWidth <= 0){
            return lines;
        }

        var spaceWidth = font.width(_fontSize, " ");
        var parsedLines:Array<String> = [];

        for(ln in lines){
            var words = ln.split(" ");
            var lnWidth:Float = 0;

            var result = "";
            var i = 0;
            for(word in words){
                var ww = font.width(_fontSize, word);

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

    private function _setSize() {
        var max:Float32 = -1;
        for(line in _parsedText){
            var ww = font.width(_fontSize, line);
            if(ww > max){
                max = ww;
            }
        }

        width = max;
        height = (font.height(_fontSize)+_lineSpacing)*_parsedText.length-_lineSpacing;

        if(entity != null && entity.transform != null){
            entity.transform.size.set(width, height);
        }
    }

    inline function get_fontName():String {
        return _fontName;
    }

    function set_fontName(value:String):String {
        if(_fontName == value)return _fontName;
        _fontName = value;
        font = Assets.fonts.get(value);
        _updateText();
        return _fontName;
    }

    inline function get_text():String {
        return _text;
    }

    function set_text(value:String):String {
        if(_text == value)return _text;
        _text = value;
        _updateText();
        return _text;
    }

    inline function get_fontSize():Int {
        return _fontSize;
    }

    function set_fontSize(value:Int):Int {
        if(_fontSize == value)return _fontSize;
        _fontSize = value;
        _updateText();
        return _fontSize;
    }

    inline function get_lineSpacing():Int {
        return _lineSpacing;
    }

    function set_lineSpacing(value:Int):Int {
        if(_lineSpacing == value)return _lineSpacing;
        _lineSpacing = value;
        _updateText();
        return _lineSpacing;
    }

    function set_lineWidth(value:Int):Int {
        if(_lineWidth == value)return _lineWidth;
        _lineWidth = value;
        _updateText();
        return _lineWidth;
    }

    inline function get_lineWidth():Int {
        return _lineWidth;
    }

    function set_align(value:String):String {
        if(_align == value)return _align;
        _align = value;
        _updateText();
        return _align;
    }

    inline function get_align():String {
        return _align;
    }
}