package exp.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class PoolBuilder {

    static private var _initFns:Map<String, Field> = new Map<String, Field>();
    static private var _poolOptions = ":poolAmount";

    static public macro function build() : Array<Field> {
        var fields = Context.getBuildFields();
        var clazz = Context.getLocalClass().get();
        var path = clazz.pack.concat([clazz.name]);

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

        var poolFields = (macro class {
            static var __pool__ = new exp.utils.Pool($p{path}, {amount: $v{amount}/*, args: $v{arguments}*/});
            static inline public function getPool() return __pool__;
            //static inline public function create() return __pool__.get();
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
                static inline public function create() return __pool__.get();
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

        //add __toPool__ fn
        var i = -1;
        var existsToPool = false;
        for(f in fields){
            i++;
            if(f.name == "__toPool__"){
                existsToPool = true;
                break;
            }
        }

        var toPoolField = (macro class {
            override private function __toPool__() __pool__.put(this);
        }).fields[0];

        if(existsToPool){
            switch (fields[i].kind) {
                case FieldType.FFun(fn):
                    if (isEmptyFun(fn.expr)){

                        //change the body of the __toPool__
                        fn.expr = macro {
                            //__pool__.safePut(this);
                            __pool__.put(this);
                        }
                    }

                default:
            }
        }else{
            fields.push(toPoolField);
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