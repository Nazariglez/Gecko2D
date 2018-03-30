package gecko.utils;

class ArrayHelper {
    inline static public function clear<T>(arr:Array<T>) {
        #if js
        untyped __js__('{0}.length = 0', arr);
        #else
        arr.splice(0, arr.length);
        #end
    }

    inline static public function has<T>(arr:Array<T>, obj:T) : Bool {
        return arr.indexOf(obj) != -1;
    }
}