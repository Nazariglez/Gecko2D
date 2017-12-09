package gecko;

class System {
    static private var _updateEvents:Array<Void -> Void> = new Array<Void -> Void>();
    static private var _timeTaskID:Int = -1;

    static public function start() {
        _timeTaskID = kha.Scheduler.addTimeTask(_onSystemUpdate, 0, 1/30);
    }

    static public function stop() {
        kha.Scheduler.removeTimeTask(_timeTaskID);
    }

    static public function subscribeOnSystemUpdate(cb:Void->Void) {
        System._updateEvents.push(cb);
    }

    static public function unsubscribeOnSystemUpdate(cb:Void->Void) {
        System._updateEvents.remove(cb);
    }

    static private function _onSystemUpdate() {
        for(evt in _updateEvents){
            evt();
        }
    }

    private function new(){}
}