package exp.components.input;

import exp.utils.Event;
import exp.components.Component;

class MouseComponent extends Component {
    public var onRightPressed:Event<Float32->Float32->Void>;
    public var onRightReleased:Event<Float32->Float32->Void>;
    public var onRightReleasedOutside:Event<Float32->Float32->Void>;
    public var onRightDown:Event<Float32->Float32->Void>;

    public var onLeftPressed:Event<Float32->Float32->Void>;
    public var onLeftReleased:Event<Float32->Float32->Void>;
    public var onLeftReleasedOutside:Event<Float32->Float32->Void>;
    public var onLeftDown:Event<Float32->Float32->Void>;

    public var onCenterPressed:Event<Float32->Float32->Void>;
    public var onCenterReleased:Event<Float32->Float32->Void>;
    public var onCenterReleasedOutside:Event<Float32->Float32->Void>;
    public var onCenterDown:Event<Float32->Float32->Void>;

    public var onOver:Event<Float32->Float32->Void>;
    public var onOut:Event<Float32->Float32->Void>;
    public var onMove:Event<Float32->Float32->Void>; //todo

    public var onClick:Event<Float32->Float32->Void>;
    public var onDoubleClick:Event<Float32->Float32->Void>;

    public var isOver:Bool = false;
    public var isRightDown:Bool = false;
    public var isLeftDown:Bool = false;
    public var isCenterDown:Bool = false;

    public var doubleClickTreshold:Float32 = 0;

    private var _lastClickTime:Float32 = -1;

    public function new() {
        super();
        onRightPressed = Event.create();
        onRightReleased = Event.create();
        onRightReleasedOutside = Event.create();
        onRightDown = Event.create();

        onLeftPressed = Event.create();
        onLeftReleased = Event.create();
        onLeftReleasedOutside = Event.create();
        onLeftDown = Event.create();

        onCenterPressed = Event.create();
        onCenterReleased = Event.create();
        onCenterReleasedOutside = Event.create();
        onCenterDown = Event.create();

        onOver = Event.create();
        onOut = Event.create();
        onMove = Event.create();

        onClick = Event.create();
        onDoubleClick = Event.create();
    }

    public function init(doubleClickTreshold:Float32 = 0.3){
        this.doubleClickTreshold = doubleClickTreshold;
    }

    override public function beforeDestroy() {
        onRightPressed.clear();
        onRightReleased.clear();
        onRightReleasedOutside.clear();
        onRightDown.clear();

        onLeftPressed.clear();
        onLeftReleased.clear();
        onLeftReleasedOutside.clear();
        onLeftDown.clear();

        onCenterPressed.clear();
        onCenterReleased.clear();
        onCenterReleasedOutside.clear();
        onCenterDown.clear();

        onOver.clear();
        onOut.clear();
        onMove.clear();

        onClick.clear();
        onDoubleClick.clear();

        doubleClickTreshold = 0;
        isOver = false;
        isLeftDown = false;
        isCenterDown = false;
        isRightDown = false;
        _lastClickTime = -1;

        super.beforeDestroy();
    }

    public function stopOrderPropagate(){

    }

}