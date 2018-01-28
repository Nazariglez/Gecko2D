package exp.utils;

import exp.Float32;
import kha.Scheduler;

class FPSCounter {
    public var fps:Float32 = 0;
    public var ms:Float32 = 0;
    public var timeToMeasure:Float32 = 1;

    private var _frames:Float32 = 0;
    private var _elapsed:Float32 = 0;
    private var _last:Float = 0;

    public function new(timeToMeasure:Float32 = 1){
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