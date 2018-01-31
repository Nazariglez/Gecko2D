package exp.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

//todo https://haxe.org/manual/macro-limitations-build-order.html
// todo allow override build(params)
class PoolBuilder {

    static private var poolOptions = ":poolAmount";

    static public macro function build() : Array<Field> {
        var fields = Context.getBuildFields();
        var clazz = Context.getLocalClass().get();
        var path = clazz.pack.concat([clazz.name]);

        //var arguments:Array<Dynamic> = null;
        var amount:Int = 1;

        if(clazz.meta.has(poolOptions)){
            var autoPool = clazz.meta.extract(poolOptions);
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
        for(f in fields){
            initIndex++;
            if(f.name == "init"){
                existsInit = true;
                break;
            }
        }

        if(!existsInit){
            fields.push((macro class {
                static inline public function create() return __pool__.get();
            }).fields[0]);
        }else{
            var createFn = (macro class {
                static inline public function create(){
                    var obj = __pool__.get();
                    obj.init();
                    return obj;
                }
            }).fields[0];


            //add init args
            var initArgs = switch(fields[initIndex].kind){
                case FFun(fn): fn.args;
                default: [];
            };

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

    //check if the functions has empty body
    static function isEmptyFun(expr:Expr) {
        if (expr == null) return true;
        return switch (expr.expr) {
            case ExprDef.EBlock(exprs): exprs.length == 0;
            default: false;
        }
    }
}