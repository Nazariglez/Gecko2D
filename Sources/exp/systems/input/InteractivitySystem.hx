package exp.systems.input;

import exp.input.Touch;
import exp.components.input.DraggableComponent;
import exp.components.core.TransformComponent;
import exp.math.Point;
import exp.components.input.MouseComponent;
import exp.input.MouseButton;
import exp.systems.System;
import exp.input.Mouse;

class InteractivitySystem extends System implements IUpdatable {
    public var checkInDrawOrder:Bool = false;

    private var _rightPressed:Bool = false;
    private var _leftPressed:Bool = false;
    private var _centerPressed:Bool = false;

    private var _rightReleased:Bool = false;
    private var _leftReleased:Bool = false;
    private var _centerReleased:Bool = false;

    private var _rightDown:Bool = false;
    private var _leftDown:Bool = false;
    private var _centerDown:Bool = false;

    private var _localPoint:Point;
    private var _pointer:Point;

    public function init(checkInDrawOrder:Bool = false){
        this.checkInDrawOrder = checkInDrawOrder;

        _localPoint = Point.create(0,0);
        _pointer = Point.create(0,0);

        filter.equal(TransformComponent).any([MouseComponent, DraggableComponent]);
    }

    override public function update(dt:Float32) {
        if(!Mouse.isEnabled && !Touch.isEnabled)return;

        if(Mouse.isEnabled){
            _rightPressed = Mouse.wasPressed(MouseButton.RIGHT);
            _leftPressed = Mouse.wasPressed(MouseButton.LEFT);
            _centerPressed = Mouse.wasPressed(MouseButton.CENTER);

            _rightReleased = Mouse.wasReleased(MouseButton.RIGHT);
            _leftReleased = Mouse.wasReleased(MouseButton.LEFT);
            _centerReleased = Mouse.wasReleased(MouseButton.CENTER);

            _rightDown = Mouse.isDown(MouseButton.RIGHT);
            _leftDown = Mouse.isDown(MouseButton.LEFT);
            _centerDown = Mouse.isDown(MouseButton.CENTER);

            _pointer.copy(Mouse.position);

        }

        if(Touch.isEnabled){
            _rightPressed = Touch.wasPressed(0);
            _rightReleased = Touch.wasReleased(0);
            _rightDown = Touch.isDown(0);

            if(_rightDown){
                _pointer.copy(Touch.getPosition(0));
            }
        }

        if(!checkInDrawOrder){
            _checkEntites(dt);
        }else{
            _checkEntitesInDrawOrder(dt);
        }
    }

    inline private function _checkEntites(dt:Float32) {
        for(e in getEntities()){
            if(!e.enabled)continue;
            _dispatchEntityEvents(e);
        }
    }

    private function _checkEntitesInDrawOrder(dt:Float32) {
        //todo drawOrder and stopPropagate
    }

