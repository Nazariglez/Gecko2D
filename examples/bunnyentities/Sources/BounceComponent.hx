package;

import gecko.components.Component;
import gecko.math.Point;


class BounceComponent extends Component {
    public var speed:Point;

    public function init(speedX:Float, speedY:Float) {
        speed = Point.create(speedX, speedY);
    }

    override public function beforeDestroy() {
        speed.destroy();
        speed = null;

        super.beforeDestroy();
    }
}