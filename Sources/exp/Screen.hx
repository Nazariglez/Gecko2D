package exp;

import exp.resources.Image;
import exp.render.Framebuffer;

class Screen {
    static public var buffer:Framebuffer;

    //todo _render screenbuffer to the global buffer
    static public function init(width:Int, height:Int) {
        buffer = Image.createRenderTarget(width, height); //todo antialias
    }
}