package gecko.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using Lambda;

//todo set __className__ as private and use @:private access in the ecs?
class TypeInfoBuilder {
    static public macro function buildComponent() : Array<Field> {
        var fields = Context.getBuildFields();
        var clazz = Context.getLocalClass().get();
        var path = clazz.pack.concat([clazz.name]);
        var name = path.join(".");

        var baseTypes:Array<String> = [];
        var existsParent = false;
        var _cls = clazz;
        while(_cls.superClass != null){
            _cls = _cls.superClass.t.get();
            if(_cls.meta.has(":isBaseComponent")){
                var isBaseComponent = _cls.meta.extract(":isBaseComponent");
                baseTypes.push(_cls.pack.concat([_cls.name]).join("."));
            }

            for(f in _cls.fields.get()){
                if(f.name == "__type__"){
                    existsParent = true;
                }
            }
            //if(existsParent)break;
        }

        if(existsParent){
            var _extend = (macro class {
                override public function get___typeName__() : String return $v{name};
                override public function get___type__() : Class<gecko.components.Component> return $p{path};
            }).fields;
            fields = fields.concat(_extend);
        }else{
            var _extend = (macro class {
                public var __type__(get, null):Class<gecko.components.Component>;
                public var __typeName__(get, null):String;

                public function get___type__() : Class<gecko.components.Component> return $p{path};
                public function get___typeName__() : String return $v{name};
            }).fields;
            fields = fields.concat(_extend);
        }

        //basecomponent info
        if(clazz.meta.has(":isBaseComponent")){
            var isBaseComponent = clazz.meta.extract(":isBaseComponent");
            baseTypes.push(name);
        }

        if(baseTypes.length > 0){
            fields = fields.concat((macro class {
                static private var __componentTypes__(default, never):Array<String> = $v{baseTypes};
            }).fields);
        }else{
            fields = fields.concat((macro class {
                static private var __componentTypes__(default, never):Array<String> = [];
            }).fields);
        }


        //store component name
        fields = fields.concat((macro class {
            static private var __componentName__(default, never):String = $v{name};
        }).fields);

        return fields;
    }

    static public macro function buildEntity() : Array<Field> {
        var fields = Context.getBuildFields();
        var clazz = Context.getLocalClass().get();
        var path = clazz.pack.concat([clazz.name]);
        var name = path.join(".");

        var existsParent = false;
        var _cls = clazz;
        while(_cls.superClass != null){
            _cls = _cls.superClass.t.get();
            for(f in _cls.fields.get()){
                if(f.name == "__type__"){
                    existsParent = true;
                }
            }
            if(existsParent)break;
        }

        if(existsParent){
            var _extend = (macro class {
                override public function get___typeName__() : String return $v{name};
                override public function get___type__() : Class<gecko.Entity> return $p{path};
            }).fields;
            fields = fields.concat(_extend);
        }else{
            var _extend = (macro class {
                public var __type__(get, null):Class<gecko.Entity>;
                public var __typeName__(get, null):String;

                public function get___type__() : Class<gecko.Entity> return $p{path};
                public function get___typeName__() : String return $v{name};
            }).fields;
            fields = fields.concat(_extend);
        }

        return fields;
    }

    static public macro function buildScene() : Array<Field> {
        var fields = Context.getBuildFields();
        var clazz = Context.getLocalClass().get();
        var path = clazz.pack.concat([clazz.name]);
        var name = path.join(".");

        var existsParent = false;
        var _cls = clazz;
        while(_cls.superClass != null){
            _cls = _cls.superClass.t.get();
            for(f in _cls.fields.get()){
                if(f.name == "__type__"){
                    existsParent = true;
                }
            }
            if(existsParent)break;
        }

        if(existsParent){
            var _extend = (macro class {
                override public function get___typeName__() : String return $v{name};
                override public function get___type__() : Class<gecko.Scene> return $p{path};
            }).fields;
            fields = fields.concat(_extend);
        }else{
            var _extend = (macro class {
                public var __type__(get, null):Class<gecko.Scene>;
                public var __typeName__(get, null):String;

                public function get___type__() : Class<gecko.Scene> return $p{path};
                public function get___typeName__() : String return $v{name};
            }).fields;
            fields = fields.concat(_extend);
        }

        return fields;
    }

    static public macro function buildSystem() : Array<Field> {
        var fields = Context.getBuildFields();
        var clazz = Context.getLocalClass().get();
        var path = clazz.pack.concat([clazz.name]);
        var name = path.join(".");

        var existsParent = false;
        var _cls = clazz;
        while(_cls.superClass != null){
            _cls = _cls.superClass.t.get();
            for(f in _cls.fields.get()){
                if(f.name == "__type__"){
                    existsParent = true;
                }
            }
            if(existsParent)break;
        }

        if(existsParent){
            var _extend = (macro class {
                override public function get___typeName__() : String return $v{name};
                override public function get___type__() : Class<gecko.systems.System> return $p{path};
            }).fields;
            fields = fields.concat(_extend);
        }else{
            var _extend = (macro class {
                public var __type__(get, null):Class<gecko.systems.System>;
                public var __typeName__(get, null):String;

                public function get___type__() : Class<gecko.systems.System> return $p{path};
                public function get___typeName__() : String return $v{name};
            }).fields;
            fields = fields.concat(_extend);
        }

        fields = fields.concat((macro class {
            static private var __systemName__:String = $v{name};
        }).fields);

        return fields;
    }
}