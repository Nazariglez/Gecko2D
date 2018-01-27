package exp;

import kha.System.SystemOptions;

typedef GeckoOptions = {
    ?title:String,
    ?width:Int,
    ?height:Int,
    ?antialiasing:Int,
    ?randomSeed:Int,
    ?fullScreen:Bool,
    ?transparent:Bool,
    ?backgroundColor:Color,
    ?maximizable:Bool,
    ?html5CanvasMode:Html5CanvasMode,
    ?khaOptions:SystemOptions
};