package gecko.components;

import gecko.macros.IAutoPool;

#if !macro
@:autoBuild(gecko.macros.TypeInfoBuilder.buildComponent())
#end
interface IComponent extends IAutoPool {}