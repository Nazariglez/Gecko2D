package k2d.i;

import k2d.render.Framebuffer;

interface IRenderer {
    private var _framebuffer:Framebuffer;
    public function setFramebuffer(frb:Framebuffer):Void;
    public function begin():Void;
    public function end():Void;
    public function clear():Void;
}