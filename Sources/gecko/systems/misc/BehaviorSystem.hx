package gecko.systems.misc;

import gecko.components.misc.BehaviorComponent;

class BehaviorSystem extends System implements IUpdatable {
    public function init(){
        filter.base([BehaviorComponent]);
    }

    override public function update(dt:Float32) {
        for(e in getEntities()){
            if(!e.enabled)return;

            var components:Array<BehaviorComponent> = e.getComponentsOfType(BehaviorComponent);
            for(c in components){
                c.update(dt);
            }
        }
    }
}