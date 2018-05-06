package systems;

import gecko.components.motion.MovementComponent;
import gecko.Entity;
import gecko.math.Rect;
import gecko.input.Keyboard;

import gecko.IUpdatable;
import gecko.systems.System;

import components.PlayerComponent;

class PlayerSystem extends System implements IUpdatable {
    public var bounds:Rect;

    public function init(bounds:Rect){
        filter.all([PlayerComponent, MovementComponent]);

        this.bounds = bounds;
    }

    override public function update(dt:Float) {
        eachEntity(function(e:Entity){
            var player:PlayerComponent = e.getComponent(PlayerComponent);
            var movement:MovementComponent = e.getComponent(MovementComponent);

            //move entity horizontally
            if(Keyboard.isDown(player.left)){
                movement.speed.x = -player.speed;
            }else if(Keyboard.isDown(player.right)){
                movement.speed.x = player.speed;
            }else{
                movement.speed.x = 0;
            }

            //move entity vertically
            if(Keyboard.isDown(player.up)){
                movement.speed.y = -player.speed;
            }else if(Keyboard.isDown(player.down)){
                movement.speed.y = player.speed;
            }else{
                movement.speed.y = 0;
            }

            //check x bounds
            if(e.transform.left < bounds.left){
                e.transform.position.x = bounds.left + e.transform.width * e.transform.anchor.x;
            }else if(e.transform.right > bounds.right){
                e.transform.position.x = bounds.right - e.transform.width * e.transform.anchor.x;
            }

            //check y bounds
            if(e.transform.top < bounds.top){
                e.transform.position.y = bounds.top + e.transform.height * e.transform.anchor.y;
            }else if(e.transform.bottom > bounds.bottom){
                e.transform.position.y = bounds.bottom - e.transform.height * e.transform.anchor.y;
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