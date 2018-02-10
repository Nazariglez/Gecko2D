package exp;

import exp.macros.IAutoPool;

#if !macro
@:autoBuild(exp.macros.TypeInfoBuilder.buildEntity())
#end
interface IEntity extends IAutoPool {}