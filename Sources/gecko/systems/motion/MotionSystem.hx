package gecko.systems.motion;

import gecko.components.motion.RotationComponent;
import gecko.components.core.TransformComponent;
import gecko.components.motion.MovementComponent;
import gecko.Float32;

class MotionSystem extends System implements IUpdatable {
    public function init(){
        filter.equal(TransformComponent).any([MovementComponent, RotationComponent]);
    }

    override public function update(dt:Float32) {
        for(e in getEntities()){
            var transform:TransformComponent = e.transform;
            var movement:MovementComponent = e.getComponent(MovementComponent);
            var rotation:RotationComponent = e.getComponent(RotationComponent);

            if(movement != null){
                //accel and friction
                if(movement.acceleration.x != 0){

                    movement.speed.x += movement.acceleration.x*dt;

                }else if(movement.friction.x > 0 && movement.speed.x != 0){

                    var fx = movement.friction.x*dt;

                    if(movement.speed.x > 0){
                        movement.speed.x -= fx;
                        if(movement.speed.x < 0)movement.speed.x = 0;
                    }else if(movement.speed.x < 0){
                        movement.speed.x += fx;
                        if(movement.speed.x > 0)movement.speed.x = 0;
                    }

                }

                if(movement.acceleration.y != 0){

                    movement.speed.y += movement.acceleration.y*dt;

                }else if(movement.friction.y > 0 && movement.speed.y != 0){

                    var fy = movement.friction.y*dt;

                    if(movement.speed.y > 0){
                        movement.speed.y -= fy;
                        if(movement.speed.y < 0)movement.speed.y = 0;
                    }else if(movement.speed.y < 0){
                        movement.speed.y += fy;
                        if(movement.speed.y > 0)movement.speed.y = 0;
                    }

                }

                //speed update the current position
                transform.position.x += movement.speed.x*dt;
                transform.position.y += movement.speed.y*dt;
            }

            if(rotation != null){
                rotation.speed += rotation.acceleration*dt;
                transform.rotation += rotation.speed*dt;
            }
        }
    }
}