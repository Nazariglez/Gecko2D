package exp.components.physics;

import exp.Entity;
import exp.utils.Event;
import exp.Float32;
import exp.math.Rect;
import exp.components.Component;

class BoundingBoxComponent extends Component {
    public var box:Rect;

    public var onCollidingWith:Event<Entity->Void>;

    public var onCollideStart:Event<Entity->Void>;
    public var onCollideStop:Event<Entity->Void>;

    public var top(get, null):Float32;
    public var bottom(get, null):Float32;
    public var left(get, null):Float32;
    public var right(get, null):Float32;

    public var collidingWith:Array<Entity> = [];

    public function new(){
        super();

        onCollidingWith = Event.create();
        onCollideStart = Event.create();
        onCollideStop = Event.create();
    }

    public function init(?box:Rect){
        //todo transform aabb as optional parameter?
        //todo intersection point or axis?


        if(box != null){
            this.box = box;
        }
    }

    override public function beforeDestroy() {
        if(box != null){
            box.destroy();
            box = null;
        }

        onCollidingWith.clear();
        onCollideStart.clear();
        onCollideStop.clear();

        super.beforeDestroy();
    }

    inline public function isCollidingWith(entity:Entity) {
        return collidingWith.indexOf(entity) != -1;
    }

    inline function get_top():Float32 {
        return box != null ? box.top : entity.transform.top;
    }

    inline function get_bottom():Float32 {
        return box != null ? box.bottom : entity.transform.bottom;
    }

    inline function get_left():Float32 {
        return box != null ? box.left : entity.transform.left;
    }

    inline function get_right():Float32 {
        return box != null ? box.right : entity.transform.right;
    }
}