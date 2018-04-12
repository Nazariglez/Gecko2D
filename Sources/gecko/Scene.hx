package gecko;

import gecko.math.Point;
import gecko.tween.TweenManager;
import gecko.timer.TimerManager;
import gecko.components.draw.DrawComponent;
import gecko.utils.Event;
import gecko.systems.draw.DrawSystem;
import gecko.systems.System;
import gecko.components.Component;

using gecko.utils.ArrayHelper;

#if !macro
@:autoBuild(gecko.macros.TypeInfoBuilder.buildScene())
@:build(gecko.macros.TypeInfoBuilder.buildScene())
#end
class Scene extends BaseObject {
    public var name(get, set):String;
    private var _name:String = "";

    public var rootEntity(default, null):Entity;

    public var cameras:Array<Camera> = [];
    private var _camerasToAdd:Array<Camera> = [];
    private var _camerasToRemove:Array<Camera> = [];

    private var _dirtySortSystems:Bool = false;
    private var _isProcessing:Bool = false;

    //todo loadAssets //unload assets automatically in the unload scene

    //todo findEntityByTag
    //todo findEntityByName

    public var entities:Array<Entity> = [];
    private var _entitesMap:Map<Int, Entity> = new Map();

    private var _systems:Map<String, System> = new Map();
    private var _drawableSystems:Array<System> = [];
    private var _updatableSystems:Array<System> = [];
    private var _systemsList:Array<System> = [];

    public var onEntityAdded:Event<Entity->Void> = Event.create();
    public var onEntityRemoved:Event<Entity->Void> = Event.create();

    public var onSystemAdded:Event<System->Void> = Event.create();
    public var onSystemRemoved:Event<System->Void> = Event.create();

    public var onCameraAdded:Event<Camera->Void> = Event.create();
    public var onCameraRemoved:Event<Camera->Void> = Event.create();

    private var _systemsToAdd:Array<System> = [];
    private var _systemsToRemove:Array<System> = [];
    private var _entitiesToAdd:Array<Entity> = [];
    private var _entitiesToRemove:Array<Entity> = [];

    private var _cameraRendering:Int = -1;
    public var currentCameraRendering(default, null):Camera = null;

    //todo _entitiesByComponents:Map<ComponentClass, Array<Entity>> and populate with entitis with X components

    private var _dirtyProcess:Bool = false;

    public var timerManager:TimerManager;
    public var tweenManager:TweenManager;

    static public function createWithDrawSystem(?priority:Int) : Scene {
        var s = Scene.create();
        var sys:DrawSystem = DrawSystem.create();
        if(priority != null){
            sys.priority = priority;
        }
        s.addSystem(sys);
        return s;
    }

    public function new(){
        super();

        timerManager = TimerManager.create();
        tweenManager = TweenManager.create();

        rootEntity = Entity.create();
        rootEntity.name = "scene-root-entity";
        rootEntity.addComponent(DrawComponent.create());
        @:privateAccess rootEntity._isRoot = true;
    }

    override public function beforeDestroy(){
        super.beforeDestroy();

        while(_systemsList.length > 0){
            var sys = _systemsList[0];
            _removeSystem(sys);
            sys.destroy();
        }

        while(entities.length > 0){
            var e = entities[0];
            _removeEntity(e);
            e.destroy();
        }

        while(cameras.length > 0){
            var c = cameras[0];
            _removeCamera(c);
            c.destroy();
        }

        timerManager.cleanTimers();
        tweenManager.cleanTweens();

        onEntityAdded.clear();
        onEntityRemoved.clear();

        onSystemAdded.clear();
        onSystemRemoved.clear();

        onCameraAdded.clear();
        onCameraRemoved.clear();

        @:privateAccess rootEntity.transform._reset();
    }

    inline public function getEntityById(id:Int) : Entity {
        return _entitesMap.get(id);
    }

    public function createCamera(x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0) : Camera {
        return addCamera(Camera.create(x,y,width,height));
    }

    public function createEntity() : Entity {
        return addEntity(Entity.create());
    }

    public function addEntity<T:Entity>(entity:T) : T {
        if(getEntityById(entity.id) != null)return entity;

        if(_isProcessing){
            _entitiesToAdd.push(entity);
            _dirtyProcess = true;
            return entity;
        }

        _addEntity(entity);
        return entity;
    }

    private function _addEntity(entity:Entity) {
        entity.scene = this;

        if(entity.transform != null && entity.transform.parent == null){
            entity.transform.parent = rootEntity.transform;
        }

        entities.push(entity);
        _entitesMap.set(entity.id, entity);

        for(s in _systemsList){
            s._registerEntity(entity);
            entity.onComponentAdded += _onEntityAddComponent;
        }

        onEntityAdded.emit(entity);
    }

    public function removeEntity(entity:Entity) {
        if(getEntityById(entity.id) == null)return;

        if(_isProcessing){
            _entitiesToRemove.push(entity);
            _dirtyProcess = true;
            return;
        }

        _removeEntity(entity);
    }

    private function _removeEntity(entity:Entity) {
        for(s in _systemsList){
            entity.onComponentAdded -= _onEntityAddComponent;
            entity.scene = null;

            if(rootEntity != null && entity.transform.parent == rootEntity.transform){
                entity.transform.parent = null;
            }

            s._removeEntity(entity);
        }

        entities.remove(entity);
        _entitesMap.remove(entity.id);
        onEntityRemoved.emit(entity);
    }

