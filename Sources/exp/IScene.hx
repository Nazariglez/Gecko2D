package exp;

import exp.macros.IAutoPool;

#if !macro
@:autoBuild(exp.macros.TypeInfoBuilder.buildScene())
#end
interface IScene extends IAutoPool {}