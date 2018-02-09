package exp.systems;

import exp.components.DrawComponent;
import exp.components.TransformComponent;

//todo matcher

@:expose
class DrawSystem extends System {
    public function init(){
        matcher.is(DrawComponent).equal(TransformComponent);

        disableUpdate = true;
        disableDraw = false;
    }

    override public function draw() {
        for(e in getEntities()){
            if(!e.enabled)continue;

            /*for(c in e.getAllComponents()){
                if(!c.enabled)continue;

                if(Std.is(c, DrawComponent)){
                    var renderComponent:DrawComponent = cast c;
                    if(!renderComponent.visible)continue;

                    renderComponent.draw();
                }
            }*/

            if(e.renderer != null && e.renderer.enabled && e.renderer.visible){
                e.renderer.draw();
            }
        }
    }

    /*override public function isValidEntity(entity:Entity) : Bool {
        if(!entity.hasComponent(TransformComponent.__className__))return false;
        var valid = false;
        /*for(c in entity.getAllComponents()){
            if(Std.is(c, DrawComponent)){
                valid = true;
                break;
            }
        }
        return valid;
        return entity.dd != null;
    }*/
}