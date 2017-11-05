package k2d.render;

import k2d.i.IRenderer;

class Renderer implements IRenderer {
    public var framebuffer:Framebuffer;
    public function begin():Void {};
    public function end():Void {};
    public function reset():Void {};
}