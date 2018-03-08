package scenes;

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

        //circle
        _createShape(10, 10, CircleComponent.create(true, 30), Color.Red);
        _createShape(100, 100, RectangleComponent.create(true, 60, 60), Color.Green);
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