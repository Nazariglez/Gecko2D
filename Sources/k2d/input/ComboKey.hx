package k2d.input;

import k2d.math.FastFloat;
import k2d.utils.EventEmitter;
using StringTools;

@:enum abstract ComboKind(Int) {
    var ONE = 0;
    var MULTI = 1;
}

private typedef ComboData = { //todo pool this
    var kind:ComboKind;
    var keys:Array<KeyCode>;
}

class ComboKey {
    static private inline var EVENT_FIRE = "fire";

    public var combo(get, null):String;
    private var _combo:String;

    public var timeTreshold:Float;

    private var _comboData:Array<ComboData> = [];
    private var _index:Int = 0;
    private var _time:Float = -1;

    private var _listeners:Array<Void->Void> = [];
    public var length(get, null):Int;
    function get_length() : Int {
        return _listeners.length;
    }

    public function new(combo:String, timeTreshold:Float = 750){
        this._combo = combo;
        this.timeTreshold = timeTreshold;
        _parseCombo();
        Keyboard.onPressed += _onKeyPress;
    }

    public function destroy() {
        Keyboard.onPressed -= _onKeyPress;
    }

    public function addListener(listener:Void->Void) {
        if(_listeners.indexOf(listener) != -1){
            return;
        }

        _listeners.push(listener);
    }

    public function removeListener(listener:Void->Void) {
        _listeners.remove(listener);
    }

    private function _restart() {
        _time = -1;
        _index = 0;
    }

    private function _onKeyPress(key:KeyCode) {
        var now = Date.now().getTime();
        if(_time != -1){
            if(now-_time > timeTreshold){
                _restart();
                return;
            }
        }

        var data = _comboData[_index];
        switch(data.kind){
            case ComboKind.MULTI:
                if(data.keys.indexOf(key) != -1){
                    var pressed = true;
                    for(k in data.keys){
                        if(!Keyboard.isDown(k)){
                            pressed = false;
                            break;
                        }
                    }

                    if(pressed){
                        _nextKey();
                        if(_isComplete()){
                            _fire();
                        }
                    }
                }else{
                    if(_index > 0){
                        _restart();
                        _onKeyPress(key);
                    }
                }
            default:
                if(key != data.keys[0]){
                    if(_index > 0){
                        _restart();
                        _onKeyPress(key);
                        return;
                    }
                }else{
                    _nextKey();
                    if(_isComplete()){
                        _fire();
                    }
                }
        }
    }

    private function _fire() {
        for(fn in _listeners){
            fn();
        }
        _restart();
    }

    private function _nextKey() {
        _time = Date.now().getTime();

        if(_index < _comboData.length){
            _index++;
        }
    }

    inline private function _isComplete() : Bool {
        return _index == _comboData.length;
    }

    private function _parseCombo(){
        var keyNames = _combo.split(" ");

        for(k in keyNames){
            if(k.indexOf("+") != -1){
                
                var subNames = k.split("+");
                var data:ComboData = {
                    kind: ComboKind.MULTI,
                    keys: []
                };

                for(kk in subNames){
                    if(Keyboard.keyList.exists(kk)){
                        data.keys.push(Keyboard.keyList[kk]);
                    }else{
                        throw new Error('Invalid keyname: $kk');
                    }
                }

                _comboData.push(data);

            }else if(Keyboard.keyList.exists(k)){
                
                var data:ComboData = {
                    kind: ComboKind.ONE,
                    keys: [Keyboard.keyList[k]]
                };
                _comboData.push(data);

            }else{
                throw new Error('Invalid keyname: $k');
            }
        }
    }

    function get_combo() : String {
        return _combo;
    }
}