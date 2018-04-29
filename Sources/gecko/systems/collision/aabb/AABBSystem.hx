package gecko.systems.collision.aabb;

import gecko.components.collision.aabb.HitBoxComponent;
import gecko.Float32;

class AABBSystem extends System implements IUpdatable {
    public function init(){
        filter.equal(HitBoxComponent);
    }

    override public function update(dt:Float32) {
        eachEntity(function(e:Entity){
            var box1:HitBoxComponent = e.getComponent(HitBoxComponent);

            eachEntity(function(e2){
                if(e == e2)return;

                var box2:HitBoxComponent = e2.getComponent(HitBoxComponent);

                var canCollideBox1 = box1.canCollideWith(e2);
                var canCollideBox2 = box2.canCollideWith(e);

                if(!(canCollideBox1 && canCollideBox2)){
                    return;
                }

                var isAlreadyColliding = box1.isCollidingWith(e2);
                var existsCollision = box1.left < box2.right && box1.right > box2.left && box1.top < box2.bottom && box1.bottom > box2.top;

                if(existsCollision){
                    if(isAlreadyColliding){
                        if(canCollideBox1) box1.onCollidingWith.emit(e2);
                        if(canCollideBox2) box2.onCollidingWith.emit(e);
                    }else{
                        if(canCollideBox1){
                            box1.collidingWith.push(e2);
                            box1.onCollideStart.emit(e2);
                        }

                        if(canCollideBox2){
                            box2.collidingWith.push(e);
                            box2.onCollideStart.emit(e);
                        }
                    }
                }else{
                    if(isAlreadyColliding){
                        //todo dispatch always the remove and emit stop because a tag can be change while the system is updating?

                        if(canCollideBox1){
                            box1.collidingWith.remove(e2);
                            box1.onCollideStop.emit(e2);
                        }

                        if(canCollideBox2){
                            box2.collidingWith.remove(e);
                            box2.onCollideStop.emit(e);
                        }
                    }
                }
            });
        });
    }

}