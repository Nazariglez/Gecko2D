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
        components.set(component.name, component);
    }

    public function removeComponent(componentClass:Class<Component>) {
        components.remove(Type.getClassName(componentClass));
    }

    public function getComponent<T>(componentClass:Class<Component>) : T {
        return components.get(Type.getClassName(componentClass));
    }
}