    public function addCamera(camera:Camera) : Camera {
        if(cameras.has(camera))return camera;

        if(_isProcessing){
            _camerasToAdd.push(camera);
            _dirtyProcess = true;
            return camera;
        }

        _addCamera(camera);
        return camera;
    }

    private function _addCamera(camera:Camera) {
        camera.scene = this;
        cameras.push(camera);
        onCameraAdded.emit(camera);
    }

    public function removeCamera(camera:Camera) {
        if(cameras.has(camera))return;

        if(_isProcessing){
            _camerasToRemove.push(camera);
            _dirtyProcess = true;
            return;
        }

        _removeCamera(camera);
    }

    private function _removeCamera(camera:Camera) {
        camera.scene = null;
        cameras.remove(camera);
        onCameraRemoved.emit(camera);
    }

    public function addSystem<T:System>(system:T) : T {
        if(getSystem(system.__type__) != null)return system;

        if(_isProcessing){
            _systemsToAdd.push(system);
            _dirtyProcess = true;
            return system;
        }

        _addSystem(system);
        return system;
    }

    private function _addSystem<T:System>(system:T) : T {
        system.scene = this;
        _systems.set(system.__typeName__, system);
        _systemsList.push(system);
        for(e in entities){
            system._registerEntity(e);
        }

        if(Std.is(system, IDrawable)){
            _drawableSystems.push(system);
        }

        if(Std.is(system, IUpdatable)){
            _updatableSystems.push(system);
        }

        _dirtySortSystems = true;
        onSystemAdded.emit(system);

        return system;
    }

    inline public function getSystem<T:System>(systemClass:Class<System>) : T {
        return cast _systems.get(System.getName(systemClass));
    }

    private function _sortSystems(a:System, b:System) {
        if (a.priority < b.priority) return -1;
        if (a.priority > b.priority) return 1;
        return 0;
    }

    public function removeSystem(systemClass:Class<System>) {
        var sys = _systems.get(System.getName(systemClass));
        if(sys != null){
            if(_isProcessing){
                _systemsToRemove.push(sys);
                _dirtyProcess = true;
                return;
            }

            _removeSystem(sys);
        }
    }

    private function _removeSystem(system:System) {
        system.scene = null;
        _systems.remove(system.__typeName__);
        _systemsList.remove(system);

        _drawableSystems.remove(system);
        _updatableSystems.remove(system);

        system._removeAllEntities();

        onSystemRemoved.emit(system);
    }

    public function process(delta:Float32) {
        _isProcessing = true;
        if(_dirtySortSystems){
            _systemsList.sort(_sortSystems);
            _drawableSystems.sort(_sortSystems);
            _updatableSystems.sort(_sortSystems);
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

            while(_camerasToAdd.length != 0){
                _addCamera(_camerasToAdd.pop());
            }

            while(_camerasToRemove.length != 0){
                _removeCamera(_camerasToRemove.pop());
            }

            _dirtyProcess = false;
        }

        _isProcessing = false;
    }

    public function update(delta:Float32) {
        timerManager.tick(delta);
        tweenManager.tick(delta);

        if(cameras.length > 0){
            for(_camera in cameras){
                _camera.update(delta);
            }
        }

        for(sys in _updatableSystems){
            if(sys.enabled){
                sys.update(delta);
            }
        }
    }

    public function updateCameraTransform(camera:Camera) {
        if(_cameraRendering != camera.id || camera.wasChanged){

            //update only if the camera transform or the camera id changes
            //(if only exists one camera and not change ther matrix it's not neccesary update every frame)
            rootEntity.transform.worldMatrix.setFrom(camera.matrix);
            for(i in 0...rootEntity.transform.getChildrenLength()){
                @:privateAccess rootEntity.transform.getChild(i)._setDirty(true, true, true);
            }

            camera.wasChanged = false;
            _cameraRendering = camera.id;
        }
    }

    public function getCameraFocused(p:Point) : Camera {
        var camera = null;

        if(cameras.length > 0){
            for(i in 0...cameras.length) {
                if(cameras[i].containsScreenPoint(p)){
                    camera = cameras[i];
                    break;
                }
            }
        }

        return camera;
    }

    public function draw(g:Graphics) {
        _isProcessing = true;
        currentCameraRendering = null;

        if(cameras.length > 0){

            //store the currentBuffer
            g.end();
            var prevBuffer = g.buffer;

            for(_camera in cameras){
                currentCameraRendering = _camera;
                //update the matrix of the entities to draw
                updateCameraTransform(_camera);

                //draw to the camera buffer
                g.setRenderTarget(_camera.buffer);

                if(_camera.bgColor != null){
                    g.begin(true, _camera.bgColor);
                }else{
                    g.begin();
                }

                for(sys in _drawableSystems){
                    if(sys.enabled){
                        sys.draw(g);
                    }
                }

                g.end();
            }

            //recover the previous buffer and draw the camera buffers on it
            g.setRenderTarget(prevBuffer);
            g.begin();

            for(_camera in cameras){
                _camera.preDraw(g);
                g.drawImage(_camera.buffer, _camera.x, _camera.y);
                _camera.postDraw(g);
            }

        }else{
            for(sys in _drawableSystems){
                if(sys.enabled){
                    sys.draw(g);
                }
            }
        }
        _isProcessing = false;
    }

    private function _onEntityAddComponent(entity:Entity, component:Component) {
        for(s in _systemsList){
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