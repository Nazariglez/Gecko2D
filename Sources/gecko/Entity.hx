package gecko;

import gecko.BaseObject;
import gecko.components.draw.DrawComponent;
import gecko.utils.Event;
import gecko.components.Component;

using Lambda;

//todo toString for debug
//todo serialize && unserialize to save and load from text

#if !macro
@:autoBuild(gecko.macros.TypeInfoBuilder.buildEntity())
@:build(gecko.macros.TypeInfoBuilder.buildEntity())
#end
class Entity extends BaseObject {
    public var isRoot(get, never):Bool;
    private var _isRoot:Bool = false;

    public var enabled:Bool = true;

    public var name(get, set):String;
    private var _name:String = "";

    public var scene(get, set):Scene;
    private var _scene:Scene;

    private var _tags:Map<String, Bool> = new Map<String, Bool>();

    public var transform:Transform;
    private var _renderer:DrawComponent = null;

    private var _components:Map<String,Component> = new Map();
    private var _componentsList:Array<Component> = [];
    private var _componentTypes:Map<String, Array<Component>> = new Map();

    public var onComponentAdded:Event<Entity->Component->Void>;
    public var onComponentRemoved:Event<Entity->Component->Void>;
    public var onAddedToScene:Event<Entity->Scene->Void>;
    public var onRemovedFromScene:Event<Entity->Scene->Void>;

    public function new() {
        super();

        transform = new Transform(this);

        onComponentAdded = Event.create();
        onComponentRemoved = Event.create();
        onAddedToScene = Event.create();
        onRemovedFromScene = Event.create();
    }

    override public function beforeDestroy(){
        super.beforeDestroy();

        if(scene != null){
            scene.removeEntity(this);
        }

        transform._reset();

        for(name in _components.keys()){
            var component = _components.get(name);
            _removeComponent(component, true);
            //component.destroy();
        }

        for(tag in _tags.keys()){
            _tags.remove(tag);
        }

        _isRoot = false;

        onComponentAdded.clear();
        onComponentRemoved.clear();
        onAddedToScene.clear();
        onRemovedFromScene.clear();
    }

    inline public function getDrawComponent() : DrawComponent {
        return _renderer;
    }

    inline public function hasDrawComponent() : Bool {
        return _renderer != null;
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

    inline public function hasComponentOfType(componentClass:Class<Component>) : Bool {
        return _componentTypes.exists(Component.getName(componentClass));
    }

    inline public function getComponentsOfType<T:Component>(componentClass:Class<Component>) : Array<T> {
        return cast _componentTypes.get(Component.getName(componentClass));
    }

    public function addComponent<T:Component>(component:T) : T {
        component.entity = this;

        if(Std.is(component, DrawComponent)){
            if(_renderer != null){
                removeComponent(_renderer.__type__);
            }
            _renderer = cast component;
        }

        _components.set(component.__typeName__, component);
        _componentsList.push(component);

        var types = Component.getBaseTypes(component.__type__);
        if(types.length != 0){
            for(t in types){
                if(!_componentTypes.exists(t)){
                    _componentTypes.set(t, [component]);
                }else{
                    var arr = _componentTypes.get(t);
                    arr.push(component);
                }
            }
        }

        onComponentAdded.emit(this, component);

        return cast component;
    }

    public function removeComponent<T:Component>(componentClass:Class<Component>, destroy:Bool = false) : T {
        var c:T = cast _components.get(Component.getName(componentClass));
        if(c != null){
            _removeComponent(c, destroy);
            return destroy ? null : c;
        }
        return null;
    }

    private function _removeComponent(c:Component, destroy:Bool = false){
        _components.remove(c.__typeName__);
        _componentsList.remove(c);

        if(_renderer != null && c.__type__ == _renderer.__type__){
            _renderer = null;
        }

        var types = Component.getBaseTypes(c.__type__);
        if(types.length != 0){
            for(t in types){
                var arr = _componentTypes.get(t);
                arr.remove(c);

                if(arr.length == 0){
                    _componentTypes.remove(t);
                }
            }
        }

        c.entity = null;
        onComponentRemoved.emit(this, c);

        if(destroy){
            c.destroy();
        }
    }

    public function removeAllComponents(destroy:Bool = false) {
        for(c in _components){
            removeComponent(c.__type__, destroy);
        }
    }

    public inline function getAllComponents() : Array<Component> {
        return _componentsList;
    }

    public inline function getComponent<T:Component>(componentClass:Class<Component>) : T {
        #if js
        return cast untyped _components.h[Component.getName(componentClass)];
        #else
        return cast _components[Component.getName(componentClass)];
        #end
    }

    public inline function hasComponent(componentClass:Class<Component>) : Bool {
        #if js
        return untyped _components.h.hasOwnProperty(Component.getName(componentClass));
        #else
        return _components.exists(Component.getName(componentClass));
        #end
    }

    inline public function toString() : String {
        return 'Entity: id -> ${id}, components -> ${_componentsList.map(function(c){ return c.name; })}';
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

    inline function get_isRoot():Bool {
        return _isRoot;
    }
}