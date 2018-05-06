package components;

import gecko.IUpdatable;

import gecko.input.KeyCode;
import gecko.components.Component;

class ShootComponent extends Component implements IUpdatable {
    public var key:KeyCode;
    public var delay:Float = 0;
    public var speed:Float = 0;

    private var _time:Float = 0;

    public function init(shootKey:KeyCode, shotSpeed:Float = 720, timeInterval:Float = 0.25) {
        key = shootKey;
        delay = timeInterval;
        speed = shotSpeed;
        _time = 0;
    }

    public function update(dt:Float) {
        if(_time > 0)_time -= dt;
    }

    inline public function resetTimer() {
        _time = delay;
    }

    inline public function canShoot() : Bool {
        return _time <= 0;
    }
}