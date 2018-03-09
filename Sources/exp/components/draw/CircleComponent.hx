package exp.components.draw;

import exp.render.Graphics;
import exp.Entity;
import exp.components.draw.DrawComponent;

class CircleComponent extends DrawComponent {
    public var radius(get, set):Float32;
    private var _radius:Float32 = 1;

    public var fill:Bool = false;
    public var strength:Float32 = 2;
    public var diameter(default, null):Float32 = 4;

    public function init(fill:Bool, radius:Float32 = 1, strength:Float32 = 2) {
        this.radius = radius;
        this.fill = fill;
        this.strength = strength;

        onAddedToEntity += _setTransformSize;
    }

    override public function draw(g:Graphics) {
        if(fill){
            g.fillCircle(0, 0, _radius);
        }else{
            g.drawCircle(0, 0, _radius, strength);
        }
    }

    override public function beforeDestroy() {
        onAddedToEntity -= _setTransformSize;

        radius = 1;
        fill = false;
        strength = 2;

        super.beforeDestroy();
    }

    private function _setTransformSize(e:Entity) {
        if(e.transform != null){
            e.transform.size.set(diameter, diameter);
        }
    }

    inline function get_radius():Float32 {
        return _radius;
    }

    function set_radius(value:Float32):Float32 {
        if(value == _radius)return _radius;

        _radius = value;
        diameter = _radius * 2;

        if(entity != null && entity.transform != null){
            entity.transform.size.set(diameter, diameter);
        }

        return _radius;
    }

}