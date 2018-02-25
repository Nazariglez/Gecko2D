package;

import exp.components.Component;
import exp.math.Point;
import exp.Float32;

class BounceComponent extends Component {
    public var speed:Point;

    public function init(speedX:Float32, speedY:Float32) {
        speed = Point.create(speedX, speedY);
    }

    override public function beforeDestroy() {
        speed.destroy();
        speed = null;

        super.beforeDestroy();
    }
}