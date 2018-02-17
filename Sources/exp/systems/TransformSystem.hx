package exp.systems;

import exp.math.Matrix;
import exp.components.TransformComponent;
import exp.Float32;

class TransformSystem extends System implements IUpdatable {
    public var parent:Entity;

    private var _aW:Float32 = 0;
    private var _aH:Float32 = 0;
    private var _pW:Float32 = 0;
    private var _pH:Float32 = 0;

    private var _scX:Float32 = 0;
    private var _scY:Float32 = 0;
    private var _anX:Float32 = 0;
    private var _anY:Float32 = 0;
    private var _piX:Float32 = 0;
    private var _piY:Float32 = 0;
    
    private var _parentTransform:Matrix;

    public var disableDepthSort:Bool = false;
    
    public function init(){
        filter.equal(TransformComponent);
        priority = -1;
    }

    override public function update(dt:Float32) {
        //iterate tree (by branchs)
        var current:Entity = scene.rootEntity;
        var last:Entity = current;
        var next:Entity;

        while(current != null){

            if(current.enabled && current.transform.enabled){
                _transformEntity(current);

                for(c in current.transform.children){
                    c.transform._branch = current.transform._branch + 1;
                    c.transform._nextChild = null;

                    last.transform._nextChild = c;
                    last = c;
                }
            }

            next = current.transform._nextChild;
            current.transform._nextChild = null;
            current = next;
        }
    }
    
    inline private function _transformEntity(e:Entity) {
        if(!disableDepthSort && e.transform.children.length != 0 && e.transform.dirtyChildrenSort){
            e.transform.children.sort(_sortChildren);
            e.transform.dirtyChildrenSort = false;
        }

        //update skew
        if(e.transform.dirtySkew){
            //todo fixme it's ok this? sin in cos, X on Y. Maybe i changed the vars in the refactor to ecs?
            e.transform.skewCache.cosX = Math.cos(e.transform.rotation + e.transform.skew.y);
            e.transform.skewCache.sinX = Math.sin(e.transform.rotation + e.transform.skew.y);
            e.transform.skewCache.cosY = -Math.sin(e.transform.rotation - e.transform.skew.x);
            e.transform.skewCache.sinY = Math.cos(e.transform.rotation - e.transform.skew.x);

            e.transform.dirtySkew = false;
        }

        //Update local matrix
        if(e.transform.dirty){
            _scX = e.transform.scale.x * (e.transform.flip.x ? -1 : 1);
            _scY = e.transform.scale.y * (e.transform.flip.y ? -1 : 1);
            _anX = e.transform.flip.x ? 1-e.transform.anchor.x : e.transform.anchor.x;
            _anY = e.transform.flip.y ? 1-e.transform.anchor.y : e.transform.anchor.y;
            _piX = e.transform.flip.x ? 1-e.transform.pivot.x : e.transform.pivot.x;
            _piY = e.transform.flip.y ? 1-e.transform.pivot.y : e.transform.pivot.y;

            e.transform.localMatrix._00 = e.transform.skewCache.cosX * _scX;
            e.transform.localMatrix._01 = e.transform.skewCache.sinX * _scX;
            e.transform.localMatrix._10 = e.transform.skewCache.cosY * _scY;
            e.transform.localMatrix._11 = e.transform.skewCache.sinY * _scY;

            _aW = _anX * e.transform.size.x;
            _aH = _anY * e.transform.size.y;
            _pW = _piX * e.transform.size.x;
            _pH = _piY * e.transform.size.y;

            e.transform.localMatrix._20 = e.transform.position.x - _aW * _scX + _pW * _scX;
            e.transform.localMatrix._21 = e.transform.position.y - _aH * _scY + _pH * _scY;

            if(_pW != 0 || _pH != 0){
                e.transform.localMatrix._20 -= _pW * e.transform.localMatrix._00 + _pH * e.transform.localMatrix._10;
                e.transform.localMatrix._21 -= _pW * e.transform.localMatrix._01 + _pH * e.transform.localMatrix._11;
            }

            e.transform.dirty = false;
        }

        if(e.transform.parent == scene.rootEntity || e.transform.parent == null){
            e.transform.worldMatrix.setFrom(e.transform.localMatrix);
        }else{
            var _parentTransform = e.transform.parent.transform.worldMatrix;

            e.transform.worldMatrix._00 = (e.transform.localMatrix._00 * _parentTransform._00) + (e.transform.localMatrix._01 * _parentTransform._10);
            e.transform.worldMatrix._01 = (e.transform.localMatrix._00 * _parentTransform._01) + (e.transform.localMatrix._01 * _parentTransform._11);
            e.transform.worldMatrix._10 = (e.transform.localMatrix._10 * _parentTransform._00) + (e.transform.localMatrix._11 * _parentTransform._10);
            e.transform.worldMatrix._11 = (e.transform.localMatrix._10 * _parentTransform._01) + (e.transform.localMatrix._11 * _parentTransform._11);

            e.transform.worldMatrix._20 = (e.transform.localMatrix._20 * _parentTransform._00) + (e.transform.localMatrix._21 * _parentTransform._10) + _parentTransform._20;
            e.transform.worldMatrix._21 = (e.transform.localMatrix._20 * _parentTransform._01) + (e.transform.localMatrix._21 * _parentTransform._11) + _parentTransform._21;
        }
    }

    private function _sortChildren(a:Entity, b:Entity) {
        if (a.depth < b.depth) return -1;
        if (a.depth > b.depth) return 1;
        return 0;
    }
}