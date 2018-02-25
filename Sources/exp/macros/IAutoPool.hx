package exp.macros;

@:remove @:autoBuild(exp.macros.PoolBuilder.build())
interface IAutoPool {
    public function destroy():Void;
    public function beforeDestroy():Void;
}