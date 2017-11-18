package k2d.timer;

import k2d.math.FastFloat;

class TimerManager {
    static public var Global:TimerManager = new TimerManager();

    public var timers:Array<Timer> = new Array<Timer>();
    private var _toDelete:Array<Timer> = new Array<Timer>();

    private var _ms:FastFloat = 0;

    public function new(){}

    public function update(dt:FastFloat) {
        _ms = dt*1000;

        for(timer in timers){
            if(timer.isActive){
                timer.update(dt, _ms);
                if(timer.isEnded && timer.expire){
                    timer.remove();
                }
            }
        }

        if(_toDelete.length > 0){
            for(timer in _toDelete){
                _remove(timer);
                _toDelete = new Array<Timer>();
            }
        }
    }

    public inline function createTimer(time:FastFloat) {
        return new Timer(time, this);
    }

    public inline function createGroup(timers:Array<Timer>) : TimerGroup {
        return new TimerGroup(timers);
    }

    public function addTimer(timer:Timer) {
        timer.manager = this;
        timers.push(timer);
    }

    public function removeTimer(timer:Timer) {
        _toDelete.push(timer);
    }

    private function _remove(timer:Timer) {
        timers.remove(timer);
    }
}

