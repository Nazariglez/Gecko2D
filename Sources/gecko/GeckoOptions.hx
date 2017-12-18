package gecko;

import kha.System.SystemOptions;

typedef GeckoOptions = {
    ?title:String,
    ?width:Int,
    ?height:Int,
    ?randomSeed:Int,
    ?fullScreen:Bool,
    ?transparent:Bool,
    ?backgroundColor:Color,
    ?khaOptions:SystemOptions
};