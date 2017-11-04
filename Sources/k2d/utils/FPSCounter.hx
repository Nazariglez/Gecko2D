package k2d.utils;

import kha.Scheduler;
import k2d.math.FastFloat;

class FPSCounter {
    public var fps:FastFloat = 0;
    public var ms:FastFloat = 0;
    public var timeToMeasure:FastFloat = 1;

    private var _frames:FastFloat = 0;
    private var _elapsed:FastFloat = 0;
    private var _last:Float = 0;

    public function new(timeToMeasure:FastFloat = 1){
        this.timeToMeasure = timeToMeasure;
    }

    public function tick() : Void {
        var now = Scheduler.realTime();
        _frames++;
        _elapsed += now - _last;
        _last = now;

        if(_elapsed >= timeToMeasure){
            fps = Math.round((_frames/_elapsed)*100)/100;
            ms = Math.round((_elapsed/_frames)*1000);
            _frames = 0;
            _elapsed = 0;
        }
    }
}