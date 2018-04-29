package gecko.utils;

//todo create instance with macros?
class Pool<T> {
    static private var _emptyArgs:Array<Dynamic> = new Array<Dynamic>();

    private var _objects:Array<T> = new Array<T>();
    private var _class:Class<T>;
    private var _args:Array<Dynamic>;
    private var _init:T->Void = null;
    private var _reset:T->Void = null;

    public function new(objClass:Class<T>, ?opts:PoolOptions<T>){
        opts = _parseOptions(opts);

        _class = objClass;
        _args = opts.args;
        
        if(opts.init != null){
            _init = opts.init;
        }

        if(opts.reset != null){
            _reset = opts.reset;
        }

        if(gecko.Gecko.isIniaited){
            for(i in 0...opts.amount){
                _objects.push(_create());
            }
        }else{
            gecko.Gecko.addOnKhaInitCallback(function(){
                for(i in 0...opts.amount){
                    this._objects.push(this._create());
                }
            });
        }
    }

    public function setInitCallback(cb:T->Void) {
        _init = cb;
    }

    public function setResetCallback(cb:T->Void) {
        _reset = cb;
    }

    private function _parseOptions(opts:PoolOptions<T>) : PoolOptions<T> {
        if(opts == null){
            opts = {};
        }
        opts.args = opts.args != null ? opts.args : null; 
        opts.amount = opts.amount != null ? opts.amount : 1;
        opts.init = opts.init != null ? opts.init : null; 
        opts.reset = opts.reset != null ? opts.reset : null;
        return opts;
    }

    private function _create() : T {
        return Type.createInstance(_class, _args != null ? _args : Pool._emptyArgs);
    }

    public function get() : T {
        var obj = _objects.length > 0 ? _objects.shift() : _create();
        if(_init != null){
            _init(obj);
        }
        return obj;
    }

    public function safePut(obj:T) {
        if(obj == null)return;

        //check array before add (slower than put)
        if(_objects.indexOf(obj) != -1){
            return;
        }

        if(_reset != null){
            _reset(obj);
        }
        _objects.push(obj);
    }

    public function put(obj:T) {
        if(obj == null)return;

        if(_reset != null){
            _reset(obj);
        }
        _objects.push(obj);
    }

    public function clean() {
        _objects = [];
    }

    public var length(get, null):Int;
    inline function get_length() : Int {
        return _objects.length;
    }
}