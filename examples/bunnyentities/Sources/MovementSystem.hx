package;

import exp.components.core.TransformComponent;
import exp.Float32;
import exp.systems.System;
import exp.IUpdatable;
import exp.Screen;

class MovementSystem extends System implements IUpdatable {
    public var gravity:Float32;

    public function init(gravity:Float32){
        filter.all([TransformComponent, MovementComponent]);

        this.gravity = gravity;
    }

    override public function update(dt:Float32) {
        for(e in getEntities()){
            var transform:TransformComponent = e.transform; //builtin reference to the TransformComponent
            var movement:MovementComponent = e.getComponent(MovementComponent);

            transform.position.x += movement.speed.x;
            transform.position.y += movement.speed.y;
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