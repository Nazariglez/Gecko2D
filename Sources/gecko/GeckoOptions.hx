package gecko;

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
    ?maximizable:Bool, //todo use screenSize instead maximizable in html5 and pc to use window size
    ?useFixedDelta:Bool,
    ?fps:Int,
    ?screen:ScreenOptions,
    ?khaOptions:SystemOptions
};