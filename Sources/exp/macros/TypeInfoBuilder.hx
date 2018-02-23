package exp.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

//todo set __className__ as private and use @:private access in the ecs?
class TypeInfoBuilder {
    static public macro function buildComponent() : Array<Field> {
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
                override public function get___type__() : Class<exp.components.Component> return $p{path};
            }).fields;
            fields = fields.concat(_extend);
        }else{
            var _extend = (macro class {
                public var __type__(get, null):Class<exp.components.Component>;
                public var __typeName__(get, null):String;

                public function get___type__() : Class<exp.components.Component> return $p{path};
                public function get___typeName__() : String return $v{name};
            }).fields;
            fields = fields.concat(_extend);
        }

        fields = fields.concat((macro class {
            static inline public var __componentName__:String = $v{name};
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
                override public function get___type__() : Class<exp.Entity> return $p{path};
            }).fields;
            fields = fields.concat(_extend);
        }else{
            var _extend = (macro class {
                public var __type__(get, null):Class<exp.Entity>;
                public var __typeName__(get, null):String;

                public function get___type__() : Class<exp.Entity> return $p{path};
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
                override public function get___type__() : Class<exp.Scene> return $p{path};
            }).fields;
            fields = fields.concat(_extend);
        }else{
            var _extend = (macro class {
                public var __type__(get, null):Class<exp.Scene>;
                public var __typeName__(get, null):String;

                public function get___type__() : Class<exp.Scene> return $p{path};
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
                override public function get___type__() : Class<exp.systems.System> return $p{path};
            }).fields;
            fields = fields.concat(_extend);
        }else{
            var _extend = (macro class {
                public var __type__(get, null):Class<exp.systems.System>;
                public var __typeName__(get, null):String;

                public function get___type__() : Class<exp.systems.System> return $p{path};
                public function get___typeName__() : String return $v{name};
            }).fields;
            fields = fields.concat(_extend);
        }

        fields = fields.concat((macro class {
            static inline public var __systemName__:String = $v{name};
        }).fields);

        return fields;
    }
}