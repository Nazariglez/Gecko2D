package gecko.components.draw;

import gecko.Graphics;
import gecko.Entity;
import gecko.components.draw.DrawComponent;

class CircleComponent extends DrawComponent {
    public var radius(get, set):Float;
    private var _radius:Float = 1;

    public var fill:Bool = false;
    public var strength:Float = 2;
    public var segments:Int = 0;
    public var diameter(default, null):Float = 4;

    public function init(fill:Bool, radius:Float = 1, strength:Float = 2, segments:Int = 0) {
        this.radius = radius;
        this.fill = fill;
        this.strength = strength;
        this.segments = segments;

        onAddedToEntity += _setTransformSize;
    }

    override public function draw(g:Graphics) {
        if(fill){
            g.fillCircle(_radius, _radius, _radius);
        }else{
            g.drawCircle(_radius, _radius, _radius, strength, segments);
        }
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        onAddedToEntity -= _setTransformSize;

        radius = 1;
        fill = false;
        strength = 2;
    }

    private function _setTransformSize(e:Entity) {
        if(e.transform != null){
            e.transform.size.set(diameter, diameter);
        }
    }

    inline function get_radius():Float {
        return _radius;
    }

    function set_radius(value:Float):Float {
        if(value == _radius)return _radius;

        _radius = value;
        diameter = _radius * 2;

        if(entity != null && entity.transform != null){
            entity.transform.size.set(diameter, diameter);
        }

        return _radius;
    }

}