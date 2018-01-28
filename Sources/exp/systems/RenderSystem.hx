package exp.systems;

import exp.render.IRendereable;
import exp.components.TransformComponent;
import exp.render.Renderer;

class RenderSystem extends System {
    override public function render(r:Renderer) {
        for(e in getEntities()){
            if(!e.enabled)continue;

            for(c in e.getAllComponents()){
                if(!c.enabled)continue;

                if(Std.is(c, IRendereable)){
                    var renderComponent:IRendereable = cast c;
                    if(!renderComponent.visible)continue;

                    renderComponent.render(r);
                }
            }
        }
    }

    override public function isValidEntity(entity:Entity) : Bool {
        if(!entity.hasComponent(TransformComponent))return false;
        var valid = false;
        for(c in entity.getAllComponents()){
            if(Std.is(c, IRendereable)){
                valid = true;
                break;
            }
        }
        return valid;
    }
}