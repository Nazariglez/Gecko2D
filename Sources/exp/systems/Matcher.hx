package exp.systems;

import exp.components.Component;

private typedef MatchQuery = {
    is:Class<Component>,
    equal:Class<Component>,
    any:Array<Class<Component>>,
    all:Array<Class<Component>>
};

class Matcher {
    private var _query:MatchQuery;

    public function new(){
        clear();
    }

    public function clear() : Matcher {
        _query = {
            is:null,
            equal:null,
            any: [],
            all: []
        };
        return this;
    }

    public function is(cls:Class<Component>) : Matcher {
        _query.is = cls;
        return this;
    }

    public function equal(cls:Class<Component>) : Matcher {
        _query.equal = cls;
        return this;
    }

    public function any(clss:Array<Class<Component>>) : Matcher {
        _query.any = clss;
        return this;
    }

    public function addAny(cls:Class<Component>) : Matcher {
        if(_query.any.indexOf(cls) == -1){
            _query.any.push(cls);
        }
        return this;
    }

    public function all(clss:Array<Class<Component>>) : Matcher {
        _query.all = clss;
        return this;
    }

    public function addAll(cls:Class<Component>) : Matcher {
        if(_query.all.indexOf(cls) == -1){
            _query.all.push(cls);
        }
        return this;
    }

    private inline function _isEmptyQuery() : Bool {
        return _query.is == null && _query.equal == null && _query.any.length == 0 && _query.all.length == 0;
    }

    public function testEntity(entity:Entity) : Bool {
        if(_isEmptyQuery()){
            return false;
        }

        var components = entity.getAllComponents();
        if(components.length != 0){
            if(_query.is != null){
                var valid = false;
                for(c in components){
                    if(Std.is(c, _query.is)){
                        valid = true;
                        break;
                    }
                }

                if(!valid)return false;
            }

            if(_query.equal != null){
                var valid = false;
                for(c in components){
                    if(_query.equal == c.__type__){
                        valid = true;
                        break;
                    }
                }

                if(!valid)return false;
            }

            if(_query.any.length != 0){
                var valid = false;
                for(c in components){
                    if(_query.any.indexOf(c.__type__) != -1){
                        valid = true;
                        break;
                    }
                }

                if(!valid)return false;
            }

            if(_query.all.length != 0){
                for(qc in _query.all){
                    var valid = false;
                    for(c in components){
                        if(c.__type__ == qc){
                            valid = true;
                            break;
                        }
                    }

                    if(!valid)return false;
                }
            }

            return true;
        }

        return false;
    }

    public function getValidComponents(entity:Entity) : Array<Class<Component>> {
        return [];
    }
}