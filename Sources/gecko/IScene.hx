package gecko;

import gecko.macros.IAutoPool;

#if !macro
@:autoBuild(gecko.macros.TypeInfoBuilder.buildScene())
#end
interface IScene extends IAutoPool {}