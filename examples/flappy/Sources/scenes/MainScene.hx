package scenes;

import gecko.tween.Easing;
import gecko.tween.Tween;
import gecko.Screen;
import gecko.components.draw.TextComponent;
import gecko.components.draw.ScrollingSpriteComponent;
import gecko.math.Rect;
import gecko.Camera;
import gecko.Gecko;

import gecko.input.Mouse;
import gecko.components.draw.DrawComponent;
import gecko.Assets;
import gecko.Entity;
import gecko.components.collision.aabb.HitBoxComponent;
import gecko.systems.collision.aabb.AABBSystem;
import gecko.components.draw.SpriteComponent;
import gecko.systems.misc.BehaviorSystem;
import gecko.systems.motion.MotionSystem;
import gecko.components.draw.AnimationComponent;
import gecko.Screen;
import gecko.systems.draw.DrawSystem;
import gecko.Scene;
import gecko.components.draw.ScrollingSpriteComponent;

import components.JumpComponent;
import components.PipeSpawnerComponent;
import GameState;

using gecko.utils.MathHelper;

//todo fixme on osx the entity invisible

class MainScene extends Scene {
    private var _floor:Entity;
    private var _pipesContainer:Entity;
    private var _camera:Camera;
    private var _scoreText:Entity;
    private var _tapText:Entity;
    private var _tapTextTween:Tween;

    public var points:Int = 0;

    public function init() {
        addSystem(DrawSystem.create());
        addSystem(BehaviorSystem.create());
        addSystem(MotionSystem.create());
        addSystem(AABBSystem.create());

        _camera = createCamera();

        //background
        var bg = createEntity();
        bg.addComponent(SpriteComponent.create("images/flappydoge_bg1.png"));
        bg.transform.position.set(Screen.centerX, Screen.centerY);

        //entity to use as container for pipes
        _pipesContainer = createEntity();
        _pipesContainer.transform.size.set(Screen.width, Screen.height);
        _pipesContainer.transform.position.set(Screen.centerX, Screen.centerY);
        _pipesContainer.addComponent(DrawComponent.create());
        var p:PipeSpawnerComponent = _pipesContainer.addComponent(PipeSpawnerComponent.create(Config.PipesSpeed, _onCollideWithPipe, _onPassedPipe));
        p.start();

        //floor to collide at the bottom of the screen
        var floorName = "images/flappydoge_floor.png";
        _floor = createEntity();
        _floor.transform.anchor.set(0.5, 1);
        _floor.transform.position.set(Screen.centerX, Screen.height);
        _floor.addComponent(ScrollingSpriteComponent.create(floorName, Screen.width, Assets.textures.get(floorName).height));

        var hitbox:HitBoxComponent = _floor.addComponent(HitBoxComponent.create(["player"]));
        hitbox.onCollidingWith += _onPlayerCollideWithFloor;

        _createPlayer();

        _setScore(0);

        _displayTapText(true, "Tap to Start");

        GameState.State = FlappyState.Idle;

        Mouse.onLeftPressed += _initGame;
    }

    private function _displayTapText(isVisible:Bool = true, ?text:String) {
        if(_tapText == null){
            _tapText = createEntity();
            var textComponent:TextComponent = _tapText.addComponent(TextComponent.create("", "kenpixel_mini_square.ttf", 40));
            _tapText.transform.fixedToCamera = true;
            _tapText.transform.position.set(Screen.centerX, Screen.height - 50);
            _tapText.transform.anchor.set(0.5, 1);
            //_tapText.transform.scale.set(2,2);

            _tapTextTween = tweenManager.createTween(textComponent, {alpha: 0}, 2);
            _tapTextTween.loop = true;
            _tapTextTween.yoyo = true;
        }

        var textComponent:TextComponent = _tapText.getComponent(TextComponent);
        textComponent.visible = isVisible;
        textComponent.localAlpha = 1;

        if(text != null){
            textComponent.text = text;
        }

        _tapTextTween.reset();
        _tapTextTween.start();
    }

