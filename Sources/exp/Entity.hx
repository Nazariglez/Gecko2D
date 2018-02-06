package exp;

import exp.utils.Event;
import exp.macros.IAutoPool;
import exp.components.Component;

//todo toString for debug
//todo serialize && unserialize to save and load from text

#if !macro
@:poolAmount(100)
@:build(exp.macros.TypeInfoBuilder.buildEntity())
@:autoBuild(exp.macros.TypeInfoBuilder.buildEntity())
#end
class Entity implements IAutoPool {
    public var id:Int = Scene.getUniqueID();
    public var manager:Scene;
    public var enabled:Bool = true;

    public var name(get, set):String;
    private var _name:String = "";

    //todo hardcoded the renderComponent ref? and add it when addComponent Std.is(IRendereable) === true?
    //public var renderComponent:IRendereable;

    private var _components:Map<String,Component> = new Map<String, Component>();
    private var _componentsList:Array<Component> = [];

    public var onAddedComponent:Event<Entity->Component->Void> = Event.create();
    public var onRemovedComponent:Event<Entity->Component->Void> = Event.create();

    public function new() {}

    public function init(name:String = ""){
        _name = name;
    }

    public function reset(){}

    public function destroy(avoidPool:Bool = false) {
        reset();

        if(manager != null){
            manager.removeEntitiy(this);
        }

        for(name in _components.keys()){
            var component = _components.get(name);
            _components.remove(name);
            onRemovedComponent.emit(this, component);
            component.destroy();
        }

        if(!avoidPool)__toPool__();
    }

    private function __toPool__() {} //macro

    public function addComponent(component:Component) : Entity {
        component.entity = this;
        _components.set(component.__typeName__, component);
        _componentsList.push(component);
        onAddedComponent.emit(this, component);
        return this;
    }

    public function removeComponent<T:Component>(componentClass:Class<T>) : T {
        var name = Type.getClassName(componentClass);

        var c:T = cast _components.get(name);
        if(c != null){
            c.entity = null;
            _components.remove(name);
            _componentsList.remove(c);
            onRemovedComponent.emit(this, c);
            return c;
        }
        return null;
    }

    public function removeAllComponents() {
        for(c in _components.keys()){
            removeComponent(Type.resolveClass(c));
        }
    }

    public inline function getAllComponents() : Array<Component> {
        return _componentsList;
    }

    public function getComponent<T:Component>(componentClass:Class<T>) : T {
        return cast _components.get(Type.getClassName(componentClass));
    }

    public function hasComponent(componentClass:Class<Component>) : Bool {
        return _components.exists(Type.getClassName(componentClass));
    }

    inline function get_name():String {
        return _name == "" ? __typeName__ : _name;
    }

    inline function set_name(value:String):String {
        return this._name = value;
    }
}