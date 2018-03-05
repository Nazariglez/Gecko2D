package exp;

import exp.components.core.TransformComponent;
import exp.components.draw.DrawComponent;
import exp.utils.Event;
import exp.components.Component;
import exp.components.ComponentClass;

//todo toString for debug
//todo serialize && unserialize to save and load from text

@:poolAmount(100)
class Entity implements IEntity {
    public var id:Int = Gecko.getUniqueID();

    public var isRoot(get, never):Bool;
    private var _isRoot:Bool = false;

    public var enabled:Bool = true;

    public var name(get, set):String;
    private var _name:String = "";

    public var scene(get, set):Scene;
    private var _scene:Scene;

    public var depth(get, set):Int;
    private var _depth:Int = 0;

    private var _tags:Map<String, Bool> = new Map<String, Bool>();

    public var transform:TransformComponent = null; //add a transformComponent always by default?
    public var renderer:DrawComponent = null;

    private var _components:Map<String,Component> = new Map();
    private var _componentsList:Array<Component> = [];

    public var onComponentAdded:Event<Entity->Component->Void>;
    public var onComponentRemoved:Event<Entity->Component->Void>;
    public var onAddedToScene:Event<Entity->Scene->Void>;
    public var onRemovedFromScene:Event<Entity->Scene->Void>;
    public var onDepthChanged:Event<Entity->Void>;

    public function new() {
        onComponentAdded = Event.create();
        onComponentRemoved = Event.create();
        onAddedToScene = Event.create();
        onRemovedFromScene = Event.create();
        onDepthChanged = Event.create();
    }

    public function init(name:String = ""){
        _name = name;
    }

    public function beforeDestroy(){
        if(scene != null){
            scene.removeEntity(this);
        }

        for(name in _components.keys()){
            var component = _components.get(name);
            _components.remove(name);

            if(component == transform){
                transform = null;
            }else if(component == renderer){
                renderer = null;
            }

            onComponentRemoved.emit(this, component);
            component.destroy();
        }

        for(tag in _tags.keys()){
            _tags.remove(tag);
        }

        onComponentAdded.clear();
        onComponentRemoved.clear();
        onAddedToScene.clear();
        onRemovedFromScene.clear();
        onDepthChanged.clear();
    }


    public inline function addTag(tag:String) {
        _tags.set(tag, true);
    }

    public inline function removeTag(tag:String) {
        _tags.remove(tag);
    }

    public inline function hasTag(tag:String) : Bool {
        return _tags.exists(tag);
    }

    public function removeAllTags() {
        for(t in _tags.keys()){
            _tags.remove(t);
        }
    }

    public function addComponent<T:Component>(component:T) : T {
        component.entity = this;

        if(Std.is(component, DrawComponent)){
            if(renderer != null){
                removeComponent(renderer.__type__);
            }
            renderer = cast component;
        }

        if(component.__type__ == TransformComponent){
            if(transform != null){
                removeComponent(transform.__type__);
            }
            transform = cast component;
        }

        _components.set(component.__typeName__, component);
        _componentsList.push(component);

        onComponentAdded.emit(this, component);

        return cast component;
    }

    public function removeComponent<T:Component>(componentClass:ComponentClass) : T {
        var c:T = cast _components.get(componentClass.__componentName__);
        if(c != null){
            c.entity = null;
            _components.remove(name);
            _componentsList.remove(c);
            onComponentRemoved.emit(this, c);

            if(transform != null && c.__type__ == transform.__type__){
                transform = null;
            }else if(renderer != null && c.__type__ == renderer.__type__){
                renderer = null;
            }

            return c;
        }
        return null;
    }

    public function removeAllComponents() {
        for(c in _components){
            removeComponent(c.__type__);
        }
    }

    public inline function getAllComponents() : Array<Component> {
        return _componentsList;
    }

    public inline function getComponent<T:Component>(componentClass:ComponentClass) : T {
        return cast _components[componentClass.__componentName__];
    }

    public inline function hasComponent(name:String) : Bool {
        return _components.exists(name);
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

        var s = _scene;
        _scene = value;

        if(s != null){
            onRemovedFromScene.emit(this, s);
        }

        if(_scene != null){
            onAddedToScene.emit(this, _scene);
        }

        return _scene;
    }

    inline function get_depth():Int {
        return _depth;
    }

    function set_depth(value:Int):Int {
        if(value == _depth)return _depth;
        _depth = value;
        onDepthChanged.emit(this);
        return _depth;
    }

    inline function get_isRoot():Bool {
        return _isRoot;
    }
}