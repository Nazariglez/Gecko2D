package exp;

@:allow(exp.EntityManager)
class System {
    public var priority:Int = 0;
    public var componentList:Array<Class<Component>> = [];

    private var _entities:Array<Entity> = [];

    public function new(){

    }

    public function update(){
        for(e in _entities){
            updateEntity(e);
        }
    }

    public function updateEntity(entity:Entity) {

    }

    public inline function getEntities() : Array<Entity> {
        return _entities;
    }

    private function _registerEntity(entity:Entity) {
        if(isValidEntity(entity)){
            _entities.push(entity);
            entity.onRemoveComponent(_onEntityRemoveComponent);
        }
    }

    private function _onEntityRemoveComponent(entity:Entity, component:Component) {
        if(componentList.indexOf(Type.getClass(component)) != -1){
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

    public function isValidEntity(entity:Entity) : Bool {
        for(c in componentList){
            if(!entity.hasComponent(c)){
                return false;
            }
        }

        return true;
    }

    public inline function hasEntity(entity:Entity) : Bool {
        return _entities.indexOf(entity) != -1;
    }
}