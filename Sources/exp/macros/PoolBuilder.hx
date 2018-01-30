package exp.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

//todo https://haxe.org/manual/macro-limitations-build-order.html
// todo allow override build(params)  
class PoolBuilder {
    static public macro function build(amount:Int = 1, ?arguments:Array<Dynamic>) : Array<Field> {
        var fields = Context.getBuildFields();
        var clazz = Context.getLocalClass().get();
        var path = clazz.pack.concat([clazz.name]);

        var poolFields = (macro class {
            static var __pool__ = new exp.utils.Pool($p{path}, {amount: $v{amount}, args: $v{arguments}});
            static inline public function getPool() return __pool__;
            static inline public function create() return __pool__.get();
        }).fields;

        var i = -1;
        for(f in fields){
            i++;
            if(f.name == "__toPool__"){
                break;
            }
        }

        var toPoolField = (macro class {
            private inline function __toPool__() __pool__.put(this);
        }).fields[0];

        if(i != -1){
            switch (fields[i].kind) {
                case FieldType.FFun(fn):
                    if (isEmptyFun(fn.expr)){
                        var fname = fields[i].name;
                        var args = [for (arg in fn.args) macro $i{arg.name}];

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