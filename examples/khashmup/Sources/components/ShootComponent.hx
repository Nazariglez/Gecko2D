package components;

import gecko.IUpdatable;
import gecko.Float32;
import gecko.input.KeyCode;
import gecko.components.Component;

class ShootComponent extends Component implements IUpdatable {
    public var key:KeyCode;
    public var delay:Float32 = 0;
    public var speed:Float32 = 0;

    private var _time:Float32 = 0;

    public function init(shootKey:KeyCode, shotSpeed:Float32 = 720, timeInterval:Float32 = 0.25) {
        key = shootKey;
        delay = timeInterval;
        speed = shotSpeed;
        _time = 0;
    }

    public function update(dt:Float32) {
        if(_time > 0)_time -= dt;
    }

    inline public function resetTimer() {
        _time = delay;
    }

    inline public function canShoot() : Bool {
        return _time <= 0;
    }
}