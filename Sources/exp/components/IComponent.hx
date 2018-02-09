package exp.components;

import exp.macros.IAutoPool;

#if !macro
@:autoBuild(exp.macros.TypeInfoBuilder.buildComponent())
#end
interface IComponent extends IAutoPool {}