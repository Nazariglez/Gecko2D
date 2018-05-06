package gecko.systems.motion;

import gecko.components.motion.RotationComponent;
import gecko.components.motion.MovementComponent;


class MotionSystem extends System implements IUpdatable {
    public function init(){
        filter.any([MovementComponent, RotationComponent]);
    }

    override public function update(dt:Float) {
        eachEntity(function(e:Entity){
            var transform:Transform = e.transform;
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
                transform.position.set(
                    transform.localPosition.x + movement.speed.x*dt,
                    transform.localPosition.y + movement.speed.y*dt
                );
            }

            if(rotation != null){
                rotation.speed += rotation.acceleration*dt;
                transform.localRotation += rotation.speed*dt;
            }
        });
    }
}