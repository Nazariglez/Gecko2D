package;

import gecko.components.Component;
import gecko.math.Point;
import gecko.Float32;

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