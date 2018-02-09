package exp;

import exp.utils.Event;
import exp.systems.DrawSystem;
import exp.macros.IAutoPool;
import exp.systems.System;
import exp.components.Component;

#if !macro
@:build(exp.macros.TypeInfoBuilder.buildScene())
@:autoBuild(exp.macros.TypeInfoBuilder.buildScene())
#end
class Scene implements IAutoPool {
    public var id:Int = Gecko.getUniqueID();

    public var name(get, set):String;
    private var _name:String = "";

    private var _dirtySortSystems:Bool = false;
    private var _isProcessing:Bool = false;

    //todo loadAssets //unload assets automatically in the unload scene

    //todo findEntityByTag
    //todo findEntityByName

    public var entities:Array<Entity> = [];
    public var systems:Array<System> = [];

    public var onEntityAdded:Event<Entity->Void> = Event.create();
    public var onEntityRemoved:Event<Entity->Void> = Event.create();

    public var onSystemAdded:Event<System->Void> = Event.create();
    public var onSystemRemoved:Event<System->Void> = Event.create();

    private var _systemsToAdd:Array<System> = [];
    private var _systemsToRemove:Array<System> = [];
    private var _entitiesToAdd:Array<Entity> = [];
    private var _entitiesToRemove:Array<Entity> = [];

    private var _dirtyProcess:Bool = false;

    public function new(){
        addSystem(DrawSystem.create());
    }

    public function init(name:String = ""){
        _name = name;
    }
    public function reset(){}

    public function destroy(avoidPool:Bool = false){
        reset();
        for(sys in systems){
            removeSystem(sys);
            sys.destroy();
        }
        for(e in entities){
            removeEntity(e);
            e.destroy();
        }
        if(!avoidPool)__toPool__();
    }

    private function __toPool__() {} //macros

    public function addEntity(entity:Entity) {
        if(_isProcessing){
            _entitiesToAdd.push(entity);
            _dirtyProcess = true;
            return;
        }

        _addEntity(entity);
    }

    private function _addEntity(entity:Entity) {
        entity.scene = this;
        entities.push(entity);
        for(s in systems){
            s._registerEntity(entity);
            entity.onComponentAdded += _onEntityAddComponent;
        }
        //onEntityAdded.emit(entity);
    }

    public function removeEntity(entity:Entity) {
        if(_isProcessing){
            _entitiesToRemove.push(entity);
            _dirtyProcess = true;
            return;
        }

        _removeEntity(entity);
    }

    private function _removeEntity(entity:Entity) {
        for(s in systems){
            entity.onComponentAdded -= _onEntityAddComponent;
            entity.scene = null;
            s._removeEntity(entity);
        }
        entities.remove(entity);
        //onEntityRemoved.emit(entity);
    }

    @:allow(exp.systems.System)
    public function depthChanged(entity:Entity) {
        for(sys in systems){
            sys._dirtySortEntities = true;
        }
    }

    public function addSystem(system:System) {
        if(_isProcessing){
            _systemsToAdd.push(system);
            _dirtyProcess = true;
            return;
        }

        _addSystem(system);
    }

    private function _addSystem(system:System) {
        systems.push(system);
        for(e in entities){
            system._registerEntity(e);
        }

        _dirtySortSystems = true;
        //onSystemAdded.emit(system);
    }

    private function _sortSystems(a:System, b:System) {
        if (a.priority < b.priority) return -1;
        if (a.priority > b.priority) return 1;
        return 0;
    }

    public function removeSystem(system:System) {
        if(_isProcessing){
            _systemsToRemove.push(system);
            _dirtyProcess = true;
            return;
        }

        _removeSystem(system);
    }

    private function _removeSystem(system:System) {
        systems.remove(system);
        system._removeAllEntities();

        //onSystemRemoved.emit(system);
    }

    public function process(delta:Float32) {
        _isProcessing = true;
        if(_dirtySortSystems){
            systems.sort(_sortSystems);
            _dirtySortSystems = false;
        }

        update(delta);

        if(_dirtyProcess){
            while(_entitiesToAdd.length != 0){
                _addEntity(_entitiesToAdd.pop());
            }

            while(_entitiesToRemove.length != 0){
                _removeEntity(_entitiesToRemove.pop());
            }

            while(_systemsToAdd.length != 0){
                _addSystem(_systemsToAdd.pop());
            }

            while(_systemsToRemove.length != 0){
                _removeSystem(_systemsToRemove.pop());
            }

            _dirtyProcess = false;
        }

        _isProcessing = false;
    }

    public function update(delta:Float32) {
        for(sys in systems){
            if(!sys.disableUpdate){
                sys.update(delta);
            }
        }
    }

    public function draw() {
        _isProcessing = true;
        for(sys in systems){
            if(!sys.disableDraw){
                sys.draw();
            }
        }
        _isProcessing = false;
    }

    private function _onEntityAddComponent(entity:Entity, component:Component) {
        for(s in systems){
            if(!s.hasEntity(entity)){
                s._registerEntity(entity);
            }
        }
    }

    inline function get_name():String {
        return _name == "" ? __typeName__ : _name;
    }

    inline function set_name(value:String):String {
        return this._name = value;
    }

}