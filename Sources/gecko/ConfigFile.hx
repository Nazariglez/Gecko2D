package gecko;

class ConfigFile extends BaseObject {
    private var _file:Storage;
    private var _config:Map<String, Dynamic> = new Map();

    public function init(configName:String = "default") {
        _file = Storage.create(configName + "__config_file.gecko");

        var map = _file.readObject();
        if(map == null){
            _config = new Map();
        }else{
            _config = cast map;
        }
    }

    public function set(key:String, value:Dynamic) {
        _config.set(key, value);
        _file.writeObject(_config);
    }

    public function get(key:String) : Dynamic {
        return _config.get(key);
    }

    public function remove(key:String) {
        _config.remove(key);
        _file.writeObject(_config);
    }

    public function clear() {
        _config = new Map();
        _file.writeObject(_config);
    }

    override public function beforeDestroy() {
        super.beforeDestroy();
        _file.destroy();

        _file = null;
        _config = null;
    }
}