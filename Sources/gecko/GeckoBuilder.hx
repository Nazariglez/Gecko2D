package gecko;

import haxe.macro.Context;
import haxe.macro.Expr;

class GeckoBuilder {
    public static macro function build() : Array<Field> {
        var fields = Context.getBuildFields();
        var defines = Context.getDefines();

        var title = "Gecko2D-Game";
        if(defines.exists("game_name")){
            title = defines["game_name"];
        }

        fields.push({
            name: "gameTitle",
            access: [ APublic, AStatic ],
            kind: FVar(macro : String, macro $v{title}),
            pos: Context.currentPos()
        });

        return fields;
    }

}