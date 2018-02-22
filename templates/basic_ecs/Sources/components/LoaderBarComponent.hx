package components;

import exp.components.draw.DrawComponent;
import exp.render.Graphics;
import exp.Color;

class LoaderBarComponent extends DrawComponent {
    public var progress:Int = 0;
    public var lineColor:Color = Color.White;
    public var fillColor:Color = Color.Beige;

    public function init(?lineColor:Color, ?fillColor:Color) {
        this.lineColor = lineColor;
        this.fillColor = fillColor;
    }

    override public function draw(g:Graphics) {
        g.color = fillColor;
        g.fillRect(0, 0, entity.transform.size.x*(progress/100), entity.transform.size.y);

        g.color = lineColor;
        g.drawRect(0, 0, entity.transform.size.x, entity.transform.size.y, 2);

    }
}