package exp.systems;

import exp.components.DrawComponent;
import exp.components.TransformComponent;

@:expose
class RenderSystem extends System {
    override public function init(name:String = ""){
        super.init(name);
        disableUpdate = true;
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

            if(e.dd != null && e.dd.enabled && e.dd.visible){
                e.dd.draw();
            }
        }
    }

    override public function isValidEntity(entity:Entity) : Bool {
        if(!entity.hasComponent(TransformComponent))return false;
        var valid = false;
        /*for(c in entity.getAllComponents()){
            if(Std.is(c, DrawComponent)){
                valid = true;
                break;
            }
        }
        return valid;*/
        return entity.dd != null;
    }
}