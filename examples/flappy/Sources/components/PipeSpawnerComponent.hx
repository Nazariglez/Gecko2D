package components;

import gecko.Color;
import gecko.components.draw.RectangleComponent;
import gecko.math.Random;
import kha.network.Session.State;
import gecko.components.collision.aabb.HitBoxComponent;
import gecko.math.Point;
import gecko.components.draw.SpriteComponent;
import gecko.Entity;

import gecko.components.misc.BehaviorComponent;

import GameState;

using gecko.utils.ArrayHelper;

class PipeSpawnerComponent extends BehaviorComponent {
    public var speed:Float = 0;

    private var _pipes:Array<Entity> = [];
    private var _pipesToRemove:Array<Entity> = [];
    private var _triggers:Array<Entity> = [];
    private var _triggersToRemove:Array<Entity> = [];

    private var _spawnTime:Float = Config.SpawnTimeBetweenPipes;
    private var _elapsed:Float = 0;

    public var isRunning(default, null):Bool = false;
    public var collideCallback:Entity->Void;
    public var passPipe:Entity->Void;

    public function init(speed:Float, collidePipeCallback:Entity->Void, passPipeCallback:Entity->Void) {
        this.speed = speed;
        this.collideCallback = collidePipeCallback;
        this.passPipe = passPipeCallback;
    }

    public function start() {
        isRunning = true;
        _elapsed = _spawnTime;
    }

    public function stop() {
        isRunning = false;
    }

    override public function update(dt:Float) {
        if(!isRunning || GameState.State != FlappyState.Playing)return;

        if(_elapsed >= _spawnTime){
            _createPipe();
            _elapsed = 0;
        }

        for(pipe in _pipes){
            pipe.transform.localPosition.x -= speed*dt;

            if(pipe.transform.localRight < 0){
                pipe.destroy();
                _pipesToRemove.push(pipe);
            }
        }

        for(trigger in _triggers){
            trigger.transform.localPosition.x -= speed*dt;

            if(trigger.transform.localRight < 0){
                trigger.destroy();
                _triggersToRemove.push(trigger);
            }
        }

        _cleanArray();

        _elapsed += dt;
    }

    private function _cleanArray() {
        while(_pipesToRemove.length > 0){
            _pipes.remove(_pipesToRemove.pop());
        }

        while(_triggersToRemove.length > 0){
            _triggers.remove(_triggersToRemove.pop());
        }
    }

    private function _createPipe() {
        var margin = Config.GapBetweenPipes;

        var pipeBottom = _getPipe();
        pipeBottom.transform.anchor.set(0,1);
        pipeBottom.transform.localPosition.set(
            entity.transform.size.x,
            entity.transform.size.y + Random.getFloatIn(-12, entity.transform.size.y/3)
        );

        _pipes.push(pipeBottom);
        entity.scene.addEntity(pipeBottom);


        var pipeTop = _getPipe();
        pipeTop.transform.flip.y = true;
        pipeTop.transform.anchor.set(0,1);
        pipeTop.transform.localPosition.set(
            entity.transform.size.x,
            pipeBottom.transform.localTop - margin
        );

        _pipes.push(pipeTop);
        entity.scene.addEntity(pipeTop);


        //trigger to pass pipes
        var passTrigger = entity.scene.createEntity();
        passTrigger.transform.parent = entity.transform;
        passTrigger.transform.size.set(10, margin);
        passTrigger.transform.anchor.set(1, 0);
        passTrigger.transform.localPosition.set(
            pipeTop.transform.localRight,
            pipeTop.transform.localBottom
        );

        var hitbox:HitBoxComponent = passTrigger.addComponent(HitBoxComponent.create(["player"]));
        hitbox.onCollideStop += passPipe;
        hitbox.onCollideStop += function(e:Entity) {
            hitbox.onCollideStop -= passPipe;
        };

        //display collision rect
        //var rect:RectangleComponent = passTrigger.addComponent(RectangleComponent.create(true, passTrigger.transform.size.x, passTrigger.transform.size.y));
        //rect.color = Color.Red;
        //rect.alpha = 0.5;

        _triggers.push(passTrigger);
    }
    
    private function _getPipe() : Entity {
        var pipe:Entity = Entity.create();
        pipe.addComponent(SpriteComponent.create("images/flappydoge_pipe.png"));
        pipe.transform.parent = entity.transform;

        var hitbox:HitBoxComponent = pipe.addComponent(HitBoxComponent.create(["player"]));
        hitbox.onCollidingWith += collideCallback;
        
        return pipe;
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        _pipes.clear();
        _pipesToRemove.clear();
        _triggers.clear();
        _triggersToRemove.clear();

        _elapsed = 0;
        _spawnTime = Config.SpawnTimeBetweenPipes;

        isRunning = false;
        collideCallback = null;
        passPipe = null;
    }
}