package gecko.components.motion;



class RotationComponent extends Component {
    public var speed:Float;
    public var acceleration:Float;

    public function init(speed:Float, acceleration:Float = 0) {
        this.speed = speed;
        this.acceleration = acceleration;
    }

    override public function beforeDestroy(){
        speed = 0;
        acceleration = 0;

        super.beforeDestroy();
    }
}