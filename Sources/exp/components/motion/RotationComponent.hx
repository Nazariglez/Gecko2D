package exp.components.motion;

import exp.IUpdatable;
import exp.Float32;

class RotationComponent extends Component implements IUpdatable {
    public var speed:Float32;
    public var acceleration:Float32;

    public function init(speed:Float32, acceleration:Float32 = 0) {
        this.speed = speed;
        this.acceleration = acceleration;
    }

    public function update(dt:Float32) {}

    override public function reset(){
        speed = 0;
        acceleration = 0;
    }
}