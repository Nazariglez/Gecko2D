package exp.systems.physics;

import exp.components.core.TransformComponent;
import exp.components.physics.BoundingBoxComponent;
import exp.Float32;

class BoundingBoxSystem extends System implements IUpdatable {
    public function init(){
        filter.all([TransformComponent, BoundingBoxComponent]);
    }

    override public function update(dt:Float32) {
        for(e in getEntities()){
            var box1:BoundingBoxComponent = e.getComponent(BoundingBoxComponent);

            for(e2 in getEntities()){
                if(e == e2)continue;

                var box2:BoundingBoxComponent = e2.getComponent(BoundingBoxComponent);

                var isAlreadyColliding = box1.isCollidingWith(e2);

                if(box1.left < box2.right && box1.right > box2.left && box1.top < box2.bottom && box1.bottom > box2.top){
                    if(isAlreadyColliding){
                        box1.onCollidingWith.emit(e2);
                        box2.onCollidingWith.emit(e);
                    }else{
                        box1.collidingWith.push(e2);
                        box2.collidingWith.push(e);

                        box1.onCollideStart.emit(e2);
                        box2.onCollideStart.emit(e);
                    }
                }else{
                    if(isAlreadyColliding){
                        box1.collidingWith.remove(e2);
                        box2.collidingWith.remove(e);

                        box1.onCollideStop.emit(e2);
                        box2.onCollideStop.emit(e);
                    }
                }
            }
        }
    }

}