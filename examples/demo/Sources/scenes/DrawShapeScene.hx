package scenes;

import exp.components.draw.PolygonComponent;
import exp.math.Point;
import exp.Float32;
import exp.components.draw.DrawComponent;
import exp.Color;
import exp.Entity;
import exp.components.core.TransformComponent;
import exp.components.draw.CircleComponent;
import exp.components.draw.RectangleComponent;

class DrawShapeScene extends CustomScene {
    override public function init(closeButton:Bool = false) {
        super.init(closeButton);

        //circles
        _createShape(100, 150, CircleComponent.create(true, 60), Color.Red); //fill
        _createShape(300, 150, CircleComponent.create(false, 60, 8), Color.Red);

        //rects
        _createShape(500, 150, RectangleComponent.create(true, 120, 120), Color.Green); //fill
        _createShape(700, 150, RectangleComponent.create(false, 120, 120, 8), Color.Green);

        //triangles
        var trianglePoints = [Point.create(60, 0), Point.create(0, 120), Point.create(120, 120)];
        _createShape(100, 400, PolygonComponent.create(true, trianglePoints), Color.Blue); //fill
        _createShape(300, 400, PolygonComponent.create(false, trianglePoints, 8), Color.Blue); //fill

        //hexagons
        var hexagonPoints = [
            Point.create(0, 40),
            Point.create(40, 0),
            Point.create(80, 0),
            Point.create(120, 40),
            Point.create(120, 80),
            Point.create(80, 120),
            Point.create(40, 120),
            Point.create(0, 80)
        ];
        _createShape(500, 400, PolygonComponent.create(true, hexagonPoints), Color.Yellow); //fill
        _createShape(700, 400, PolygonComponent.create(false, hexagonPoints, 8), Color.Yellow);

    }

    //create a generic entitiy to add a shape draw component
    private function _createShape(x:Float32, y:Float32, shapeComponent:DrawComponent, color:Color) {
        var e = Entity.create();
        e.addComponent(TransformComponent.create(x, y));
        e.addComponent(shapeComponent);

        shapeComponent.color = color;

        addEntity(e);
    }
}