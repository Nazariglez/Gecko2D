package;

import gecko.Transform;
import gecko.Float32;
import gecko.systems.System;
import gecko.IUpdatable;
import gecko.Screen;

class BounceSystem extends System implements IUpdatable {
    public var gravity:Float32;

    public function init(gravity:Float32){
        filter.equal(BounceComponent);

        this.gravity = gravity;
    }

    override public function update(dt:Float32) {
        for(e in getEntities()){
            var transform:Transform = e.transform;
            var movement:BounceComponent = e.getComponent(BounceComponent);

            transform.position.set(
                transform.position.x + movement.speed.x,
                transform.position.y + movement.speed.y
            );

            movement.speed.y += gravity;

            if(transform.position.x > Screen.width){
                movement.speed.x *= -1;
                transform.position.x = Screen.width;
            }else if(transform.position.x < 0){
                movement.speed.x *= -1;
                transform.position.x = 0;
            }

            if(transform.position.y > Screen.height){
                movement.speed.y *= -0.85;
                transform.position.y = Screen.height;

                if(Math.random() > 0.5){
                    movement.speed.y -= Math.random() * 6;
                }

            }else if(transform.position.y < 0){
                movement.speed.y = 0;
                transform.position.y = 0;
            }
        }
    }
}