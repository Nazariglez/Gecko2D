package k2d.input;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.Tools;
#end

class KeyboardBuilder {
  public static macro function build():Array<Field> {

    var fields = haxe.macro.Context.getBuildFields();
    
    fields.push({
      name:  "keyNames",
      access:  [Access.APublic, Access.AStatic],
      kind: FieldType.FVar(macro:Array<String>, macro $v{_getKeyNames(KeyCode)}), 
      pos: haxe.macro.Context.currentPos(),
    });
    
    return fields;
  }

  private static macro function _getKeyNames(typePath:Expr):Expr {
    var type = Context.getType(typePath.toString());

    switch (type.follow()) {
        case TAbstract(_.get() => ab, _) if (ab.meta.has(":enum")):
            var valueExprs = [];
            for (field in ab.impl.get().statics.get()) {
                if (field.meta.has(":enum") && field.meta.has(":impl")) {
                    valueExprs.push(macro $v{field.name.toLowerCase()});
                }
            }
            return macro $a{valueExprs};
        default:
            throw new Error(type.toString() + " should be @:enum abstract", typePath.pos);
        }
    }
}