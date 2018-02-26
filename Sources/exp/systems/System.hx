package exp.systems;

import exp.utils.Event;
import exp.render.Graphics;
import exp.components.Component;

using Lambda;

@:allow(exp.Scene)
class System implements ISystem {
    public var id:Int = Gecko.getUniqueID();
    public var scene:Scene;
    public var enabled:Bool = true;

    public var name(get, set):String;
    private var _name:String = "";

    public var priority:Int = 0;
    public var requiredComponents:Array<String> = [];

    private var _entities:Array<Entity> = [];
    private var _dirtySortEntities:Bool = false;

    public var filter:Filter = new Filter();

    public var onEntityAdded:Event<Entity->Void>;
    public var onEntityRemoved:Event<Entity->Void>;

    public function new(){
        onEntityAdded = Event.create();
        onEntityRemoved = Event.create();
    }

    public function process(delta:Float32){
        update(delta);
    }

    public function update(delta:Float32){}
    public function draw(graphics:Graphics){}

    public function beforeDestroy(){
        removeAllEntities();
        scene = null;
        filter.clear();
        onEntityAdded.clear();
        onEntityRemoved.clear();
    }

    public function destroy() {}

    public inline function getEntities() : Array<Entity> {
        return _entities;
    }

    public inline function getEntitiesWithComponent(componentClass:String) : Array<Entity> {
        return _entities.filter(function(e) {
            return e.hasComponent(componentClass);
        }).array();
    }

    //override to check if an entity is valid for your system
    public function isValidEntity(entity:Entity) : Bool {
        return filter.testEntity(entity);
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
            entity.onComponentRemoved += _onEntityRemoveComponent;
            _dirtySortEntities = true;

            onEntityAdded.emit(entity);
        }
    }

    private function _onEntityRemoveComponent(entity:Entity, component:Component) {
        //if(componentList.indexOf(Type.getClass(component)) != -1){
        if(!isValidEntity(entity)){
            _removeEntity(entity);
        }
    }

    private function _removeEntity(entity:Entity) {
        entity.onComponentRemoved -= _onEntityRemoveComponent;
        _entities.remove(entity);

        onEntityRemoved.emit(entity);
    }

    private function _removeAllEntities() {
        for(e in _entities){
            _removeEntity(e);
        }
    }

    inline function get_name():String {
        return _name == "" ? __typeName__ : _name;
    }

    inline function set_name(value:String):String {
        return this._name = value;
    }
}