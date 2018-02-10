package exp.utils;

import exp.components.Component;

@:expose
class ECSList {
    static public function addComponent(cls:Class<Component>, name:String) {
        components.set(cls, name);
    }

    static public var components:Map<Class<Dynamic>, String> = new Map();
}