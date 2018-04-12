package gecko.systems.draw;

import gecko.Graphics;
import gecko.components.draw.DrawComponent;
import gecko.Float32;

using gecko.utils.ArrayHelper;

@:access(gecko.Transform)
class DrawSystem extends System implements IDrawable implements IUpdatable {
    private var _fixedToCamera:Array<DrawComponent> = [];
    private var _drawingFixedOnCamera:Bool = false;

    public function init(){
        filter.is(DrawComponent);
        priority = 5;
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        priority = 5;
        _fixedToCamera.clear();
    }

    override public function update(dt:Float32) {
        eachEntity(function(e:Entity){
            e.getDrawComponent().update(dt);
        });
    }

    override public function draw(g:Graphics) {
        _drawingFixedOnCamera = false;
        _draw(g, scene.rootEntity.transform, scene.rootEntity.getDrawComponent());

        _drawingFixedOnCamera = true;
        while(_fixedToCamera.length > 0){
            var drawComponent = _fixedToCamera.shift();
            _draw(g, drawComponent.entity.transform, drawComponent);
        }
    }

    private function _draw(g:Graphics, t:Transform, drawComponent:DrawComponent) {
        if(!_drawingFixedOnCamera && t.fixedToCamera && t.existsInCamera(scene.currentCameraRendering)){
            _fixedToCamera.push(drawComponent);
            return;
        }

        g.apply(t.worldMatrix, drawComponent.color, drawComponent.worldAlpha);

        drawComponent.preDraw(g);

        drawComponent.draw(g);

        for(current in t._children){
            var entity:Entity = current.entity;

            var parentDrawComponent:DrawComponent = current.parent.entity.getDrawComponent();
            if(parentDrawComponent != null){
                drawComponent.worldAlpha = parentDrawComponent.worldAlpha * drawComponent.alpha;
            }else{
                drawComponent.worldAlpha = drawComponent.alpha;
            }

            if(entity != null && hasEntity(entity) && drawComponent.visible){
                if(drawComponent.isVisible){
                    _draw(g, current, entity.getDrawComponent());
                }
            }
        }

        g.apply(t.worldMatrix, drawComponent.color, drawComponent.worldAlpha);
        drawComponent.postDraw(g);
    }

    /* iterative tree wal without pre and post render. Needs adapt to exec functions on pre and post draw
    override public function draw(g:Graphics) {
        //iterate through the tree (closing branchs from parent to childs)
        var current:Transform = scene.rootEntity.transform;
        var last:Transform = current;
        var branch:Int = 0;
        var i = 0;
        var isRendered:Bool = false;

        var _parents = [];

        //trace("START");
        while(current != null){

            isRendered = false;

            var currentEntity = current.entity;

            //trace("BRANCH", branch);

            if(currentEntity.enabled && hasEntity(currentEntity) && _canBeRendered(current.entity)){
                var drawComponent = currentEntity.getDrawComponent();
                var parentDrawComponent = current.parent.entity.getDrawComponent();

                drawComponent.worldAlpha = parentDrawComponent.worldAlpha * drawComponent.alpha;

                //trace(currentEntity.id, current.parent != null ? current.parent.id : -1);
                if(drawComponent.isVisible){
                    if(current.fixedToCamera){
                        //store to draw later
                        if(current.existsInCamera(scene.currentCameraRendering)){
                            _fixedToCamera.push(drawComponent);
                        }
                    }else{
                        g.apply(current.worldMatrix, drawComponent.color, drawComponent.worldAlpha);
                        drawComponent.draw(g);
                    }

                    isRendered = true;
                }

            }else if(currentEntity == scene.rootEntity){
                isRendered = true;
            }

            branch = current._branch;
            last = current;
            current = current._nextChild;

            var len = last._children.length;
            i = len-1;
            while(isRendered && i >= 0){
                last._children[i]._branch = branch+1;
                last._children[i]._nextChild = current;

                current = last._children[i];
                i--;
            }

            //trace("END BRANCH?", branch);

            //todo reset _nextChild to null to prevent collide with others systems?
        }
        //trace("END");

        //draw fixed to camera entities
        while(_fixedToCamera.length > 0){
            var drawComponent:DrawComponent = _fixedToCamera.shift();
            g.apply(drawComponent.entity.transform.worldMatrix, drawComponent.color, drawComponent.worldAlpha);
            drawComponent.draw(g);
        }

        g.reset();

    }*/

    inline private function _canBeRendered(e:Entity) : Bool {
        return e.hasDrawComponent() && e.getDrawComponent().visible;
    }
}