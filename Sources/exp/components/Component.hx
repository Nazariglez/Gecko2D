package exp.components;

import exp.macros.IAutoPool;

@:allow(exp.Entity)
@:build(exp.macros.TypeInfoBuilder.buildComponent())
@:autoBuild(exp.macros.TypeInfoBuilder.buildComponent())
class Component implements IAutoPool {
    public var entity:Entity;

    public var id:Int = Scene.getUniqueID();
    public var enabled:Bool = true;

    public var name(get, set):String;
    private var _name:String = "";

    public function new(){}

    public function init(name:String = "") {
        _name = name;
    }
    public function reset(){}

    public function destroy(avoidPool:Bool = false) {
        reset();
        if(entity != null){
            entity.removeComponent(__type__);
        }
        if(!avoidPool)__toPool__();
    }

    private function __toPool__() {} //macros

    inline function get_name():String {
        return _name == "" ? __typeName__ : _name;
    }

    inline function set_name(value:String):String {
        return this._name = value;
    }
}