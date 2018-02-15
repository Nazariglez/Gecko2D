package exp;

import exp.math.Vector2;
import kha.graphics4.TextureFormat;
import kha.graphics4.DepthStencilFormat;
import exp.math.Matrix;
import exp.resources.Image;

//todo set anchor (position) TOP_LEFT, TOP_RIGHT, TOP_CENTER, LEFT_CENTER, CENTER, RIGHT_CENTER, BOTTOM_LEFT, BOTTOM_RIGHT, BOTTOM_CENTER

class Screen {
    static private var _initiated:Bool = false;

    static public var buffer(default, null):Image;

    static public var width(get, null):Int;
    static public var height(get, null):Int;
    static public var mode(get, set):ScreenMode;
    static private var _mode:ScreenMode = ScreenMode.None;

    static public var matrix:Matrix = Matrix.identity();

    static private var _scale:Vector2 = new Vector2(1, 1);
    static private var _position:Vector2 = new Vector2(0, 0);
    static private var _size:Vector2 = new Vector2(0, 0);
    static private var _anchor:Vector2 = new Vector2(0.5, 0.5);

    static private var _windowWidth:Int = 0;
    static private var _windowHeight:Int = 0;

    static public function init(opts:ScreenOptions, antialiasing:Int, windowWidth:Int, windowHeight:Int) {
        _size.x = opts.width;
        _size.y = opts.height;
        _windowWidth = windowWidth;
        _windowHeight = windowHeight;

        _position.x = _windowWidth*(1-_anchor.x);
        _position.y = _windowHeight*(1-_anchor.y);

        buffer = Image.createRenderTarget(Std.int(_size.x), Std.int(_size.y), TextureFormat.RGBA32, NoDepthAndStencil, antialiasing);

        mode = opts.mode;
        _updateMatrix();

        //todo set center var

        if(!_initiated){
            Gecko.onWindowResize += _changeWindowSize;
            _initiated = true;
        }
    }

    static private function _changeWindowSize(width:Int, height:Int) {
        _windowWidth = width;
        _windowHeight = height;

        _position.x = _windowWidth*(1-_anchor.x);
        _position.y = _windowHeight*(1-_anchor.y);

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
                _scale.x = _windowWidth/buffer.width;
                _scale.y = _windowHeight/buffer.height;

            case ScreenMode.AspectFill:
                var scale = Math.max(_windowWidth/buffer.width, _windowHeight/buffer.height);
                _scale.x = scale;
                _scale.y = scale;

            case ScreenMode.AspectFit:
                var scale = Math.min(_windowWidth/buffer.width, _windowHeight/buffer.height);
                _scale.x = scale;
                _scale.y = scale;

            default:
        }

        _updateMatrix();
        return _mode;
    }

    static inline function get_width():Int {
        return buffer.width;
    }

    static inline function get_height():Int {
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

    //todo center var
}