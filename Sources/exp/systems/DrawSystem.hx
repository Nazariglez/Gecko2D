package exp.systems;

import exp.math.Matrix;
import exp.render.Graphics;
import exp.components.DrawComponent;
import exp.components.TransformComponent;

//todo matcher

@:expose
class DrawSystem extends System {
    public function init(){
        matcher.is(DrawComponent).equal(TransformComponent);
        priority = 0;

        disableUpdate = true;
        disableDraw = false;
    }

    override public function draw(g:Graphics) {
        for(e in getEntities()){
            if(!e.enabled || e.renderer == null || !e.renderer.enabled || !e.renderer.visible){
                continue;
            }

            g.matrix = e.transform.worldMatrix;
            g.color = e.renderer.color;

            if(e.transform.parent != null && e.transform.parent.renderer != null){
                g.alpha = e.renderer.alpha*e.transform.parent.renderer.alpha; //todo use worldAlpha
            }else{
                g.alpha = e.renderer.alpha;
            }

            if(g.alpha != 0){
                e.renderer.draw(g);
            }
        }

        g.reset();
    }
}