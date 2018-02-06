package exp;

import exp.math.Matrix;
import exp.resources.Image;

class Screen {
    static public var buffer:Image;
    static public var matrix:Matrix = Matrix.identity();

    static public function init(opts:ScreenOptions, antialiasing:Int = 0) {
        buffer = Image.createRenderTarget(opts.width, opts.height, null, null, antialiasing);
        //todo set scale matrix
    }

    //todo center, width, height
}