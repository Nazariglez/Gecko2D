package exp;

@:allow(exp.SystemManager)
class System {
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

    private function _registerEntity(entity:Entity) {
        if(_isValidEntity(entity)){
            _entities.push(entity);
        }
    }

    private function _removeEntity(entity:Entity) {
        _entities.remove(entity);
    }

    private function _removeAllEntities() {
        for(e in _entities){
            _removeEntity(e);
        }
    }

    private function _isValidEntity(entity:Entity) : Bool {
        for(c in componentList){
            if(!entity.hasComponent(c)){
                return false;
            }
        }

        return true;
    }
}