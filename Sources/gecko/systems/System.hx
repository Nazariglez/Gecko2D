package gecko.systems;

import gecko.utils.Event;
import gecko.render.Graphics;
import gecko.components.Component;

using Lambda;

@:allow(gecko.Scene)
class System implements ISystem {
    public var id:Int = Gecko.getUniqueID();
    public var enabled:Bool = true;

    public var scene(get, set):Scene;
    private var _scene:Scene = null;

    public var name(get, set):String;
    private var _name:String = "";

    public var priority:Int = 0;
    public var requiredComponents:Array<String> = [];

    private var _entities:Array<Entity> = [];
    private var _dirtySortEntities:Bool = false;

    public var filter:Filter = new Filter();

    public var onEntityAdded:Event<Entity->Void>;
    public var onEntityRemoved:Event<Entity->Void>;
    public var onAddedToScene:Event<Scene->Void>;
    public var onRemovedFromScene:Event<Scene->Void>;

    public function new(){
        onEntityAdded = Event.create();
        onEntityRemoved = Event.create();
        onAddedToScene = Event.create();
        onRemovedFromScene = Event.create();
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
        onAddedToScene.clear();
        onRemovedFromScene.clear();
    }


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

    inline function get_scene():Scene {
        return _scene;
    }

    function set_scene(value:Scene):Scene {
        if(value == _scene)return _scene;

        if(_scene != null){
            onRemovedFromScene.emit(_scene);
        }

        _scene = value;

        if(_scene != null){
            onAddedToScene.emit(_scene);
        }

        return _scene;
    }
}