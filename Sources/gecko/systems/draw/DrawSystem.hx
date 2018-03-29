package gecko.systems.draw;

import gecko.Graphics;
import gecko.components.draw.DrawComponent;
import gecko.Float32;

@:expose
@:access(gecko.Transform)
class DrawSystem extends System implements IDrawable implements IUpdatable {

    public function init(){
        filter.is(DrawComponent);
        priority = 5;
    }

    override public function update(dt:Float32) {
        for(e in getEntities()){
            if(e.enabled){
                e.getDrawComponent().update(dt);
            }
        }
    }

    override public function draw(g:Graphics) {
        //iterate through the tree (closing branchs from parent to childs)
        var current:Transform = scene.rootEntity.transform;
        var last:Transform = current;
        var branch:Int = 0;
        var i = 0;
        var isRendered:Bool = false;

        while(current != null){
            isRendered = false;

            var currentEntity = current.entity;

            if(currentEntity.enabled && hasEntity(currentEntity) && _canBeRendered(current.entity)){
                var drawComponent = currentEntity.getDrawComponent();
                var parentDrawComponent = current.parent.entity.getDrawComponent();

                drawComponent.worldAlpha = parentDrawComponent.worldAlpha * drawComponent.alpha;

                if(drawComponent.isVisible){
                    g.apply(current.worldMatrix, drawComponent.color, drawComponent.worldAlpha);
                    drawComponent.draw(g);

                    isRendered = true;
                }

            }else if(currentEntity == scene.rootEntity){
                isRendered = true;
            }

            branch = current._branch;
            last = current;
            current = current._nextChild;

            i = last._children.length-1;
            while(isRendered && i >= 0){
                last._children[i]._branch = branch+1;
                last._children[i]._nextChild = current;

                current = last._children[i];
                i--;
            }

            //todo reset _nextChild to null to prevent collide with others systems?
        }

        g.reset();
    }

    inline private function _canBeRendered(e:Entity) : Bool {
        return e.hasDrawComponent() && e.getDrawComponent().visible;
    }
}