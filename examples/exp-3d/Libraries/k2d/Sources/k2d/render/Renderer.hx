package k2d.render;

import k2d.i.IRenderer;

class Renderer implements IRenderer {
    private var _framebuffer:Framebuffer;
    public function setFramebuffer(frb:Framebuffer):Void {};
    public function begin():Void {};
    public function end():Void {};
    public function clear():Void {};
}