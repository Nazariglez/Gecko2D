package exp.macros;

@:remove @:autoBuild(exp.macros.PoolBuilder.build())
interface IAutoPool {
    public function beforeDestroy():Void;
}