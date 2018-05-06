package systems;

import gecko.Audio;
import gecko.components.collision.aabb.HitBoxComponent;
import gecko.math.Point;
import gecko.components.motion.MovementComponent;
import gecko.components.draw.SpriteComponent;
import gecko.input.Keyboard;
import gecko.Entity;

import gecko.IUpdatable;
import gecko.systems.System;

import components.ShootComponent;
import components.OutBoundsComponent;

class ShootSystem extends System implements IUpdatable {
    public function init(){
        filter.equal(ShootComponent);
    }

    override public function update(dt:Float) {
        eachEntity(function(e:Entity){
            var shootComponent:ShootComponent = e.getComponent(ShootComponent);
            shootComponent.update(dt);

            if(Keyboard.isDown(shootComponent.key) && shootComponent.canShoot()){
                shootComponent.resetTimer();

                shoot(
                    e.transform.left + e.transform.width / 2,
                    e.transform.top,
                    -shootComponent.speed
                );
            }
        });
    }

    public function shoot(x:Float, y:Float, speedY:Float) {
        if(scene == null)return;

        var shot = scene.createEntity();
        shot.addComponent(SpriteComponent.create("bullet.png"));
        shot.addComponent(MovementComponent.create(Point.create(0, speedY)));
        shot.addComponent(HitBoxComponent.create());
        shot.addComponent(OutBoundsComponent.create());

        shot.transform.anchor.set(0.5, 1);
        shot.transform.position.set(x, y);

        shot.addTag("shot");

        var audio:Audio = Audio.create("bulletShoot.wav");
        audio.destroyOnEnd = true;
        audio.play();
    }
}