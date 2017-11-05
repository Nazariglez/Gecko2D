package k2d.utils;

class EventEmitter {
    public var events:Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();
    
    public function new(){}

    public function emit(event:String, args: Dynamic){
        if(events.exists(event)){
            for(evt in events[event]){
                Reflect.callMethod(null, evt, args);
            }
        }
    }

    public function on(event:String, handler:Dynamic){
        if(handler == null){
            return;
        }

        if(!events.exists(event)){
            events[event] = [];
        }

        events[event].push(handler);
    }

    public function off(event:String, handler:Dynamic){
        if(handler == null){
            return;
        }

        if(events.exists(event)){
            events[event].remove(handler);
            if(events[event].length == 0){
                events.remove(event);
            }
        }
    }

    public function offAll(event:String) {
        events.remove(event);
    }
}