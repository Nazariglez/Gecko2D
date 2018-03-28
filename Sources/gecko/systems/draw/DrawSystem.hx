package gecko.systems.draw;

import gecko.Graphics;
import gecko.components.draw.DrawComponent;
import gecko.Float32;

@:access(gecko.Transform)
class DrawSystem extends System implements IDrawable implements IUpdatable {
    private var _entityMap:Map<Int, Bool> = new Map();

    public function init(){
        filter.is(DrawComponent);
        priority = 0;

        onEntityAdded += _addEntityToMap;
        onEntityRemoved += _removeEntityFromMap;
    }

    override public function beforeDestroy() {
        onEntityAdded -= _addEntityToMap;
        onEntityRemoved -= _removeEntityFromMap;

        for(key in _entityMap.keys()){
            _entityMap.remove(key);
        }

        super.beforeDestroy();
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
        var current:Transform = scene.rootEntity.transform;
        var last:Transform = current;
        var branch:Int = 0;
        var i = 0;
        var isRendered:Bool = false;

        while(current != null){
            isRendered = false;

            if(_canBeRendered(current.entity)){
                current.entity.renderer.worldAlpha = current.parent.entity.renderer.worldAlpha * current.entity.renderer.alpha;
                if(current.entity.renderer.worldAlpha > 0){
                    _renderEntity(current.entity, g);
                    isRendered = true;
                }
            }else if(current.entity == scene.rootEntity){
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
        return e.enabled && _entityMap.exists(e.id) && e.renderer != null && e.renderer.visible;
    }

    inline private function _renderEntity(e:Entity, g:Graphics) {
        e.transform.updateTransform();
        g.apply(e.transform.worldMatrix, e.renderer.color, e.renderer.worldAlpha);
        e.renderer.draw(g);
    }
}