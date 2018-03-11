package gecko;

import gecko.macros.IAutoPool;

#if !macro
@:autoBuild(gecko.macros.TypeInfoBuilder.buildEntity())
#end
interface IEntity extends IAutoPool {}