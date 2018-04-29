package gecko;

import gecko.macros.IAutoPool;

class BaseObject implements IAutoPool {
    public var id(default, null):Int = Gecko.getUniqueID();
    public function new(){}
    public function beforeDestroy(){}
}