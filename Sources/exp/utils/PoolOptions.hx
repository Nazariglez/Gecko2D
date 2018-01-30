package exp.utils;

typedef PoolOptions<T> = {
    @:optional var args:Array<Dynamic>;
    @:optional var amount:Int;
    @:optional var init:T->Void;
    @:optional var reset:T->Void;
}