package gecko.systems;

import gecko.utils.Event;
import gecko.Graphics;
import gecko.components.Component;

using Lambda;

#if !macro
@:autoBuild(gecko.macros.TypeInfoBuilder.buildSystem())
@:build(gecko.macros.TypeInfoBuilder.buildSystem())
#end
@:allow(gecko.Scene)
class System extends BaseObject {
    inline static public function getName(systemClass:Class<System>) : String {
        return _toClass(systemClass).__systemName__;
    }

    inline static private function _toClass(systemClass:Class<System>) : SystemClass {
        return systemClass;
    }

    public var enabled:Bool = true;

    public var scene(get, set):Scene;
    private var _scene:Scene = null;

    public var name(get, set):String;
    private var _name:String = "";

    public var priority:Int = 0;
    public var requiredComponents:Array<String> = [];

    private var _entitiesList:Array<Entity> = [];
    private var _entities:Map<Int, Entity> = new Map();

    public var filter:Filter = new Filter();

    public var onEntityAdded:Event<Entity->Void>;
    public var onEntityRemoved:Event<Entity->Void>;
    public var onAddedToScene:Event<Scene->Void>;
    public var onRemovedFromScene:Event<Scene->Void>;

    public function new(){
        super();

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

    override public function beforeDestroy(){
        super.beforeDestroy();

        removeAllEntities();
        scene = null;
        filter.clear();
        onEntityAdded.clear();
        onEntityRemoved.clear();
        onAddedToScene.clear();
        onRemovedFromScene.clear();
    }

    inline public function eachEntity(handler:Entity->Void) {
        for(e in getEntities()){
            if(!e.enabled)continue;

            handler(e);
        }
    }

    public inline function getEntities() : Array<Entity> {
        return _entitiesList;
    }

    public inline function getEntitiesWithComponent(componentClass:Class<Component>) : Array<Entity> {
        return _entitiesList.filter(function(e) {
            return e.hasComponent(componentClass);
        }).array();
    }

    //override to check if an entity is valid for your system
    public function isValidEntity(entity:Entity) : Bool {
        return filter.testEntity(entity);
    }

    public function removeAllEntities() {
        for(e in _entitiesList){
            _removeEntity(e);
        }
    }

    public inline function hasEntity(entity:Entity) : Bool {
        #if js
        return untyped _entities.h.hasOwnProperty(entity.id);
        #else
        return _entities.exists(entity.id); //_entitiesList.indexOf(entity) != -1;
        #end

    }

    private function _registerEntity(entity:Entity) {
        if(isValidEntity(entity)){
            _entitiesList.push(entity);
            _entities.set(entity.id, entity);
            entity.onComponentRemoved += _onEntityRemoveComponent;

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
        _entitiesList.remove(entity);
        _entities.remove(entity.id);

        onEntityRemoved.emit(entity);
    }

    private function _removeAllEntities() {
        for(e in _entitiesList){
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

private abstract SystemClass({private var __systemName__:String;}) {
    public var __systemName__(get, never):String;
    public inline function get___systemName__() {
        return this.__systemName__;
    }

    @:from static public function fromSystem(c:Class<System>) {
        return cast c;
    }
}