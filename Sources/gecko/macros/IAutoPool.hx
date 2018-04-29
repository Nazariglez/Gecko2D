package gecko.macros;

@:remove @:autoBuild(gecko.macros.PoolBuilder.build())
interface IAutoPool {
    public function beforeDestroy():Void;
}