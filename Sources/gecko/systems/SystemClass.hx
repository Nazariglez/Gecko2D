package gecko.systems;

abstract SystemClass({public var __systemName__:String;}) {
    public var __systemName__(get, never):String;
    public inline function get___systemName__() {
        return this.__systemName__;
    }

    @:from static public function fromSystem(c:Class<System>) {
        return cast c;
    }
}