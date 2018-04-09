package gecko.input;

import gecko.utils.Event;
import gecko.Float32;

using StringTools;

@:enum abstract ComboKind(Int) {
    var ONE = 0;
    var MULTI = 1;
}

private typedef ComboData = { //todo pool this
    var kind:ComboKind;
    var keys:Array<KeyCode>;
}

class ComboKey extends BaseObject {
    public var combo(default, null):String = "";
    public var length(get, null):Int;

    public var timeTreshold:Float32;

    private var _comboData:Array<ComboData> = [];
    private var _index:Int = 0;
    private var _time:Float32 = -1;

    public var onTrigger:Event<Void->Void>;

    public function new(){
        super();

        onTrigger = Event.create();
    }

    public function init(combo:String, timeTreshold:Float32 = 750){
        this.combo = combo;
        this.timeTreshold = timeTreshold;
        _parseCombo();
        Keyboard.onPressed += _onKeyPress;
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        onTrigger.clear();

        while(_comboData.pop() != null){}

        combo = "";
        _restart();

        Keyboard.onPressed -= _onKeyPress;
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

    inline private function _fire() {
        onTrigger.emit();
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
        var keyNames = combo.split(" ");

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
                        throw 'Invalid keyname: $kk';
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
                throw 'Invalid keyname: $k';
            }
        }
    }

    inline function get_length() : Int {
        return onTrigger.handlers.length;
    }
}