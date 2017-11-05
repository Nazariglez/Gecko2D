package k2d.i;

import k2d.render.Framebuffer;

interface IRenderer {
    public var framebuffer:Framebuffer;
    public function begin():Void;
    public function end():Void;
    public function reset():Void;
}