package exp.systems.draw;

import exp.render.Graphics;
import exp.components.draw.DrawComponent;
import exp.components.core.TransformComponent;
import exp.Float32;

@:expose
class DrawSystem extends System implements IDrawable implements IUpdatable {
    private var _entityMap:Map<Int, Bool> = new Map();

    public function init(){
        filter.is(DrawComponent).equal(TransformComponent);
        priority = 0;

        onEntityAdded += _addEntityToMap;
        onEntityRemoved += _removeEntityFromMap;
    }

    private function _addEntityToMap(entity:Entity) {
        _entityMap.set(entity.id, true);
    }

    private function _removeEntityFromMap(entity:Entity) {
        _entityMap.remove(entity.id);
    }

    override public function update(dt:Float32) {
        for(e in getEntities()){
            if(e.enabled){
                e.renderer.update(dt);
            }
        }
    }

    override public function draw(g:Graphics) {
        //iterate through the tree (closing branchs from parent to childs)
        var current:Entity = scene.rootEntity;
        var last:Entity = current;
        var branch:Int = 0;
        var i = 0;
        var isRendered:Bool = false;

        while(current != null){
            isRendered = false;

            if(_canBeRendered(current)){
                current.renderer.worldAlpha = current.transform.parent.renderer.worldAlpha * current.renderer.alpha;
                if(current.renderer.worldAlpha > 0){
                    _renderEntity(current, g);
                    isRendered = true;
                }
            }else if(current == scene.rootEntity){
                isRendered = true;
            }

            branch = current.transform._branch;
            last = current;
            current = current.transform._nextChild;

            i = last.transform.children.length-1;
            while(isRendered && i >= 0){
                last.transform.children[i].transform._branch = branch+1;
                last.transform.children[i].transform._nextChild = current;

                current = last.transform.children[i];
                i--;
            }

            //todo reset _nextChild to null to prevent collide with others systems?
        }

        g.reset();
    }

    inline private function _canBeRendered(e:Entity) : Bool {
        return e.enabled && _entityMap.exists(e.id) && e.renderer != null && e.renderer.visible;
    }

    inline private function _renderEntity(e:Entity, g:Graphics) {
        g.apply(e.transform.worldMatrix, e.renderer.color, e.renderer.worldAlpha);
        e.renderer.draw(g);
    }
}