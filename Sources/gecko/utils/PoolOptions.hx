package gecko.utils;

//todo scalesys where:
    //todo {window: {width:X, height:N}, view: {width:X, height:N}}
    //todo and view it's scaled with matrix transform
    //todo see this https://www.youtube.com/watch?v=SE2Ded01lUU

typedef PoolOptions<T> = {
    @:optional var args:Array<Dynamic>;
    @:optional var amount:Int;
    @:optional var init:T->Void;
    @:optional var reset:T->Void;
}