    private function _setScore(score:Int) {
        points = score;

        if(_scoreText == null){
            _scoreText = createEntity();
            _scoreText.addComponent(TextComponent.create("", "kenpixel_mini_square.ttf", 30));
            _scoreText.transform.fixedToCamera = true;
            _scoreText.transform.position.set(Screen.centerX, Screen.height/4);
            _scoreText.transform.scale.set(2,2);
        }

        var text:TextComponent = _scoreText.getComponent(TextComponent);
        text.text = '$points';
    }

    private function _initGame(x:Float, y:Float) {
        if(GameState.State != FlappyState.Idle)return;
        GameState.State = FlappyState.Playing;

        var scroll:ScrollingSpriteComponent = _floor.getComponent(ScrollingSpriteComponent);
        scroll.speed.x = Config.PipesSpeed;

        _displayTapText(false);

        Mouse.onLeftPressed -= _initGame;
    }

    private function _restartGame(x:Float, y:Float) {
        if(GameState.State != FlappyState.End)return;
        Mouse.onLeftPressed -= _restartGame;

        Gecko.world.changeScene(MainScene.create(), true);

    }

    private function _gameOver() {
        var scroll:ScrollingSpriteComponent = _floor.getComponent(ScrollingSpriteComponent);
        scroll.speed.x = 0;

        _displayTapText(true, "Tap to Restart");

        var tween = tweenManager.createTween(_scoreText.transform.scale, {x:4, y:4}, 1.5);
        tween.loop = true;
        tween.yoyo = true;
        tween.start();

        Mouse.onLeftPressed += _restartGame;
    }

    private function _createPlayer() {
        var animFrames = [
            "images/flappydoge_anim01.png",
            "images/flappydoge_anim02.png",
            "images/flappydoge_anim03.png",
            "images/flappydoge_anim02.png",
            "images/flappydoge_anim01.png",
        ];

        var entity = createEntity();
        entity.addComponent(JumpComponent.create(Config.PlayerJumpHeight, Config.PlayerJumpTime));
        entity.transform.anchor.set(1, 0.5);
        entity.transform.scale.set(1.2, 1.2);
        entity.transform.position.set(Screen.centerX, Screen.centerY);

        entity.addTag("player");

        var animComponent:AnimationComponent = entity.addComponent(AnimationComponent.create());
        animComponent.addAnimFromAssets("doge", 0.5, animFrames);

        //animComponent.setTextureFrame("doge", 0);
        animComponent.play("doge", true);

        var offsetX = entity.transform.size.x * 0.1;
        var offsetY = entity.transform.size.y * 0.1;
        var hitboxBounds = Rect.create(offsetX, offsetY, entity.transform.size.x - offsetX, entity.transform.size.y - offsetY);
        entity.addComponent(HitBoxComponent.create(null, hitboxBounds));
    }

    private function _onPlayerCollideWithFloor(e:Entity) {
        if(GameState.State == FlappyState.End)return;
        GameState.State = FlappyState.End;

        e.removeComponent(HitBoxComponent, true);
        e.removeComponent(JumpComponent, true);

        var anim:AnimationComponent = e.getComponent(AnimationComponent);
        anim.stop();

        _gameOver();
    }

    private function _onPassedPipe(e:Entity) {
        if(GameState.State != FlappyState.Playing)return;
        _setScore(points+1);
    }

    private function _onCollideWithPipe(e:Entity) {
        if(GameState.State != FlappyState.Playing)return;
        GameState.State = FlappyState.Falling;

        _camera.shake(0.01, 0.2);

        var spawner:PipeSpawnerComponent = _pipesContainer.getComponent(PipeSpawnerComponent);
        spawner.stop();
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        _floor = null;
        _pipesContainer = null;
        _camera = null;
        _scoreText = null;
        _tapText = null;
        _tapTextTween = null;

        points = 0;

        Mouse.onLeftPressed -= _initGame;
        Mouse.onLeftPressed -= _restartGame;
    }
}
