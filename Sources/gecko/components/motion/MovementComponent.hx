package gecko.components.motion;

import gecko.math.Point;

class MovementComponent extends Component {
    public var speed:Point;
    public var acceleration:Point;
    public var friction:Point; //just if acceleration = 0

    public function init(speed:Point, ?acceleration:Point, ?friction:Point) {
        this.speed = speed;
        this.acceleration = acceleration != null ? acceleration : Point.create();
        this.friction = friction != null ? friction : Point.create();
    }

    override public function beforeDestroy(){
        speed.destroy();
        speed = null;
        acceleration.destroy();
        acceleration = null;
        friction.destroy();
        friction = null;

        super.beforeDestroy();
    }
}