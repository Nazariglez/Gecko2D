package exp.components.physics;

import exp.render.Graphics;
import exp.Entity;
import exp.utils.Event;
import exp.Float32;
import exp.math.Rect;
import exp.components.Component;

//todo read this https://noonat.github.io/intersect/#aabb-vs-segment

enum HitBoxSide {
    Top;
    Bottom;
    Left;
    Right;
}

class HitBoxComponent extends Component {
    public var box:Rect;
    public var tagsToCollide:Array<String>;

    public var onCollidingWith:Event<Entity->Void>;

    public var onCollideStart:Event<Entity->Void>;
    public var onCollideStop:Event<Entity->Void>;

    public var top(default, null):Float32 = 0;
    public var bottom(default, null):Float32 = 0;
    public var left(default, null):Float32 = 0;
    public var right(default, null):Float32 = 0;

    public var collidingWith:Array<Entity> = [];

    private var _frameID:Int = -1;

    public function new(){
        super();

        onCollidingWith = Event.create();
        onCollideStart = Event.create();
        onCollideStop = Event.create();
    }

    public function init(?tagsToCollide:Array<String>, ?box:Rect){
        if(tagsToCollide != null && tagsToCollide.length != 0){
            this.tagsToCollide = tagsToCollide;
        }

        if(box != null){
            this.box = box;
        }

        onAddedToEntity += _updateBounds;
    }

    public function getCollisionSide(box:HitBoxComponent) : HitBoxSide {
        var min, value:Float32;

        var side = HitBoxSide.Top;
        min = getTopDepth(box);

        if((value = getBottomDepth(box)) < min){
            min = value;
            side = HitBoxSide.Bottom;
        }

        if((value = getLeftDepth(box)) < min){
            min = value;
            side = HitBoxSide.Left;
        }

        if((value = getRightDepth(box)) < min){
            min = value;
            side = HitBoxSide.Right;
        }

        return side;
    }

    private function _updateBounds(e:Entity) {
        updateBounds();
    }

    public function updateBounds() {
        if(entity == null || entity.transform == null)return;

        var x, y, w, h:Float32;
        if(box != null){
            x = box.x;
            y = box.y;
            w = box.width;
            h = box.height;
        }else{
            x = 0;
            y = 0;
            w = entity.transform.size.x;
            h = entity.transform.size.y;
        }

        var m = entity.transform.worldMatrix;

        var x0 = (m._00 * x) + (m._10 * y) + m._20;
        var y0 = (m._01 * x) + (m._11 * y) + m._21;

        var x1 = (m._00 * w) + (m._10 * y) + m._20;
        var y1 = (m._01 * w) + (m._11 * y) + m._21;

        var x2 = (m._00 * x) + (m._10 * h) + m._20;
        var y2 = (m._01 * x) + (m._11 * h) + m._21;

        var x3 = (m._00 * w) + (m._10 * h) + m._20;
        var y3 = (m._01 * w) + (m._11 * h) + m._21;

        var minX = x0 < x1 ? x0 : x1;
        minX = minX < x2 ? minX : x2;
        minX = minX < x3 ? minX : x3;

        var maxX = x0 > x1 ? x0 : x1;
        maxX = maxX > x2 ? maxX : x2;
        maxX = maxX > x3 ? maxX : x3;

        var minY = y0 < y1 ? y0 : y1;
        minY = minY < y2 ? minY : y2;
        minY = minY < y3 ? minY : y3;

        var maxY = y0 > y1 ? y0 : y1;
        maxY = maxY > y2 ? maxY : y2;
        maxY = maxY > y3 ? maxY : y3;

        top = minY;
        bottom = maxY;
        left = minX;
        right = maxX;
    }

    public function canCollideWith(e:Entity) : Bool {
        if(tagsToCollide == null)return true;

        for(tag in tagsToCollide){
            if(e.hasTag(tag)){
                return true;
            }
        }

        return false;
    }

    inline public function getTopDepth(box:HitBoxComponent) : Float32 {
        return Math.abs(bottom - box.top);
    }

    inline public function getBottomDepth(box:HitBoxComponent) : Float32 {
        return Math.abs(top - box.bottom);
    }

    inline public function getLeftDepth(box:HitBoxComponent) : Float32 {
        return Math.abs(right - box.left);
    }

    inline public function getRightDepth(box:HitBoxComponent) : Float32 {
        return Math.abs(left - box.right);
    }

    override public function beforeDestroy() {
        if(box != null){
            box.destroy();
            box = null;
        }

        if(tagsToCollide != null){
            tagsToCollide = null;
        }

        onAddedToEntity -= _updateBounds;

        onCollidingWith.clear();
        onCollideStart.clear();
        onCollideStop.clear();

        super.beforeDestroy();
    }

    inline public function isCollidingWith(e:Entity) {
        return collidingWith.indexOf(e) != -1;
    }
}