---
title: Shapes
---
# Shapes

<iframe :src="$withBase('/builds/shapes/index.html')" width="800" height="600" frameBorder="0" style="width: 100vw; height:75vw; max-width:100%; max-height:600px"></iframe>

```haxe
package;

import gecko.Gecko;
import gecko.Color;
import gecko.Float32;
import gecko.math.Point;
import gecko.components.draw.CircleComponent;
import gecko.components.draw.RectangleComponent;
import gecko.components.draw.PolygonComponent;
import gecko.components.draw.DrawComponent;

class Game {
    public function new(){
        //circles
        _createShape(100, 150, CircleComponent.create(true, 60), Color.Red); //fill
        _createShape(300, 150, CircleComponent.create(false, 60, 8), Color.Red);

        //rects
        _createShape(500, 150, RectangleComponent.create(true, 120, 120), Color.Green); //fill
        _createShape(700, 150, RectangleComponent.create(false, 120, 120, 8), Color.Green);

        //triangles
        var trianglePoints = [Point.create(60, 0), Point.create(0, 120), Point.create(120, 120)];
        _createShape(100, 400, PolygonComponent.create(true, trianglePoints), Color.Blue); //fill
        _createShape(300, 400, PolygonComponent.create(false, trianglePoints, 8), Color.Blue);

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
        //create an entity in the current scene
        var entity = Gecko.currentScene.createEntity();

        //add the shape component
        entity.addComponent(shapeComponent);
        shapeComponent.color = color; //set a color for the shape

        //set the position to draw the entity on the screen
        entity.transform.position.set(x, y);
    }
}
```


[Source Code](https://github.com/Nazariglez/Gecko2D/tree/master/examples/shapes)
