package exp.components;

import exp.render.BlendMode;
import exp.render.IRendereable;
import exp.render.Renderer;
import exp.Float32;

class RenderComponent extends exp.Component implements IRendereable {
    public var alpha:Float32 = 1.0;
    public var color:Color = Color.White;
    public var blendMode:BlendMode = null;

    public function baseRender(r:Renderer) {}
    dynamic public function render(r:Renderer) {
        baseRender(r);
    }
}