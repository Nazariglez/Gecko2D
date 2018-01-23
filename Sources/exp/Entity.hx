package exp;

class Entity {
    public var id:String = "";
    public var name:String = "";

    public var components:Map<String,Component> = new Map<String, Component>();

    public function new(id:String = "", name:String = "") {
        this.id = id;
        this.name = name == "" ? Type.getClassName(Type.getClass(this)) : name;
    }

    public function addComponent(component:Component) {
        components.set(component._typ, component);
    }

    public function removeComponent(componentClass:Class<Component>) {
        components.remove(Type.getClassName(componentClass));
    }

    public function getComponent<T:Component>(componentClass:Class<T>) : T {
        return cast components.get(Type.getClassName(componentClass));
    }

    public function hasComponent(componentClass:Class<Component>) : Bool {
        return components.exists(Type.getClassName(componentClass));
    }
}