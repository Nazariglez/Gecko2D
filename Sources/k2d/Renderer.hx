package k2d;

import kha.graphics2.Graphics;
import kha.graphics2.GraphicsExtension;


class Renderer {
    public var graphics:Graphics;

    private var _framebuffer:Framebuffer;

    public function new(){}

    @:extern public inline function setFramebuffer(framebuffer:Framebuffer) {
        if(_framebuffer == null){
            _framebuffer = framebuffer;
            graphics = framebuffer.g2;
        }
    }

    @:extern public inline function drawLine(x1:Float, y1:Float, x2:Float, y2:Float, ?strength:Float) : Void {
		graphics.drawLine(x1, y1, x2, y2, strength);
	}
}