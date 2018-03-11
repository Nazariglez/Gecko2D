package gecko.components.draw;

import gecko.components.draw.DrawComponent;
import gecko.render.Graphics;
import gecko.Color;

class ProgressBarComponent extends DrawComponent {
    public var progress:Int = 0;
    public var lineColor:Color;
    public var fillColor:Color;
    public var outlineWidth:Int = 2;

    public function init(?lineColor:Color, ?fillColor:Color, outlineWidth:Int = 2) {
        this.lineColor = lineColor != null ? lineColor : Color.White;
        this.fillColor = fillColor != null ? fillColor : Color.OliveDrab;
        this.outlineWidth = outlineWidth;
    }

    override public function draw(g:Graphics) {
        g.color = fillColor;
        g.fillRect(0, 0, entity.transform.size.x*(progress/100), entity.transform.size.y);

        g.color = lineColor;
        g.drawRect(0, 0, entity.transform.size.x, entity.transform.size.y, outlineWidth);
    }
}