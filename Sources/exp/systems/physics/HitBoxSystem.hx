package exp.systems.physics;

import exp.components.core.TransformComponent;
import exp.components.physics.HitBoxComponent;
import exp.Float32;

class HitBoxSystem extends System implements IUpdatable {
    private var _frameID:Int = -1;

    public function init(){
        filter.all([TransformComponent, HitBoxComponent]);
    }

    override public function update(dt:Float32) {
        _frameID++;

        for(e in getEntities()){
            if(!e.enabled)continue;
            var box1:HitBoxComponent = e.getComponent(HitBoxComponent);

            if(e.transform.wasUpdated){
                var box1FrameID = @:privateAccess box1._frameID;

                if(box1FrameID != _frameID){
                    box1.updateBounds();
                    @:privateAccess box1._frameID++;
                }
            }

            for(e2 in getEntities()){
                if(!e2.enabled || e == e2)continue;

                var box2:HitBoxComponent = e2.getComponent(HitBoxComponent);

                if(e2.transform.wasUpdated){
                    var box2FrameID = @:privateAccess box2._frameID;

                    if(box2FrameID != _frameID){
                        box2.updateBounds();
                        @:privateAccess box2._frameID++;
                    }
                }

                var canCollideBox1 = box1.canCollideWith(e2);
                var canCollideBox2 = box2.canCollideWith(e);

                if(!(canCollideBox1 && canCollideBox2)){
                    continue;
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
            }
        }
    }

}