package exp;

class SystemManager {
    public var entities:Array<Entity> = [];
    public var systems:Array<System> = [];

    public function new(){
        //todo register in system to render or update via events?
    }

    public function addEntity(entity:Entity) {
        entity.engine = this;
        entities.push(entity);
        for(s in systems){
            s._registerEntity(entity);
        }
    }

    public function removeEntitiy(entity:Entity) {
        for(s in systems){
            s._removeEntity(entity);
        }
        entities.remove(entity);
    }

    public function addSystem(system:System, priority:Int = 0) {
        systems.push(system);
        for(e in entities){
            system._registerEntity(e);
        }
    }

    public function removeSystem(system:System) {
        systems.remove(system);
        system._removeAllEntities();
    }

    public function update() {
        for(s in systems){
            s.update();
        }
    }


}