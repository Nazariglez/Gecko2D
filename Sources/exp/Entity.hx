package exp;

class Entity {
    public var id:String = "";
    public var name:String = "";

    public var engine:SystemManager;

    private var _components:Map<String,Component> = new Map<String, Component>();

    public function new(id:String = "", name:String = "") {
        this.id = id;
        this.name = name == "" ? Type.getClassName(Type.getClass(this)) : name;
    }

    public function addComponent(component:Component) : Entity {
        _components.set(component._typ, component);
        return this;
    }

    public function removeComponent<T:Component>(componentClass:Class<T>) : T {
        var name = Type.getClassName(componentClass);
        var c:T = cast _components.get(name);
        if(c != null){
            _components.remove(name);
            return c;
        }
        return null;
    }

    public function getComponent<T:Component>(componentClass:Class<T>) : T {
        return cast _components.get(Type.getClassName(componentClass));
    }

    public function hasComponent(componentClass:Class<Component>) : Bool {
        return _components.exists(Type.getClassName(componentClass));
    }
}