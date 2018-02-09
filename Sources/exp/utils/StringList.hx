package exp.utils;

//https://haxe.org/manual/lf-iterators.html

class StringList<T> {
    private var _map:haxe.ds.StringMap<T> = new haxe.ds.StringMap();
    private var _keys:Array<String> = [];
    private var _toRemove:Array<String> = [];

    public function new(){}

    public inline function set(key:String, value:T) {
        _map.set(key, value);
        _keys.push(key);
    }

    public inline function get(key:String) : T {
        return _map.get(key);
    }

    public inline function exists(key:String) : Bool {
        return _map.exists(key);
    }

    public inline function remove(key:String) {
        _map.remove(key);
        _keys.remove(key);
    }

    public inline function iterator() {
        return _keys.iterator();
    }
}