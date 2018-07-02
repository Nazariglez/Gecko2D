package gecko.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class PoolBuilder {

    static private var _initFns:Map<String, Field> = new Map<String, Field>();
    static private var _destroyFns:Map<String, Field> = new Map<String, Field>();
    static private var _destroyInmediateFns:Map<String, Field> = new Map<String, Field>();
    static private var _destroyedFlag:Map<String, Field> = new Map<String, Field>();
    static private var _poolOptions = ":poolAmount";
    static private var _poolUnsafe = ":poolUnsafe";

    static public macro function build() : Array<Field> {
        var fields = Context.getBuildFields();
        var clazz = Context.getLocalClass().get();
        var path = clazz.pack.concat([clazz.name]);

        if(clazz.isInterface){
            return fields;
        }

        //var arguments:Array<Dynamic> = null;
        var amount:Int = 1;

        if(clazz.meta.has(_poolOptions)){
            var autoPool = clazz.meta.extract(_poolOptions);
            var len = autoPool[0].params.length;
            if(len == 1){
                amount = switch(autoPool[0].params[0].expr){
                    case EConst(CInt(ss)): Std.parseInt(ss);
                    default: 1;
                }
            }
        }

        //todo add a instancePoolId (unique id) to debug?
        var poolFields = (macro class {
            static var __pool__ = new gecko.utils.Pool($p{path}, {amount: $v{amount}/*, args: $v{arguments}*/});
        }).fields;

        //add create function
        var initIndex = -1;
        var existsInit = false;
        var initFn:Field;


        for(f in fields){
            if(f.name == "init"){
                existsInit = true;
                initFn = f;
                _initFns.set(getClassId(clazz), f);
                break;
            }
        }

        //get the inherited init args
        if(!existsInit && clazz.superClass != null){

            var _cls = clazz;
            while(_cls.superClass != null){
                _cls = _cls.superClass.t.get();
                var id = getClassId(_cls);
                if(_initFns.exists(id)){
                    initFn = _initFns.get(id);
                    existsInit = true;
                    break;
                }
            }

        }


        if(!existsInit){
            fields.push((macro class {
                static inline public function create(){
                    var obj = __pool__.get();
                    obj.isAlreadyDestroyed = false;
                    return obj;
                }
            }).fields[0]);
        }else{
            //add init args
            var initArgs = switch(initFn.kind){
                case FFun(fn): fn.args;
                default: [];
            };

            //pass the same arguments to the call of init
            var argsName = [for(arg in initArgs) macro $i{arg.name}];
            var objInit = macro obj.init($a{argsName});

            var createFn = (macro class {
                static inline public function create(){
                    var obj = __pool__.get();
                    $objInit;
                    obj.isAlreadyDestroyed = false;
                    return obj;
                }
            }).fields[0];

            switch(createFn.kind){
                case FFun(fn):
                    fn.args = initArgs;
                    default:
            }

            fields.push(createFn);
        }


        var destroyIndex = -1;
        var existsDestroy = false;
        var destroyFn:Field;
        var destroyInmediateIndex = -1;
        var existsDestroyInmediate = false;
        var destroyInmediateFn:Field;

        var hasDestroyedFlag = false;

        for(f in fields){
            if(f.name == "destroy"){
                existsDestroy = true;
                destroyFn = f;
                _destroyFns.set(getClassId(clazz), f);
            }else if(f.name == "destroyInmediate"){
                existsDestroyInmediate = true;
                destroyInmediateFn = f;
                _destroyInmediateFns.set(getClassId(clazz), f);
            }

            if(f.name == "isAlreadyDestroyed"){
                hasDestroyedFlag = true;
                _destroyedFlag.set(getClassId(clazz), f);
            }
        }

        var isDestroyInherited = false;
        var isDestroyInmediateInherited = false;

        //get the inherited init args
        if(!existsDestroy && clazz.superClass != null){

            var _cls = clazz;
            while(_cls.superClass != null){
                _cls = _cls.superClass.t.get();
                var id = getClassId(_cls);
                if(_destroyFns.exists(id)){
                    destroyFn = _destroyFns.get(id);
                    existsDestroy = true;
                    isDestroyInherited = true;
                    break;
                }
            }

        }

        if(!existsDestroyInmediate && clazz.superClass != null){

            var _cls = clazz;
            while(_cls.superClass != null){
                _cls = _cls.superClass.t.get();
                var id = getClassId(_cls);
                if(_destroyInmediateFns.exists(id)){
                    destroyInmediateFn = _destroyInmediateFns.get(id);
                    existsDestroyInmediate = true;
                    isDestroyInmediateInherited = true;
                    break;
                }
            }

        }

        if(!hasDestroyedFlag && clazz.superClass != null) {
            var _cls = clazz;
            while(_cls.superClass != null) {
                _cls = _cls.superClass.t.get();
                var id = getClassId(_cls);
                if(_destroyedFlag.exists(id)){
                    hasDestroyedFlag = true;
                    break;
                }
            }
        }

        if(!hasDestroyedFlag){
            var f = (macro class {
                public var isAlreadyDestroyed(default, null):Bool = false;
                private var __flagToDestroy__(default, null):Bool = false;
            });

            fields = fields.concat(f.fields);
            _destroyedFlag.set(getClassId(clazz), f.fields[0]);
        }

        var _destroyUnsafe:Expr = macro __pool__.safePut(this);
        if(clazz.meta.has(_poolUnsafe)){
            _destroyUnsafe = macro __pool__.put(this);
        }

        if(!existsDestroy){
            var f = (macro class {
                public function destroy(){
                    if(isAlreadyDestroyed){
                    return;
                    }
                        if(!__flagToDestroy__){
                            __flagToDestroy__ = true;
                            @:privateAccess gecko.Gecko._destroyCallbacks.push(this.destroy);
                            return;
                        }

                        isAlreadyDestroyed = true;
                        beforeDestroy();
                        $_destroyUnsafe;
                        __flagToDestroy__ = false;
                    };
                }).fields[0];
            fields.push(f);

            _destroyFns.set(getClassId(clazz), f);
        }else{
            if(isDestroyInherited){
                fields.push((macro class {
                    override public function destroy(){
                        if(isAlreadyDestroyed){
                            return;
                        }

                        if(!__flagToDestroy__){
                            __flagToDestroy__ = true;
                            @:privateAccess gecko.Gecko._destroyCallbacks.push(this.destroy);
                            return;
                        }

                        isAlreadyDestroyed = true;
                        beforeDestroy();
                        $_destroyUnsafe;
                        __flagToDestroy__ = false;
                    };
                }).fields[0]);
            }else{
                switch(destroyFn.kind){
                    case FFun(fn):
                        fn.expr = macro {
                            if(isAlreadyDestroyed){
                                return;
                            }

                            if(!__flagToDestroy__){
                                __flagToDestroy__ = true;
                                @:privateAccess gecko.Gecko._destroyCallbacks.push(this.destroy);
                                return;
                            }

                            isAlreadyDestroyed = true;
                            beforeDestroy();
                            $_destroyUnsafe;
                            __flagToDestroy__ = false;
                        };

                    default:
                }
            }
        }


        //Destroy inmmediate
        if(!existsDestroyInmediate){
            var f = (macro class {
                public function destroyInmediate(){
                    if(isAlreadyDestroyed)return;
                    isAlreadyDestroyed = true;
                    beforeDestroy();
                    $_destroyUnsafe;
                };
            }).fields[0];
            fields.push(f);

            _destroyInmediateFns.set(getClassId(clazz), f);
        }else{
            if(isDestroyInmediateInherited){
                fields.push((macro class {
                    override public function destroyInmediate(){
                        if(isAlreadyDestroyed)return;
                        isAlreadyDestroyed = true;
                        beforeDestroy();
                        $_destroyUnsafe;
                    };
                }).fields[0]);
            }else{
                switch(destroyInmediateFn.kind){
                    case FFun(fn):
                        fn.expr = macro {
                            if(isAlreadyDestroyed)return;
                            isAlreadyDestroyed = true;
                            beforeDestroy();
                            $_destroyUnsafe;
                        };

                    default:
                }
            }
        }

        return fields.concat(poolFields);
    }

    static function getClassId(clazz:ClassType) : String {
        return (clazz.pack.concat([clazz.name])).join("_");
    }

    //check if the functions has empty body
    static function isEmptyFun(expr:Expr) {
        if (expr == null) return true;
        return switch (expr.expr) {
            case ExprDef.EBlock(exprs): exprs.length == 0;
            default: false;
        }
    }
}
