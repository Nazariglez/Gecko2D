package exp;

import exp.systems.RenderSystem;
import exp.macros.IAutoPool;
import exp.systems.System;
import exp.components.Component;

#if !macro
@:build(exp.macros.TypeInfoBuilder.buildScene())
@:autoBuild(exp.macros.TypeInfoBuilder.buildScene())
#end
class Scene implements IAutoPool {
    //todo dirty flags to sort entities in update

    static private var _countUniqueID:Int = 0;
    static public function getUniqueID() : Int {
        return _countUniqueID++;
    }

    public var id:Int = Scene.getUniqueID();

    public var name(get, set):String;
    private var _name:String = "";

    //todo loadAssets //unload assetsa automatically in the unload scene

    //todo findEntityByTag
    //todo findEntityByName

    public var entities:Array<Entity> = [];
    public var systems:Array<System> = [];

    private var _updateSystems:Array<System> = [];
    private var _drawSystems:Array<System> = [];

    public function new(){
        addSystem(RenderSystem.create());
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
            removeEntitiy(e);
            e.destroy();
        }
        if(!avoidPool)__toPool__();
    }

    private function __toPool__() {} //macros

    public function addEntity(entity:Entity) {
        entity.manager = this;
        entities.push(entity);
        for(s in systems){
            s._registerEntity(entity);
            entity.onAddedComponent += _onEntityAddComponent;
        }
    }

    public function removeEntitiy(entity:Entity) {
        for(s in systems){
            entity.onAddedComponent -= _onEntityAddComponent;
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

        if(Std.is(system, IDrawable)){
            _drawSystems.push(system);
        }

        if(Std.is(system, IUpdatable)){
            _updateSystems.push(system);
        }

        systems.sort(_sortSystems); //todo parallel threading with same priority?
        _drawSystems.sort(_sortSystems); //todo improve this? dont do three sorts...
        _updateSystems.sort(_sortSystems); //improve this?
    }

    private function _sortSystems(a:System, b:System) {
        if (a.priority < b.priority) return -1;
        if (a.priority > b.priority) return 1;
        return 0;
    }

    public function removeSystem(system:System) {
        systems.remove(system);
        _updateSystems.remove(system);
        _drawSystems.remove(system);
        system._removeAllEntities();
    }

    public function update(delta:Float32) {
        for(sys in _updateSystems){
            sys.update(delta);
        }
    }

    public function draw() {
        for(sys in _drawSystems){
            sys.draw();
        }
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