package gecko.components;

import gecko.utils.Event;

//todo macro clone all fields to use with prefabs?


#if !macro
@:autoBuild(gecko.macros.TypeInfoBuilder.buildComponent())
@:build(gecko.macros.TypeInfoBuilder.buildComponent())
#end
@:allow(gecko.Entity)
class Component extends BaseObject {
    inline static public function getName(componentClass:Class<Component>) : String {
        return _toClass(componentClass).__componentName__;
    }

    inline static private function _toClass(componentClass:Class<Component>) : ComponentClass {
        return componentClass;
    }

    public var entity(get, set):Entity;
    private var _entity:Entity = null;

    public var name(get, set):String;
    private var _name:String = "";

    public var onAddedToEntity:Event<Entity->Void>;
    public var onRemovedFromEntity:Event<Entity->Void>;

    public function new(){
        super();

        onAddedToEntity = Event.create();
        onRemovedFromEntity = Event.create();
    }

    override public function beforeDestroy(){
        super.beforeDestroy();

        if(entity != null){
            entity.removeComponent(__type__);
        }

        onAddedToEntity.clear();
        onRemovedFromEntity.clear();
    }

    inline public function toString() : String {
        return 'Component: ${name}';
    }


    inline function get_name():String {
        return _name == "" ? __typeName__ : _name;
    }

    inline function set_name(value:String):String {
        return this._name = value;
    }

    inline function get_entity():Entity {
        return _entity;
    }

    function set_entity(value:Entity):Entity {
        if(_entity == value)return _entity;

        if(_entity != null){
            //trace("removed entity", id, Type.getClassName(Type.getClass(this)));
            onRemovedFromEntity.emit(_entity);
        }

        _entity = value;

        if(_entity != null){
            onAddedToEntity.emit(_entity);
        }

        return _entity;
    }
}

private abstract ComponentClass({public var __componentName__:String;}) {
    public var __componentName__(get, never):String;
    public inline function get___componentName__() {
        return this.__componentName__;
    }

    @:from static public function fromComponent(c:Class<Component>) {
        return cast c;
    }
}