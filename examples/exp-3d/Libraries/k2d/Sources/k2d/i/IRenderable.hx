package k2d.i;

import kha.Framebuffer;

interface IRenderable {
	public function onRender(framebuffer: Framebuffer): Void;
}