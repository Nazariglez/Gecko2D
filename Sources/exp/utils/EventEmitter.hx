package exp.utils;

//todo macro the emit http://www.mromecki.fr/blog/post/signals-haxe-macros-inline-dispatch
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