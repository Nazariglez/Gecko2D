package exp;

@:allow(exp.Entity)
class Component {
    private var _typ:String = "";
    public var entity:Entity;

    public var id:String = "";
    public var name:String = "";

    public function new(id:String = "", name:String = "") {
        _typ = Type.getClassName(Type.getClass(this));

        this.id = id;
        this.name = name == "" ? _typ : name;
    }
}