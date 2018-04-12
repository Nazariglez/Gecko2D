package systems;

import gecko.Entity;
import gecko.Float32;
import gecko.math.Rect;
import gecko.systems.System;
import gecko.IUpdatable;

import components.OutBoundsComponent;

class OutBoundsSystem extends System implements IUpdatable {
    public var bounds:Rect;

    public function init(bounds:Rect) {
        filter.all([OutBoundsComponent]);

        this.bounds = bounds;
    }

    override public function update(dt:Float32) {
        eachEntity(function(e:Entity){
            //destroy entity if is out of bounds
            if(e.transform.top > bounds.bottom || e.transform.bottom < bounds.top || e.transform.left > bounds.right || e.transform.right < bounds.left){
                e.destroy();
            }
        });
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        //destroy rect bounds
        bounds.destroy();
        bounds = null;
    }
}