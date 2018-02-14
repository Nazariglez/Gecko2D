package exp.systems;

import exp.render.Graphics;
import exp.components.DrawComponent;
import exp.components.TransformComponent;
import exp.Float32;

//todo matcher

@:expose
class DrawSystem extends System {
    private var _entityMap:Map<Int, Bool> = new Map();

    public function init(){
        matcher.is(DrawComponent).equal(TransformComponent);
        priority = 0;

        disableUpdate = false;
        disableDraw = false;

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
            e.renderer.dirtyAlpha = true;
        }
    }

    override public function draw(g:Graphics) {
        _drawChildren(scene.rootEntity.transform.children, g);

        g.reset();
    }

    private function _drawChildren(children:Array<Entity>, g:Graphics) {
        //TODO avoid recursive calls!
        for(e in children){
            if(_entityMap.exists(e.id)){

                if(!e.enabled || e.renderer == null || !e.renderer.enabled || !e.renderer.visible || e.renderer.worldAlpha <= 0){
                    continue;
                }

                _drawEntity(e, g);

                //todo thinks about this, if a parent don't have a drawComponent children needs to be renderer?
                if(e.transform.children.length != 0){
                    _drawChildren(e.transform.children, g);
                }
            }
        }
    }

    private function _drawEntity(e:Entity, g:Graphics) {
        g.apply(e.transform.worldMatrix, e.renderer.color, e.renderer.worldAlpha);

        if(g.alpha != 0){
            e.renderer.draw(g);
        }
    }
}