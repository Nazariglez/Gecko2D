package gecko;

import gecko.math.Point;
import gecko.math.Vector2;
import kha.graphics4.TextureFormat;
import kha.graphics4.DepthStencilFormat;
import gecko.math.Matrix;
import gecko.resources.Image;

private enum AnchorMode {
    TopLeft; TopCenter; TopRight;
    LeftCenter; Center; RightCenter;
    BottomLeft; BottomCenter; BottomRight;
}


class Screen {
    static private var _initiated:Bool = false;

    static public var Anchor(default, never) = AnchorMode;

    static public var buffer(default, null):Image;

    static public var width(get, null):Float32;
    static public var height(get, null):Float32;
    static public var mode(get, set):ScreenMode;
    static private var _mode:ScreenMode = ScreenMode.None;

    static public var matrix:Matrix = Matrix.identity();

    static private var _scale:Vector2 = new Vector2(1, 1);
    static private var _position:Vector2 = new Vector2(0, 0);
    static private var _size:Vector2 = new Vector2(0, 0);
    static private var _anchor:Vector2 = new Vector2(0.5, 0.5);

    static public var windowWidth(default, null):Int = 0;
    static public var windowHeight(default, null):Int = 0;

    static public var centerX(default, null):Float32 = 0;
    static public var centerY(default, null):Float32 = 0;

    static public function init(opts:ScreenOptions, antialiasing:Int, _windowWidth:Int, _windowHeight:Int) {
        _size.x = opts.width;
        _size.y = opts.height;
        windowWidth = _windowWidth;
        windowHeight = _windowHeight;

        _fixPosition();

        var ww = Std.int(_size.x);
        var hh = Std.int(_size.y);
        buffer = Image.createRenderTarget(ww, hh, TextureFormat.RGBA32, NoDepthAndStencil, antialiasing);

        centerX = ww*0.5;
        centerY = hh*0.5;

        mode = opts.mode;
        _updateMatrix();

        if(!_initiated){
            Gecko.onWindowResize += _changeWindowSize;
            _initiated = true;
        }
    }
    
    inline static public function getRealScreenPoint(x:Float32, y:Float32, outPoint:Point) {
        var id = 1 / ((matrix._00 * matrix._11) + (matrix._10 * -matrix._01));
        outPoint.set(
            (matrix._11 * id * x) + (-matrix._10 * id * y) + (((matrix._21 * matrix._10) - (matrix._20 * matrix._11)) * id),
            (matrix._00 * id * y) + (-matrix._01 * id * x) + (((-matrix._21 * matrix._00) + (matrix._20 * matrix._01)) * id)
        );
    }

    static public function setAnchor(anchor:AnchorMode) {
        switch(anchor){
            case AnchorMode.TopLeft:
                _anchor.x = 0;
                _anchor.y = 0;
            case AnchorMode.TopCenter:
                _anchor.x = 0.5;
                _anchor.y = 0;
            case AnchorMode.TopRight:
                _anchor.x = 1;
                _anchor.y = 0;
            case AnchorMode.LeftCenter:
                _anchor.x = 0;
                _anchor.y = 0.5;
            case AnchorMode.Center:
                _anchor.x = 0.5;
                _anchor.y = 0.5;
            case AnchorMode.RightCenter:
                _anchor.x = 1;
                _anchor.y = 0.5;
            case AnchorMode.BottomLeft:
                _anchor.x = 0;
                _anchor.y = 1;
            case AnchorMode.BottomCenter:
                _anchor.x = 0.5;
                _anchor.y = 1;
            case AnchorMode.BottomRight:
                _anchor.x = 1;
                _anchor.y = 1;
        }

        _fixPosition();
        _updateMatrix();
    }

    static private function _fixPosition() {
        _position.x = windowWidth*(1-_anchor.x);
        _position.y = windowHeight*(1-_anchor.y);
    }

    //todo add a custom "resizeCallback"

    static private function _changeWindowSize(width:Int, height:Int) {
        windowWidth = width;
        windowHeight = height;

        _fixPosition();
        _setScreenMode(_mode);
    }

    //todo shake?

    static private function _updateMatrix() {
        matrix._00 = _scale.x;
        matrix._11 = _scale.y;

        matrix._20 = _position.x - ( (_anchor.x * _size.x * _scale.x) );
        matrix._21 = _position.y - ( (_anchor.y * _size.y * _scale.y) );

    }

    static private function _setScreenMode(sm:ScreenMode) : ScreenMode {
        switch(_mode) {
            case ScreenMode.Fill:
                _scale.x = windowWidth/buffer.width;
                _scale.y = windowHeight/buffer.height;

            case ScreenMode.AspectFill:
                var scale = Math.max(windowWidth/buffer.width, windowHeight/buffer.height);
                _scale.x = scale;
                _scale.y = scale;

            case ScreenMode.AspectFit:
                var scale = Math.min(windowWidth/buffer.width, windowHeight/buffer.height);
                _scale.x = scale;
                _scale.y = scale;

            default:
        }

        _updateMatrix();
        return _mode;
    }

    static inline function get_width():Float32 {
        return buffer.width;
    }

    static inline function get_height():Float32 {
        return buffer.height;
    }

    static inline function get_mode():ScreenMode {
        return _mode;
    }

    static inline function set_mode(value:ScreenMode):ScreenMode {
        if(value == _mode)return _mode;
        _mode = value;
        return _setScreenMode(_mode);
    }
}