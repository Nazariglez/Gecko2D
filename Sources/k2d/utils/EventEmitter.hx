package k2d.utils;

typedef EventPointer = {
    var name:String;
    var emitter:EventEmitter;
    var once:Bool;
};

abstract Event(EventPointer) from EventPointer to Event {
    public var name(get, never):String;
    inline function get_name() : String {
        return this.name;
    }

    public var emitter(get, never):EventEmitter;
    inline function get_emitter() : EventEmitter {
        return this.emitter;
    }

    public var once(get, never):Bool;
    inline function get_once() : Bool {
        return this.once;
    }

    @:op(A += B) inline static function addListener(a:Event, b:Dynamic) {
        if(a.once){
            a.emitter.addListenerOnce(a.name, b);
        }else{
            a.emitter.addListener(a.name, b);
        }
    }

    @:op(A -= B) inline static function removeListener(a:Event, b:Dynamic) {
        a.emitter.removeListener(a.name, b);
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

    public function bind(event:String, once:Bool = false) : Event {
        return {
            name:event,
            emitter:this,
            once:once
        };
    }

    public function addListener(event:String, handler:Dynamic){
        if(handler == null){
            return;
        }

        if(!events.exists(event)){
            events[event] = [];
        }

        events[event].push(handler);
    }

    public function addListenerOnce(event:String, handler:Dynamic){
        if(handler == null){
            return;
        }

        if(!eventsOnce.exists(event)){
            eventsOnce[event] = [];
        }

        eventsOnce[event].push(handler);
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