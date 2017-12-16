package gecko;

import kha.System.SystemOptions;

typedef GeckoOptions = {
    ?title:String,
    ?width:Null<Int>,
    ?height:Null<Int>,
    ?randomSeed:Null<Int>,
    ?fullScreen:Bool,
    ?transparent:Bool,
    ?backgroundColor:Color,
    ?khaOptions:SystemOptions
};