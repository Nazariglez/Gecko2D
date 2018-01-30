package exp;

import exp.systems.System;
import exp.components.Component;

class EntityManager {
    static private var _countUniqueID:Int = 0;
    static public function getUniqueID() : Int {
        return _countUniqueID++;
    }

    public var id:Int = -1;
    public var name:String = "";

    public var entities:Array<Entity> = [];
    public var systems:Array<System> = [];

    public function new(name:String = ""){
        id = EntityManager.getUniqueID();
        this.name = name == "" ? Type.getClassName(Type.getClass(this)) : name;
    }

    public function addEntity(entity:Entity) {
        entity.manager = this;
        entities.push(entity);
        for(s in systems){
            s._registerEntity(entity);
            entity.onAddComponent(_onEntityAddComponent);
        }
    }

    public function removeEntitiy(entity:Entity) {
        for(s in systems){
            entity.offAddComponent(_onEntityAddComponent);
            entity.manager = null;
            s._removeEntity(entity);
        }
        entities.remove(entity);
    }


    public function addSystem(system:System) {
        systems.push(system);
        for(e in entities){
            system._registerEntity(e);
        }
        systems.sort(_sortSystems); //todo parallel threading with same priority?
    }

    private function _sortSystems(a:System, b:System) {
        if (a.priority < b.priority) return -1;
        if (a.priority > b.priority) return 1;
        return 0;
    }

    public function removeSystem(system:System) {
        systems.remove(system);
        system._removeAllEntities();
    }

    public function update(delta:Float32) {
        for(s in systems){
            s.update(delta);
        }
    }

    public function render(r:exp.render.Renderer) {
        for(s in systems){
            s.render(r);
        }
    }

    private function _onEntityAddComponent(entity:Entity, component:Component) {
        for(s in systems){
            if(!s.hasEntity(entity)){
                s._registerEntity(entity);
            }
        }
    }

}