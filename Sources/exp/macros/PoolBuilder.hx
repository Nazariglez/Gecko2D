package exp.macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

class PoolBuilder {
    static public macro function build() : Array<Field> {
        var fields = Context.getBuildFields();
        var clazz = Context.getLocalClass();
        var p = Context.getType("exp.Pool");
        trace("adding pool to", clazz, p);

        var params = switch (p) {
            case TInst(_.get() => t, _): t.params;
            case _: throw "object type not found";
        }

        trace("NAME",params, params[0].t);
        var typePath = { name:"Pool", pack:["exp"], params: [TPType(TPath({name: "Entity", pack: ["exp"]}))] }
        var pool = macro new $typePath(Entity);
        fields.push({
            name: "_pool",
            access: [APrivate, AStatic],
            pos: Context.currentPos(),
            kind: FVar(macro: exp.Pool, pool)
        });

        return fields;
    }
}