    private function _dispatchEntityEvents(e:Entity) {
        var transform:TransformComponent = e.transform;
        transform.screenToLocal(Mouse.position, _localPoint);

        var mouseComponent:MouseComponent = e.getComponent(MouseComponent);
        var draggableComponent:DraggableComponent = e.getComponent(DraggableComponent);

        var isOver = false;

        if(_localPoint.x > 0 && _localPoint.x < transform.size.x){
            if(_localPoint.y > 0 && _localPoint.y < transform.size.y){

                isOver = true;

                if(mouseComponent != null){
                    if(_rightPressed){
                        mouseComponent.isRightDown = true;
                        mouseComponent.onRightPressed.emit(_localPoint.x, _localPoint.y);
                    }

                    if(_rightReleased){
                        mouseComponent.isRightDown = false;
                        mouseComponent.onRightReleased.emit(_localPoint.x, _localPoint.y);
                    }

                    if(_rightDown) mouseComponent.onRightDown.emit(_localPoint.x, _localPoint.y);

                    if(_centerPressed){
                        mouseComponent.isCenterDown = true;
                        mouseComponent.onCenterPressed.emit(_localPoint.x, _localPoint.y);
                    }

                    if(_centerReleased){
                        mouseComponent.isCenterDown = false;
                        mouseComponent.onCenterReleased.emit(_localPoint.x, _localPoint.y);
                    }

                    if(_centerDown) mouseComponent.onCenterDown.emit(_localPoint.x, _localPoint.y);

                    if(_leftPressed){
                        mouseComponent.isLeftDown = true;
                        mouseComponent.onLeftPressed.emit(_localPoint.x, _localPoint.y);
                    }

                    var sendClick:Bool = mouseComponent.isLeftDown && _leftReleased;

                    if(_leftReleased){
                        mouseComponent.isLeftDown = false;
                        mouseComponent.onLeftReleased.emit(_localPoint.x, _localPoint.y);
                    }

                    if(_leftDown) mouseComponent.onLeftDown.emit(_localPoint.x, _localPoint.y);


                    //click events
                    if(sendClick){
                        var lastClick = @:privateAccess mouseComponent._lastClickTime;
                        if(lastClick != -1 && Gecko.time - lastClick < mouseComponent.doubleClickTreshold){
                            @:privateAccess mouseComponent._lastClickTime = -1;
                            mouseComponent.onDoubleClick.emit(_localPoint.x, _localPoint.y);
                        }else{
                            @:privateAccess mouseComponent._lastClickTime = Gecko.time;
                            mouseComponent.onClick.emit(_localPoint.x, _localPoint.y);
                        }
                    }
                }

                //drag events
                if(draggableComponent != null){
                    var pressed = switch(draggableComponent.dragButton){
                        case MouseButton.LEFT: _leftPressed;
                        case MouseButton.CENTER: _centerPressed;
                        case MouseButton.RIGHT: _rightPressed;
                    };

                    var released = switch(draggableComponent.dragButton){
                        case MouseButton.LEFT: _leftReleased;
                        case MouseButton.CENTER: _centerReleased;
                        case MouseButton.RIGHT: _rightReleased;
                    };

                    if(draggableComponent.isDragged && released){
                        draggableComponent.isDragged = false;
                        draggableComponent.onDragStop.emit();
                    }else if(!draggableComponent.isDragged && pressed){
                        draggableComponent.isDragged = true;
                        draggableComponent.onDragStart.emit();
                    }
                }
            }
        }

        if(!isOver){
            if(mouseComponent != null){
                if(mouseComponent.isLeftDown && _leftReleased){
                    mouseComponent.isLeftDown = false;
                    mouseComponent.onLeftReleasedOutside.emit(_localPoint.x, _localPoint.y);
                }

                if(mouseComponent.isCenterDown && _centerReleased){
                    mouseComponent.isCenterDown = false;
                    mouseComponent.onCenterReleasedOutside.emit(_localPoint.x, _localPoint.y);
                }

                if(mouseComponent.isRightDown && _rightReleased){
                    mouseComponent.isRightDown = false;
                    mouseComponent.onRightReleasedOutside.emit(_localPoint.x, _localPoint.y);
                }
            }

            if(draggableComponent != null){
                var released = switch(draggableComponent.dragButton){
                    case MouseButton.LEFT: _leftReleased;
                    case MouseButton.CENTER: _centerReleased;
                    case MouseButton.RIGHT: _rightReleased;
                };

                if(released){
                    draggableComponent.isDragged = false;
                    draggableComponent.onDragStop.emit();
                }
            }
        }

        if(mouseComponent != null){
            if(isOver && !mouseComponent.isOver){
                mouseComponent.onOver.emit(_localPoint.x, _localPoint.y);
            }else if(!isOver && mouseComponent.isOver){
                mouseComponent.onOut.emit(_localPoint.x, _localPoint.y);
            }

            mouseComponent.isOver = isOver;
        }

        if(draggableComponent != null && draggableComponent.isDragged){
            var parent = draggableComponent.entity.transform.parent;
            parent.transform.screenToLocal(Mouse.position, _localPoint);

            if(draggableComponent.bounds == null){
                draggableComponent.entity.transform.position.copy(_localPoint);
            }else{
                var b = draggableComponent.bounds;
                if(_localPoint.x >= b.x && _localPoint.x <= b.x + b.width){
                    draggableComponent.entity.transform.position.x = _localPoint.x;
                }

                if(_localPoint.y >= b.y && _localPoint.y <= b.y + b.height){
                    draggableComponent.entity.transform.position.y = _localPoint.y;
                }
            }
        }
    }

    override public function beforeDestroy() {
        _localPoint.destroy();
        _localPoint = null;

        _pointer.destroy();
        _pointer = null;

        _rightPressed = false;
        _leftPressed = false;
        _centerPressed = false;

        _rightReleased = false;
        _leftReleased = false;
        _centerReleased = false;

        _rightDown = false;
        _leftDown = false;
        _centerDown = false;

        checkInDrawOrder = false;

        super.beforeDestroy();
    }
}