package gecko.timer;



class TimerManager extends BaseObject {
    public var timers:Array<Timer> = [];
    private var _timersToDelete:Array<Timer> = [];
    private var _isProcessing:Bool = false;

    public function tick(delta:Float) {
        _isProcessing = true;
        for(t in timers){
            if(!t.isActive){
                continue;
            }

            t.update(delta);

            if(t.isEnded && t.destroyOnEnd) {
                t.destroy();
            }
        }

        while(_timersToDelete.length > 0){
            var t = _timersToDelete.shift();
            _remove(t);
        }

        _isProcessing = false;
    }

    inline public function createTimer(time:Float, delay:Float = 0, loop:Bool = false, repeat:Int = 0) : Timer {
        return Timer.create(time, delay, loop, repeat, this);
    }

    inline public function createGroup(timers:Array<Timer>) : TimerGroup {
        return TimerGroup.create(timers);
    }

    inline public function removeTimer(timer:Timer) {
        if(_isProcessing){
            _timersToDelete.push(timer);
        }else{
            _remove(timer);
        }
    }

    public function clear(){
        for(t in timers){
            t.clear();
        }
    }

    public function cleanTimers() {
        while(timers.length > 0){
            var t = timers.shift();
            t.destroy();
        }

        while(_timersToDelete.length > 0){
            var t = _timersToDelete.shift();
            t.destroy();
        }
    }

    inline private function _remove(timer:Timer) {
        timers.remove(timer);
    }

    override public function beforeDestroy(){
        super.beforeDestroy();

        cleanTimers();

        _isProcessing = false;
    }
}