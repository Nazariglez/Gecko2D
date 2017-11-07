package;

import k2d.math.Point;
import k2d.math.FastFloat;

class Bunny extends k2d.Sprite {
    public var speed:Point = new Point();

    public override function new(){
        super("rabbit.png");
    }

    public override function update(dt:FastFloat) {
        super.update(dt);
        position.x += speed.x;
        position.y += speed.y;
        speed.y += Game.GRAVITY;

        if (position.x > Game.MAX_X){
            speed.x *= -1;
            position.x = Game.MAX_X;
        } else if (position.x < Game.MIN_X) {
            speed.x *= -1;
            position.x = Game.MIN_X;
        }

        if (position.y > Game.MAX_Y) {
            speed.y *= -0.8;
            position.y = Game.MAX_Y;
            if (Math.random() > 0.5) speed.y -= 3 + Math.random() * 4;
        } else if (position.y < Game.MIN_Y) {
            speed.y = 0;
            position.y = Game.MIN_Y;
        }
    }
}