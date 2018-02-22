package exp.components.motion;

import exp.math.Point;
import exp.IUpdatable;
import exp.Float32;

class MovementComponent extends Component implements IUpdatable {
    public var speed:Point;
    public var acceleration:Point;
    public var friction:Point; //just if acceleration = 0

    public function init(speed:Point, ?acceleration:Point, ?friction:Point) {
        this.speed = speed;
        this.acceleration = acceleration != null ? acceleration : Point.create();
        this.friction = friction != null ? friction : Point.create();
    }

    public function update(dt:Float32) {}

    override public function reset(){
        speed.destroy();
        speed = null;
        acceleration.destroy();
        acceleration = null;
        friction.destroy();
        friction = null;
    }
}