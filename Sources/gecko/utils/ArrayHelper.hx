package gecko.utils;

class ArrayHelper {
    static public function clear<T>(arr:Array<T>) {
        #if js
        untyped __js__('{0}.length = 0', arr);
        #else
        arr.splice(0, arr.length);
        #end
    }
}