package;

import exp.components.Component;
import exp.math.Point;
import exp.Float32;

class MovementComponent extends Component {
    public var speed:Point;

    public function init(speedX:Float32, speedY:Float32) {
        speed = Point.create(speedX, speedY);
    }

    override public function reset() {
        speed.destroy();
        speed = null;
    }
}