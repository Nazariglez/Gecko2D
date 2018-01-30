package exp.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

//todo https://haxe.org/manual/macro-limitations-build-order.html
// todo allow override build(params)
class PoolBuilder {

    static private var poolOptions = ":autoPool";

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
            static inline public function create() return __pool__.get();
        }).fields;

        //add __toPool__ fn
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