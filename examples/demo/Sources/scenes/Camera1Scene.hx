package scenes;

import gecko.Camera;
import gecko.components.misc.BehaviorComponent;
import gecko.Camera.CameraStyle;
import gecko.math.Rect;
import gecko.Graphics;
import gecko.Float32;
import gecko.input.KeyCode;
import gecko.input.Keyboard;
import gecko.components.draw.SpriteComponent;
import gecko.components.draw.ScrollingSpriteComponent;

using gecko.utils.MathHelper;

class Camera1Scene extends CustomScene {
    override public function init(closeButton:Bool = false) {
        super.init(closeButton);

        _createExample();
    }

    private function _createExample() {
        var BG_WIDTH = 2000;
        var BG_HEIGHT = 2000;

        var cam = createCamera();

        var bg = createEntity();
        bg.addComponent(GridBackgroundComponent.create("images/kenney/starBackground.png", BG_WIDTH, BG_HEIGHT));
        bg.transform.position.set(BG_WIDTH/2, BG_HEIGHT/2);

        var player = createEntity();
        player.addComponent(SpriteComponent.create("images/kenney/enemyUFO.png"));
        player.transform.position.set(BG_WIDTH/2, BG_HEIGHT/2);
        player.addComponent(PlayerMovement.create(cam));

        cam.follow(player, CameraStyle.LOCKON, 0.4, 0.4);
        cam.bounds = Rect.create(0, 0, BG_WIDTH, BG_HEIGHT);
    }
}

class PlayerMovement extends BehaviorComponent {
    public var cam:Camera;

    public function init(cam:Camera) {
        this.cam = cam;
    }

    override public function update(dt:Float32) {
        if(Keyboard.isDown(KeyCode.Left)) entity.transform.position.x -= 350*dt;
        if(Keyboard.isDown(KeyCode.Right)) entity.transform.position.x += 350*dt;
        if(Keyboard.isDown(KeyCode.Up)) entity.transform.position.y -= 350*dt;
        if(Keyboard.isDown(KeyCode.Down)) entity.transform.position.y += 350*dt;
        if(Keyboard.isDown(KeyCode.Z)) cam.rotation += (10).toRadians() * dt;
        if(Keyboard.isDown(KeyCode.X)) cam.rotation -= (10).toRadians() * dt;

        if(Keyboard.isDown(KeyCode.A) && cam.zoom > 0.5) cam.zoom -= 0.1*dt;
        if(Keyboard.isDown(KeyCode.S) && cam.zoom < 1.5) cam.zoom += 0.1*dt;
    }

    override public function beforeDestroy() {
        super.beforeDestroy();
        cam = null;
    }
}

//Custom drawableComponent to draw a grid
class GridBackgroundComponent extends ScrollingSpriteComponent {
    override public function draw(g:Graphics) {
        super.draw(g);

        var cols = Std.int(width/100);
        var rows = Std.int(height/100);

        g.color = 0xEEEEEE;

        for(xx in 0...cols){
            for(yy in 0...rows){
                g.drawLine(0, yy*100, width, yy*100, 5);
                g.drawLine(xx*100, 0, xx*100, height, 5);
            }
        }

    }
}