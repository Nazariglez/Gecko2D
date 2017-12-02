package k2d.utils;

private typedef EventPointer = {
    var name:String;
    var emitter:EventEmitter;
    var once:Bool;
};

abstract Event<T>(EventPointer) from EventPointer to Event<T> {
    public var name(get, never):String;
    inline function get_name() : String {
        return this.name;
    }

    public var emitter(get, set):EventEmitter;
    inline function get_emitter() : EventEmitter {
        return this.emitter;
    }
    inline function set_emitter(emitter:EventEmitter) : EventEmitter {
        return this.emitter = emitter;
    }

    public var once(get, never):Bool;
    inline function get_once() : Bool {
        return this.once;
    }

    inline public function new(event:String, once:Bool = false, ?emitter:EventEmitter) {
        this = {
            name:event,
            once:once,
            emitter:emitter
        };
    }

    @:op(A += B) inline function addListener(b:T) {
        this.emitter.addListener(this.name, b, this.once);
    }

    @:op(A -= B) inline function removeListener(b:T) {
        this.emitter.removeListener(this.name, b);
    }
}

class EventEmitter {
    public var eventsOnce:Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();
    public var events:Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();
    
    public function new(){}

    public function emit(event:String, args: Dynamic = null){
        if(eventsOnce.exists(event)){
            for(evt in eventsOnce[event]){
                Reflect.callMethod(null, evt, args);
                removeListener(event, evt);
            }
        }

        if(events.exists(event)){
            for(evt in events[event]){
                Reflect.callMethod(null, evt, args);
            }
        }
    }

    public function bind<T>(event:Event<T>) : Event<T> {
        event.emitter = this;
        return event;
    }

    public function addListener(event:String, handler:Dynamic, once:Bool = false){
        if(handler == null){
            return;
        }

        if(!once){
            if(!events.exists(event)){
                events[event] = [];
            }

            events[event].push(handler);
        }else{
            if(!eventsOnce.exists(event)){
                eventsOnce[event] = [];
            }

            eventsOnce[event].push(handler);
        }
    }

    public function removeListener(event:String, handler:Dynamic){
        if(handler == null){
            return;
        }

        if(eventsOnce.exists(event)){
            eventsOnce[event].remove(handler);
            if(eventsOnce[event].length == 0){
                eventsOnce.remove(event);
            }
        }

        if(events.exists(event)){
            events[event].remove(handler);
            if(events[event].length == 0){
                events.remove(event);
            }
        }
    }

    public function removeAllListeners(event:String) {
        events.remove(event);
        eventsOnce.remove(event);
    }
}