package gecko.components;

import gecko.utils.Event;

//todo macro clone all fields to use with prefabs?

@:allow(gecko.Entity)
class Component implements IComponent {
    public var entity(get, set):Entity;
    private var _entity:Entity = null;

    public var id:Int = Gecko.getUniqueID();

    public var name(get, set):String;
    private var _name:String = "";

    public var onAddedToEntity:Event<Entity->Void>;
    public var onRemovedFromEntity:Event<Entity->Void>;

    public function new(){
        onAddedToEntity = Event.create();
        onRemovedFromEntity = Event.create();
    }

    public function beforeDestroy(){
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