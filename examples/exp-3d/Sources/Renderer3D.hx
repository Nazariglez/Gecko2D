package;

import k2d.render.Renderer;
import kha.graphics4.Graphics;
import k2d.render.Framebuffer;

class Renderer3D extends Renderer {
    public var graphics:Graphics;

    public function new(){}

    override public function begin() {}

    override public function end() {}

    override public function clear() {}

    override public function setFramebuffer(framebuffer:Framebuffer) {
        _framebuffer = framebuffer;
        graphics = framebuffer.g4;
    }


}