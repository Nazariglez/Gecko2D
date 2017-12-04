package k2d.input;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.Tools;
#end

class KeyboardBuilder {
  public static macro function build():Array<Field> {

    var fields = haxe.macro.Context.getBuildFields();
    var n1 = $a{_getKeyNames(KeyCode)};
    var n2 = $a{_getKeyValues(KeyCode)};

    var map:Array<Expr> = [];
    
    //fix this little hack. If this line is deleted the compiler send an error (array access is not allowd)
    n1[0] = n1[0];

    for(i in 0...n1.length){
        var name = n1[i];
        //trace(name);
        var key = n2[i];
        map.push(macro $v{name} => cast($v{key}, KeyCode));
    }
    
    fields.push({
      name:  "keyList",
      access:  [Access.APublic, Access.AStatic],
      kind: FieldType.FVar(macro:Map<String, KeyCode>, macro $a{map}), 
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


    private static macro function _getKeyValues(typePath:Expr):Expr {
    var type = Context.getType(typePath.toString());

    switch (type.follow()) {
        case TAbstract(_.get() => ab, _) if (ab.meta.has(":enum")):
            var valueExprs = [];
            for (field in ab.impl.get().statics.get()) {
                if (field.meta.has(":enum") && field.meta.has(":impl")) {
                    var fieldName = field.name;
                    valueExprs.push(macro $typePath.$fieldName);
                }
            }
            return macro $a{valueExprs};
        default:
            throw new Error(type.toString() + " should be @:enum abstract", typePath.pos);
        }
    }
}