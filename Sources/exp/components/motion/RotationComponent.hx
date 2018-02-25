package exp.components.motion;

import exp.Float32;

class RotationComponent extends Component {
    public var speed:Float32;
    public var acceleration:Float32;

    public function init(speed:Float32, acceleration:Float32 = 0) {
        this.speed = speed;
        this.acceleration = acceleration;
    }

    override public function beforeDestroy(){
        speed = 0;
        acceleration = 0;

        super.beforeDestroy();
    }
}