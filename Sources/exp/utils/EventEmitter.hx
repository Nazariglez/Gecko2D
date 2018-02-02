package exp.utils;

import haxe.macro.Expr;
import haxe.macro.Context;

class EventEmitter {
    public var eventsOnce:Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();
    public var events:Map<String, Array<Dynamic>> = new Map<String, Array<Dynamic>>();
    
    public function new(){}

    public macro function emit(e1:Expr, extra:Array<Expr>) {
        var eventName = extra.shift();
        var e = macro evt($a{extra});
        return macro {
            if($e1.eventsOnce.exists($eventName)){
                for(evt in $e1.eventsOnce[$eventName]){
                    $e;
                }
            }

            if($e1.events.exists($eventName)){
                for(evt in $e1.events[$eventName]){
                    $e;
                }
            }
        };
    }

    public function emitReflect(event:String, args: Dynamic = null){
        if(eventsOnce.exists(event)){
            for(evt in eventsOnce[event]){
                Reflect.callMethod(null, evt, args);
                off(event, evt);
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

    public function on(event:String, handler:Dynamic, once:Bool = false){
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

    public function off(event:String, handler:Dynamic){
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