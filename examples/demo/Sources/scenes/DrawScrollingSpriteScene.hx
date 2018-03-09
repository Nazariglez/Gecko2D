package scenes;

import exp.components.draw.ScrollingSpriteComponent;
import exp.components.core.TransformComponent;
import exp.Entity;
class DrawScrollingSpriteScene extends CustomScene {
    override public function init(closeButton:Bool = false) {
        super.init(closeButton);


    }

    private function _createScrollingSprite(sprite:String, x:Float32, y:Float32) {
        var e = Entity.create();
        e.addComponent(TransformComponent.create(x, y));
        e.addComponent(ScrollingSpriteComponent.create(sprite));

        addEntity(e);
    }
}