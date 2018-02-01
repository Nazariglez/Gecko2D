package exp.components;

import exp.macros.IAutoPool;

@:allow(exp.Entity)
class Component implements IAutoPool {
    private var _typ:String = "";
    public var entity:Entity;

    public var id:Int = -1;
    public var name:String = "";
    public var enabled:Bool = true;

    public function new(name:String = "") {
        _typ = Type.getClassName(Type.getClass(this));

        id = EntityManager.getUniqueID();
        this.name = name == "" ? _typ : name;
    }
    public function init(lel:Int = 200, f:String = "lel"){}
    public function reset(){}

    public function destroy(avoidPool:Bool = false) {
        reset();
        if(entity != null){
            entity.removeComponent(Type.getClass(this));
        }
        if(!avoidPool)__toPool__();
    }

    private function __toPool__() {} //macros
}