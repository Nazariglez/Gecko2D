package gecko.systems;

import gecko.macros.IAutoPool;

#if !macro
@:autoBuild(gecko.macros.TypeInfoBuilder.buildSystem())
#end
interface ISystem extends IAutoPool {}