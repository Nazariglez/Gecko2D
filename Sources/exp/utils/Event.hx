package exp.utils;

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
        this.emitter.on(this.name, b, this.once);
    }

    @:op(A -= B) inline function removeListener(b:T) {
        this.emitter.off(this.name, b);
    }
}