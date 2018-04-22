package components;

import gecko.components.misc.BehaviorComponent;
import gecko.tween.Tween;
import gecko.tween.Easing;
import gecko.input.MouseButton;
import gecko.input.Mouse;
import gecko.Float32;

import GameState;

using gecko.utils.MathHelper;

class JumpComponent extends BehaviorComponent {
    private var _jumpingHeight:Float32 = 0;
    private var _jumpingTime:Float32 = 0;

    private var _tween:Tween;

    public var isJumping(default, null):Bool = false;

    public function init(jumpingHeight:Float32, jumpingTime:Float32) {
        _jumpingHeight = jumpingHeight;
        _jumpingTime = jumpingTime;

        isJumping = false;
    }

    override public function update(dt:Float32) {
        if(GameState.State == FlappyState.Playing || GameState.State == FlappyState.Idle){
            if(Mouse.wasPressed(MouseButton.LEFT)){
                isJumping = true;

                //reset or create a new tween
                _createTween();

                //set the jumping height and start tween
                _tween.setTo({
                    localPosition: {
                        y: entity.transform.localPosition.y - _jumpingHeight
                    },
                    rotation: (-20).toRadians()
                });

                _tween.start();
            }
        }

        //fall
        if(GameState.State == FlappyState.Playing || GameState.State == FlappyState.Falling){
            if(!isJumping){
                entity.transform.localPosition.y += 300*dt;

                var rotMax = (80).toRadians();
                if(entity.transform.rotation < rotMax){
                    entity.transform.rotation += rotMax * 1.5 * dt;
                }else if(entity.transform.rotation > rotMax){
                    entity.transform.rotation = rotMax;
                }
            }
        }
    }

    private function _cleanTweenRef() {
        _tween.stop();
        _tween.destroy();
        _tween = null;
    }

    private function _createTween() {
        if(entity != null && entity.scene != null){

            if(_tween == null){
                //create the tween with a basic info
                _tween = entity.scene.tweenManager.createTween(entity.transform, null, _jumpingTime, Easing.inQuad);
                _tween.onEnd += _onEndJump;
            }else{
                //reset the tween if exists to reuse using the same time, easing and target but with a new setTo
                _tween.reset();
            }
        }

    }

    private function _onEndJump() {
        _cleanTweenRef();

        isJumping = false;
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        if(_tween != null){
            _cleanTweenRef();
        }
    }
}