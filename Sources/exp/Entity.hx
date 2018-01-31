package exp;

import exp.macros.IAutoPool;
import exp.components.Component;

@:poolAmount(10)
class Entity implements IAutoPool {
    public var id:Int = -1;
    public var name:String = "";
    public var manager:EntityManager;
    public var enabled:Bool = true;

    //todo hardcoded the renderComponent ref? and add it when addComponent Std.is(IRendereable) === true?
    //public var renderComponent:IRendereable;

    private var _components:Map<String,Component> = new Map<String, Component>();
    private var _componentsList:Array<Component> = [];

    private var _addHandlers:Array<Entity->Component->Void> = [];
    private var _removeHandlers:Array<Entity->Component->Void> = [];

    public function new(name:String = "") {
        id = EntityManager.getUniqueID();
        this.name = name == "" ? Type.getClassName(Type.getClass(this)) : name;
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
            _dispatchRemoveComponent(this, component);
            component.destroy();
        }

        if(!avoidPool)__toPool__();
    }

    private function __toPool__() {} //macro

    public function addComponent(component:Component) : Entity {
        component.entity = this;
        _components.set(component._typ, component);
        _componentsList.push(component);
        _dispatchAddComponent(this, component);
        return this;
    }

    public function removeComponent<T:Component>(componentClass:Class<T>) : T {
        var name = Type.getClassName(componentClass);

        var c:T = cast _components.get(name);
        if(c != null){
            c.entity = null;
            _components.remove(name);
            _componentsList.remove(c);
            _dispatchRemoveComponent(this, c);
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


    public function onAddComponent(handler:Entity->Component->Void) {
        _addHandlers.push(handler);
    }

    public function offAddComponent(handler:Entity->Component->Void) {
        _addHandlers.remove(handler);
    }

    public function onRemoveComponent(handler:Entity->Component->Void) {
        _removeHandlers.push(handler);
    }

    public function offRemoveComponent(handler:Entity->Component->Void) {
        _removeHandlers.remove(handler);
    }

    private function _dispatchAddComponent(entity:Entity, component:Component) {
        for(handler in _addHandlers){
            handler(entity, component);
        }
    }

    private function _dispatchRemoveComponent(entity:Entity, component:Component) {
        for(handler in _removeHandlers){
            handler(entity, component);
        }
    }
}