package exp.systems;

import exp.macros.IAutoPool;
import exp.components.Component;

using Lambda;

@:allow(exp.EntityManager)
class System implements IAutoPool {
    public var id:Int = -1;
    public var name:String = "";

    public var priority:Int = 0;
    public var requiredComponents:Array<Class<Component>> = [];

    private var _entities:Array<Entity> = [];

    public function new(name:String = "") {
        id = EntityManager.getUniqueID();
        this.name = name == "" ? Type.getClassName(Type.getClass(this)) : name;
    }

    public function update(delta:Float32){}
    public function render(r:exp.render.Renderer){}
    public function reset(){}

    public function destroy(avoidPool:Bool = false) {
        reset();
        removeAllEntities();
        if(!avoidPool)__toPool__();
    }

    private function __toPool__(){} //macro

    public inline function getEntities() : Array<Entity> {
        return _entities;
    }

    public inline function getEntitiesWithComponent(componentClass:Class<Component>) : Array<Entity> {
        return _entities.filter(function(e) {
            return e.hasComponent(componentClass);
        }).array();
    }

    //override to check if an entity is valid for your system
    public function isValidEntity(entity:Entity) : Bool {
        for(c in requiredComponents){
            if(!entity.hasComponent(c)){
                return false;
            }
        }

        return true;
    }

    public function removeAllEntities() {
        for(e in _entities){
            _removeEntity(e);
        }
    }

    public inline function hasEntity(entity:Entity) : Bool {
        return _entities.indexOf(entity) != -1;
    }

    private function _registerEntity(entity:Entity) {
        if(isValidEntity(entity)){
            _entities.push(entity);
            entity.onRemoveComponent(_onEntityRemoveComponent);
        }
    }

    private function _onEntityRemoveComponent(entity:Entity, component:Component) {
        //if(componentList.indexOf(Type.getClass(component)) != -1){
        if(!isValidEntity(entity)){
            _removeEntity(entity);
        }
    }

    private function _removeEntity(entity:Entity) {
        entity.offRemoveComponent(_onEntityRemoveComponent);
        _entities.remove(entity);
    }

    private function _removeAllEntities() {
        for(e in _entities){
            _removeEntity(e);
        }
    }
}