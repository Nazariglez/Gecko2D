package gecko;

import gecko.math.FastFloat;

typedef AnimationGridOptions = {
    var rows:Int;
    var cols:Int;
    var time:FastFloat;
    var texture:String;
    @:optional var loop:Bool;
    @:optional var total:Null<Int>; //total frames ex: 4x4, total=10. Use just the first 10 frames
    @:optional var frames:Array<Int>; //set the frames manually [0,1,2,3,4]
};