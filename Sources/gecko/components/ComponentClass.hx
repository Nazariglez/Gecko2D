package gecko.components;

abstract ComponentClass({public var __componentName__:String;}) {
    public var __componentName__(get, never):String;
    public inline function get___componentName__() {
        return this.__componentName__;
    }

    @:from static public function fromComponent(c:Class<Component>) {
        return cast c;
    }
}