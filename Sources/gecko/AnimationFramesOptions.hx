package gecko;

import gecko.math.FastFloat;

typedef AnimationFramesOptions = {
    var time:FastFloat;
    var frames:Array<String>;
    @:optional var loop:Bool;
};