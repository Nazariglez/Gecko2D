package components;


import gecko.input.KeyCode;
import gecko.components.Component;

class PlayerComponent extends Component {
    public var left:KeyCode;
    public var right:KeyCode;
    public var up:KeyCode;
    public var down:KeyCode;
    public var speed:Float = 0;

    public function init(leftKey:KeyCode, rightKey:KeyCode, upKey:KeyCode, downKey:KeyCode, speed:Float = 400){
        left = leftKey;
        right = rightKey;
        up = upKey;
        down = downKey;

        this.speed = speed;
    }
}