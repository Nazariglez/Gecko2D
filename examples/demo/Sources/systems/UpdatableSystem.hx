package systems;

import gecko.Float32;
import gecko.IUpdatable;
import gecko.systems.System;

import components.UpdatableComponent;

//System to help with the examples
class UpdatableSystem extends System implements IUpdatable {
    public function init() {
        filter.is(UpdatableComponent);
    }

    override public function update(dt:Float32) {
        for(e in getEntities()){
            var component:UpdatableComponent = e.getComponent(UpdatableComponent);
        }
    }
}