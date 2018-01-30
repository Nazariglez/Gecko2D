package exp.macros;

@:remove @:autoBuild(exp.macros.PoolBuilder.build())
interface IAutoPool {
    private function __toPool__():Void;
}