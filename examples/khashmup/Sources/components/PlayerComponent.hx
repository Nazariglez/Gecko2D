package components;

import gecko.Float32;
import gecko.input.KeyCode;
import gecko.components.Component;

class PlayerComponent extends Component {
    public var left:KeyCode;
    public var right:KeyCode;
    public var up:KeyCode;
    public var down:KeyCode;
    public var speed:Float32 = 0;

    public function init(leftKey:KeyCode, rightKey:KeyCode, upKey:KeyCode, downKey:KeyCode, speed:Float32 = 400){
        left = leftKey;
        right = rightKey;
        up = upKey;
        down = downKey;

        this.speed = speed;
    }
}