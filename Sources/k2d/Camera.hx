package k2d;

import k2d.render.Renderer;

class Camera extends Entity {
    public var watch:Entity;

    override public function render(r:Renderer) {
        super.render(r);

        if(watch != null){
            watch.renderToCamera(this, r);
        }
    }
}