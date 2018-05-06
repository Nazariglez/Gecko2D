package gecko.timer;


import gecko.utils.Event;

class Timer extends BaseObject {
    public var onStart:Event<Void->Void>;
    public var onStop:Event<Void->Void>;
    public var onPause:Event<Void->Void>;
    public var onResume:Event<Void->Void>;
    public var onInit:Event<Void->Void>;
    public var onEnd:Event<Void->Void>;
    public var onRepeat:Event<Int->Void>;
    public var onUpdate:Event<Float->Float->Void>;

    public var time:Float = 0;
    public var destroyOnEnd:Bool = false;
    public var repeat:Int = 0;
    public var loop:Bool = false;
    public var delay:Float = 0;

    public var manager(default, null):TimerManager;
    public var isActive(default, null):Bool = false;
    public var isStarted(default, null):Bool = false;
    public var isEnded(default, null):Bool = false;
    public var isPaused(default, null):Bool = false;
    public var elapsedTime(default, null):Float = 0;

    private var _delayTime:Float = 0;
    private var _repeat:Int = 0;

    public function new(){
        super();

        onStart = Event.create();
        onStop = Event.create();
        onPause = Event.create();
        onResume = Event.create();
        onInit = Event.create();
        onEnd = Event.create();
        onRepeat = Event.create();
        onUpdate = Event.create();
    }

    public function init(time:Float, delay:Float = 0, loop:Bool = false, repeat:Int = 0, ?manager:TimerManager) {
        this.time = time;
        this.delay = delay;
        this.loop = loop;
        this.repeat = repeat;
        this.manager = manager != null ? manager : Gecko.timerManager;
        this.manager.timers.push(this);
    }

    public function update(dt:Float){
        if(time <= 0 || !isActive || isPaused)return;

        if(delay > _delayTime){
            _delayTime += dt;
            return;
        }

        if(!isStarted){
            isStarted = true;
            onInit.emit();
        }

        if(time > elapsedTime){
            var t = elapsedTime+dt;
            var ended = t >= time;

            elapsedTime = ended ? time : t;
            onUpdate.emit(elapsedTime, dt);

            if(ended){
                if(loop || repeat > _repeat){
                    _repeat++;
                    elapsedTime = 0;
                    onRepeat.emit(_repeat);
                    return;
                }

                isEnded = true;
                isActive = false;
                onEnd.emit();
            }
        }
    }

    public function start() {
        if(isActive){
            return;
        }

        isActive = true;
        onStart.emit();
    }

    public function stop() {
        if(!isActive){
            return;
        }

        isActive = false;
        reset();
        onStop.emit();
    }

    public function pause() {
        if(!isActive || isPaused){
            return;
        }

        isPaused = true;
        onPause.emit();
    }

    public function resume() {
        if(!isActive || !isPaused){
            return;
        }

        isPaused = false;
        onResume.emit();
    }

    public function reset() {
        _repeat = 0;
        _delayTime = 0;

        elapsedTime = 0;
        isStarted = false;
        isEnded = false;
    }

    public function clear() {
        time = 0;
        isActive = false;
        destroyOnEnd = false;
        repeat = 0;
        loop = false;
        delay = 0;
        isStarted = false;
        isEnded = false;
        isPaused = false;
        elapsedTime = 0;

        _delayTime = 0;
        _repeat = 0;
    }

    public function remove(){
        if(manager == null){
            return;
        }

        manager.removeTimer(this);
    }

    override public function beforeDestroy(){
        super.beforeDestroy();

        if(manager != null){
            remove();
        }

        clear();

        onInit.clear();
        onStart.clear();
        onStop.clear();
        onResume.clear();
        onPause.clear();
        onEnd.clear();
        onRepeat.clear();
        onUpdate.clear();
    }

}