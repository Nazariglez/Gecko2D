package exp.timer;

import exp.macros.IAutoPool;
import exp.Float32;

class TimerManager implements IAutoPool {
    public var timers:Array<Timer> = [];
    private var _timersToDelete:Array<Timer> = [];

    public function new(){}

    public function tick() {
        for(t in timers){
            if(!t.isActive){
                continue;
            }

            t.update(Gecko.systemUpdateTicker.delta);

            if(t.isEnded && t.destroyOnEnd) {
                t.destroy();
            }
        }

        if(_timersToDelete.length > 0){
            var t = _timersToDelete.pop();
            while(t != null){
                _remove(t);
                t = _timersToDelete.pop();
            }
        }
    }

    inline public function createTimer(time:Float32, delay:Float32 = 0, loop:Bool = false, repeat:Int = 0) : Timer {
        return Timer.create(time, delay, loop, repeat, this);
    }

    inline public function createGroup(timers:Array<Timer>) : TimerGroup {
        return TimerGroup.create(timers);
    }

    inline public function removeTimer(timer:Timer) {
        _timersToDelete.push(timer);
    }

    public function clear(){
        for(t in timers){
            t.clear();
        }
    }

    private function _remove(timer:Timer) {
        timers.remove(timer);
    }

    public function beforeDestroy(){
        var t:Timer = _timersToDelete.pop();
        while(t != null){
            t.destroy();
            t = _timersToDelete.pop();
        }

        t = timers.pop();
        while(t != null){
            t.destroy();
            t = timers.pop();
        }
    }
    public function destroy(){}
}