package gecko.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

class GeckoBuilder {
    #if macro
    public static macro function build() : Array<Field> {
        var fields = Context.getBuildFields();
        var defines = Context.getDefines();

        var title = "Gecko2D-Game";
        if(defines.exists("game_name")){
            title = defines["game_name"];
        }

        _addField(fields, "gameTitle", title);
        _createFlags(defines, fields);

        return fields;
    }

    private static function _addField(fields:Array<Field>, key:String, val:String) {
        fields.push({
            name: key,
            access: [ APublic, AStatic ],
            kind: FVar(macro : String, macro $v{val}),
            pos: Context.currentPos()
        });
    }

    private static function _createFlags(defines:Map<String, String>, fields:Array<Field>) {
        var toAdd:Bool = false;

        var flags:Array<Expr> = [macro $v{""} => $v{""}];

        for (k in defines.keys()) {
            var key = $v{k};
            if(key.indexOf("flag_") == 0){
                toAdd = true;
                flags.push(macro $v{key.substr(5)} => $v{Std.string(defines.get(key))});
            }
        }

        fields.push({
            name: "Flags",
            meta: null,
            kind: FieldType.FVar(macro : Map<String, String>, macro $a{flags}),
            access: [APublic, AStatic],
            pos: Context.currentPos(),
        });
    }
    #end
}