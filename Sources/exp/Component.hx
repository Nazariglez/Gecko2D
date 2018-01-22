package exp;

class Component {
    public var entity:Entity;

    public var id:String = "";
    public var name:String = "";

    public function new(id:String = "", name:String = "") {
        this.id = id;
        this.name = name == "" ? Type.getClassName(Type.getClass(this)) : name;
    }
}