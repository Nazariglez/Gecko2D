package exp;

@:allow(exp.Entity)
class Component {
    private var _typ:String = "";
    public var entity:Entity;

    public var id:Int = -1;
    public var name:String = "";
    public var enabled:Bool = true;

    public function new(name:String = "") {
        _typ = Type.getClassName(Type.getClass(this));

        id = EntityManager.getUniqueID();
        this.name = name == "" ? _typ : name;
    }

    public function init(){}
    public function reset(){}

    public function destroy() {
        reset();
        if(entity != null){
            entity.removeComponent(Type.getClass(this));
        }
        _toPool();
    }

    private function _toPool() {
        //filled with macros
    }
}