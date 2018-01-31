package exp.components;

import exp.render.Renderer;

//Used to draw content dynamically 
class CanvasComponent extends RenderComponent {
    dynamic public function draw(r:Renderer) {}

    override public function render(r:Renderer){
        draw(r);
    }
}