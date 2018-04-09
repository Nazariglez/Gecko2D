package gecko.systems.misc;

import gecko.components.misc.BehaviorComponent;

class BehaviorSystem extends System implements IUpdatable {
    public function init(){
        filter.is(BehaviorComponent);
    }

    override public function update(dt:Float32) {
        var e:Entity;
        for(e in getEntities()){
            if(!e.enabled)return;

            var componentsList = e.getAllComponents();
            for(c in componentsList){
                if(Std.is(c, BehaviorComponent)){
                    var behavior:BehaviorComponent = cast c;
                    behavior.update(dt);
                }
            }

        }
    }
}