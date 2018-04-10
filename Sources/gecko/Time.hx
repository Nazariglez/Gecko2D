package gecko;

import kha.Scheduler;

class Time {
    static private var _initTime:Float32 = Scheduler.realTime();

    static public var scale:Float32 = 1;

    static public var fixedDelta(get, null):Float32;
    static public var fixedTime(default, null):Float32 = 0;

    static public var fixedUnscaledDelta(default, null):Float32 = 0;
    static public var fixedUnscaledTime(default, null):Float32 = 0;

    static public var delta(get, null):Float32;
    static public var time(default, null):Float32 = 0;

    static public var unscaledDelta(default, null):Float32 = 0;
    static public var unscaledTime(default, null):Float32 = 0;

    static public var realTime(get, null):Float32;

    static private var _lastFixedNow:Float32 = 0;
    static private var _lastNow:Float32 = 0;

    static private function _tick() {
        var fixedNow = Scheduler.time();
        var now = Scheduler.realTime();

        fixedUnscaledDelta = fixedNow - _lastFixedNow;
        unscaledDelta = now - _lastNow;

        fixedUnscaledTime += fixedUnscaledDelta;
        unscaledTime += unscaledDelta;

        fixedTime += fixedUnscaledDelta * scale;
        time += unscaledDelta * scale;

        _lastNow = now;
        _lastFixedNow = fixedNow;
    }

    static private function _clear() {
        _lastNow = Scheduler.realTime();
        _lastFixedNow = Scheduler.time();
    }

    inline static function get_fixedDelta():Float32 {
        return fixedUnscaledDelta * scale;
    }

    inline static function get_delta():Float32 {
        return unscaledDelta * scale;
    }

    inline static function get_realTime():Float32 {
        return Scheduler.realTime() - _initTime;
    }
}