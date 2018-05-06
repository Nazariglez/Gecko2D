package gecko;

import kha.Scheduler;

class Time {
    static private var _initTime:Float = Scheduler.realTime();

    static public var scale:Float = 1;

    static public var fixedDelta(get, null):Float;
    static public var fixedTime(default, null):Float = 0;

    static public var fixedUnscaledDelta(default, null):Float = 0;
    static public var fixedUnscaledTime(default, null):Float = 0;

    static public var delta(get, null):Float;
    static public var time(default, null):Float = 0;

    static public var unscaledDelta(default, null):Float = 0;
    static public var unscaledTime(default, null):Float = 0;

    static public var realTime(get, null):Float;

    static private var _lastFixedNow:Float = 0;
    static private var _lastNow:Float = 0;

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

    inline static function get_fixedDelta():Float {
        return fixedUnscaledDelta * scale;
    }

    inline static function get_delta():Float {
        return unscaledDelta * scale;
    }

    inline static function get_realTime():Float {
        return Scheduler.realTime() - _initTime;
    }
}