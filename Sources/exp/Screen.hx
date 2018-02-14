package exp;

import kha.graphics4.TextureFormat;
import kha.graphics4.DepthStencilFormat;
import exp.math.Matrix;
import exp.resources.Image;

class Screen {
    static public var buffer(get, null):Image;
    static private var _buffer:Image;

    static public var width(get, null):Int;
    static public var height(get, null):Int;

    static public var matrix:Matrix = Matrix.identity();

    static public function init(opts:ScreenOptions, antialiasing:Int = 0) {
        _buffer = Image.createRenderTarget(opts.width, opts.height, TextureFormat.RGBA32, NoDepthAndStencil, antialiasing);
        //todo set center var
        //todo set scale matrix
    }

    static inline function get_buffer():Image {
        return _buffer;
    }

    static inline function get_width():Int {
        return _buffer.width;
    }

    static inline function get_height():Int {
        return _buffer.height;
    }

    //todo center var
}