package scenes;

import exp.Entity;
import exp.components.draw.SpriteComponent;
import exp.components.core.TransformComponent;
import exp.Float32;

class DrawSpriteScene extends CustomScene {
    override public function init(closeButton:Bool = false) {
        super.init(closeButton);

        _addSprite("images/hippo.png", 220, 120);
        _addSprite("images/elephant.png", 420, 120);
        _addSprite("images/monkey.png", 620, 120);
    }

    private function _addSprite(sprite:String, x:Float32, y:Float32) {
        var e = Entity.create();
        e.addComponent(TransformComponent.create(x, y));
        e.addComponent(SpriteComponent.create(sprite));

        e.transform.scale.set(0.3, 0.3);

        addEntity(e);
    }
}