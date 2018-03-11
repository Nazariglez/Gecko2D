package gecko.utils;

import haxe.macro.Expr;

private typedef Evt<T> = {
    //var once:Map<T, Bool>; //todo once?
    var handlers:Array<T>;
};

abstract Event<T>(Evt<T>) from Evt<T> to Event<T> {
    public var handlers(get, never):Array<T>;
    inline function get_handlers() : Array<T> {
        return this.handlers;
    }

    static inline public function create<T>(){
        return new Event<T>({handlers:new Array<T>()});
    }

    private inline function new(me:Evt<T>) {
        this = me;
    }

    public macro function emit(e1:Expr, extra:Array<Expr>) {
        var e = macro handler($a{extra});
        return macro {
            var handlers = $e1.handlers;
            if(handlers.length != 0){
                for(handler in handlers){
                    $e;
                }
            }
        };
    }

    //todo add a reflection emit to use at runtime

    public function clear() {
        if(this.handlers.length == 0)return;
        this.handlers = []; //todo, remove all events instead create a new array?
    }

    /*public function once(handler:T) {
       //todo
    }*/

    @:op(A += B) inline function on(b:T) {
        this.handlers.push(b);
    }

    @:op(A -= B) inline function off(b:T) {
        this.handlers.remove(b);
    }
}