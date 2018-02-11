package exp.components;

import exp.components.Component;

class ChildrenComponent extends Component {
    private var _dirtySortChildren:Bool = false;

    public var children:Array<Entity> = [];

    public function addChild(child:Entity) {
        child.transform.parent = entity;
        child.onDepthChanged += _entityDepthChanged;
        children.push(child);
        _dirtySortChildren = true;
    }

    public function removeChild(child:Entity) {
        child.transform.parent = null;
        child.onDepthChanged -= _entityDepthChanged;
        children.remove(child);
    }

    public function update(dt:Float32) {
        if(_dirtySortChildren){
            children.sort(_sortChildren);
            _dirtySortChildren = false;
        }
    }

    private function _sortChildren(a:Entity, b:Entity) {
        if (a.depth < b.depth) return -1;
        if (a.depth > b.depth) return 1;
        return 0;
    }

    private function _entityDepthChanged(entity:Entity) {
        _dirtySortChildren = true;
    }

    override public function reset() {
        var i = 0;
        while(children.length != 0){
            removeChild(children[i]);
            i++;
        }
        _dirtySortChildren = false;
    }
}