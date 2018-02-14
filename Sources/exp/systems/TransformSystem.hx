package exp.systems;

import exp.math.Matrix;
import exp.components.TransformComponent;
import exp.Float32;

class TransformSystem extends System {
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
    
    public function init(){
        matcher.equal(TransformComponent);
        priority = -1;
    }

    override public function update(dt:Float32) {
        for(e in getEntities()){
            if(!e.enabled)continue;

            if(e.transform.children.length != 0 && e.transform.dirtyChildrenSort){
                e.transform.children.sort(_sortChildren);
                e.transform.dirtyChildrenSort = false;
            }

            //update skew
            if(e.transform.dirtySkew){
                e.transform.skewCache.cosX = Math.cos(e.transform.rotation + e.transform.skew.y);
                e.transform.skewCache.sinX = Math.sin(e.transform.rotation + e.transform.skew.y);
                e.transform.skewCache.cosY = -Math.sin(e.transform.rotation - e.transform.skew.x);
                e.transform.skewCache.sinY = Math.cos(e.transform.rotation - e.transform.skew.x);

                e.transform.dirtySkew = false;
            }

            //TODO FIXME rotation is not working!!!

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


            e.transform.dirtyWorldTransform = true;
        }
    }

    private function _sortChildren(a:Entity, b:Entity) {
        if (a.depth < b.depth) return -1;
        if (a.depth > b.depth) return 1;
        return 0;
    }
}