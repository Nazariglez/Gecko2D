package gecko;

import kha.Storage as KhaStorage;
import kha.StorageFile;

class Storage extends BaseObject {
    public var _file:StorageFile;

    public function init(fileName:String = "default.gecko") {
        _file = KhaStorage.namedFile(fileName);
    }

    //todo clear function?

    public function read() : String {
        var content = _file.readString();
        return content != null ? content : "";
    }

    inline public function write(data:String) {
        _file.writeString(data);
    }

    inline public function writeObject(object:Dynamic) {
        _file.writeObject(object);
    }

    inline public function readObject() {
        return _file.readObject();
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        _file = null;
    }
}