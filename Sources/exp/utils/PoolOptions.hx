package exp.utils;

typedef PoolOptions<T> = {
    @:optional var args:Array<Dynamic>;
    @:optional var num:Int;
    @:optional var init:T->Void;
    @:optional var reset:T->Void;
}