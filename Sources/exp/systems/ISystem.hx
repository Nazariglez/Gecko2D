package exp.systems;

import exp.macros.IAutoPool;

#if !macro
@:autoBuild(exp.macros.TypeInfoBuilder.buildSystem())
#end
interface ISystem extends IAutoPool {}