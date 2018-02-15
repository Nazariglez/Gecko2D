package exp;

import kha.System.SystemOptions;

typedef GeckoOptions = {
    ?title:String,
    ?width:Int,
    ?height:Int,
    ?antialiasing:Int,
    ?randomSeed:Int,
    ?fullScreen:Bool,
    ?resizable:Bool,
    ?bgColor:Color,
    ?maximizable:Bool,
    ?screen:ScreenOptions,
    ?khaOptions:SystemOptions
};