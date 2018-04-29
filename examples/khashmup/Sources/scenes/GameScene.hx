package scenes;

import gecko.Audio;
import gecko.components.draw.AnimationComponent;
import gecko.math.Point;
import gecko.components.motion.MovementComponent;
import gecko.systems.motion.MotionSystem;
import gecko.components.collision.aabb.HitBoxComponent;
import gecko.systems.collision.aabb.AABBSystem;
import gecko.math.Random;
import gecko.timer.Timer;
import gecko.components.draw.SpriteComponent;
import gecko.math.Rect;
import gecko.Gecko;
import gecko.input.Keyboard;
import gecko.input.KeyCode;
import gecko.components.draw.TextComponent;
import gecko.components.draw.DrawComponent;
import gecko.Screen;
import gecko.Entity;
import gecko.systems.draw.DrawSystem;
import gecko.Scene;

import systems.PlayerSystem;
import components.PlayerComponent;
import systems.OutBoundsSystem;
import components.OutBoundsComponent;
import systems.ShootSystem;
import components.ShootComponent;

enum GameState {
    Playing;
    End;
}

class GameScene extends Scene {
    public var state(default, null):GameState = GameState.Playing;
    public var score(default, null):Int = 0;

    private var _hud:Entity;
    private var _scoreEntity:Entity;

    private var _spawnTimer:Timer;

    public function init() {
        var bounds:Rect = Rect.create(0, 0, Screen.width, Screen.height);

        addSystem(DrawSystem.create());
        addSystem(AABBSystem.create());
        addSystem(MotionSystem.create());
        addSystem(PlayerSystem.create(bounds.clone()));
        addSystem(OutBoundsSystem.create(bounds.clone()));
        addSystem(ShootSystem.create());

        state = GameState.Playing;
        score = 0;

        _createHUD();
        _createPlayer();
        _initSpawner();

        Keyboard.onPressed += _onPressed;
    }

    private function _initSpawner() {
        _spawnTimer = timerManager.createTimer(Random.getFloatIn(1, 3), 0, true);

        _spawnTimer.onRepeat += function(repeat:Int){
            if(state != GameState.Playing)return;

            //get new time each repeat
            _spawnTimer.time = Random.getFloatIn(1, 3);

            //spawn a new enemy
            _spawnEnemy();
        };

        _spawnTimer.start();
    }

    private function _spawnEnemy() {
        if(state != GameState.Playing)return;

        var entity = createEntity();
        entity.addComponent(OutBoundsComponent.create());
        entity.addComponent(MovementComponent.create(Point.create(0, 250))); //move axis y down at 250 of speed
        entity.addComponent(SpriteComponent.create("enemyShip.png"));

        var hitbox = entity.addComponent(HitBoxComponent.create());
        hitbox.onCollidingWith += function(e:Entity) {
            _destroyShip(entity);
            _setScore(score+1);

            //destroy bullet
            e.destroy();
        };

        entity.addTag("enemy");

        //x = random, y = 1px inside the screenview
        entity.transform.position.set(
            Random.getIn(Std.int(entity.transform.size.x), Std.int(Screen.width - entity.transform.size.x)),
            -entity.transform.size.y*entity.transform.anchor.y+1
        );
    }

    private function _createPlayer() {
        if(state != GameState.Playing)return;

        var entity = createEntity();
        entity.transform.position.set(Screen.centerX, Screen.centerY);
        entity.addComponent(PlayerComponent.create(KeyCode.Left, KeyCode.Right, KeyCode.Up, KeyCode.Down));
        entity.addComponent(ShootComponent.create(KeyCode.Z));
        entity.addComponent(MovementComponent.create(Point.create(0,0)));
        entity.addComponent(SpriteComponent.create("playerShip.png"));

        var hitbox:HitBoxComponent = entity.addComponent(HitBoxComponent.create(["enemy"]));
        hitbox.onCollidingWith += function(e:Entity) {
            _destroyShip(entity, true);
            _destroyShip(e);
            _gameOver();
        };

        entity.addTag("player");
    }

    private function _destroyShip(ship:Entity, isPlayer:Bool = false) {
        ship.removeAllComponents(true);

        var animFrames = [
            "smokeOrange0.png",
            "smokeOrange1.png",
            "smokeOrange2.png",
            "smokeOrange3.png",
        ];

        var animManager:AnimationComponent = ship.addComponent(AnimationComponent.create());
        animManager.addAnimFromAssets("smoke", 0.5, animFrames, true);

        animManager.onEnd += function(name:String){
            if(name == "smoke"){
                ship.destroy();
            }
        };

        animManager.play("smoke");

        _explosionSound(isPlayer);
    }

    private function _explosionSound(isPlayer:Bool = false) {
        var audio:Audio = Audio.create(isPlayer ? "playerExplosion.wav" : "enemyExplosion.wav");
        audio.destroyOnEnd = true;
        audio.play();
    }

    private function _onPressed(key:KeyCode) {
        if(state != GameState.End)return;

        if(key == KeyCode.Z){
            _restart();
        }
    }

    private function _restart() {
        //unbind restart event
        Keyboard.onPressed -= _onPressed;

        //"Rstart the scene" (Create a new GameScene destroying the current one)
        Gecko.world.changeScene(GameScene.create(), true);
    }

    private function _gameOver() {
        if(state != GameState.Playing)return;
        state = GameState.End;

        //stop the spawner
        _spawnTimer.stop();
        _spawnTimer.destroy();

        //add some text
        var gameOver = createEntity();
        gameOver.transform.parent = _hud.transform;
        gameOver.transform.localPosition.set(_hud.transform.size.x/2, 100);
        gameOver.addComponent(TextComponent.create("GAME OVER", "kenpixel_mini_square.ttf", 80, "center"));

        var restart = createEntity();
        restart.transform.parent = _hud.transform;
        restart.transform.localPosition.set(_hud.transform.size.x/2, _hud.transform.size.y - 100);
        restart.addComponent(TextComponent.create("Press 'Z' to restart", "kenpixel_mini_square.ttf", 30, "center"));
    }

    private function _setScore(n:Int) {
        if(state != GameState.Playing)return;

        score = n;
        var text:TextComponent = _scoreEntity.getComponent(TextComponent);
        text.text = 'score: $score';
    }

    private function _createHUD() {
        //HUD container
        _hud = createEntity();
        _hud.transform.size.set(Screen.width, Screen.height);
        _hud.transform.position.set(Screen.centerX, Screen.centerY);
        _hud.transform.fixedToCamera = true;
        _hud.addComponent(DrawComponent.create());

        //Entity which display the score on the top-left of the HUD
        _scoreEntity = createEntity();
        _scoreEntity.transform.anchor.set(0,0);
        _scoreEntity.transform.localPosition.set(10, 10);
        _scoreEntity.addComponent(TextComponent.create('score: ${score}', "kenpixel_mini_square.ttf", 20));

        //attach it to the hud
        _scoreEntity.transform.parent = _hud.transform;
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        //remove the reference to the entity (which is already destroyed and into his pool)
        _hud = null;
        _scoreEntity = null;
        _spawnTimer = null;
    }
}