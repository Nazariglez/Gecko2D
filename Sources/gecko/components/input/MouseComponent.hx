package gecko.components.input;

import gecko.math.Rect;
import gecko.utils.Event;
import gecko.components.Component;

class MouseComponent extends Component {
    public var onRightPressed:Event<Float->Float->Void>;
    public var onRightReleased:Event<Float->Float->Void>;
    public var onRightReleasedOutside:Event<Float->Float->Void>;
    public var onRightDown:Event<Float->Float->Void>;

    public var onLeftPressed:Event<Float->Float->Void>;
    public var onLeftReleased:Event<Float->Float->Void>;
    public var onLeftReleasedOutside:Event<Float->Float->Void>;
    public var onLeftDown:Event<Float->Float->Void>;

    public var onCenterPressed:Event<Float->Float->Void>;
    public var onCenterReleased:Event<Float->Float->Void>;
    public var onCenterReleasedOutside:Event<Float->Float->Void>;
    public var onCenterDown:Event<Float->Float->Void>;

    public var onOver:Event<Float->Float->Void>;
    public var onOut:Event<Float->Float->Void>;
    public var onMove:Event<Float->Float->Void>; //todo

    public var onClick:Event<Float->Float->Void>;
    public var onDoubleClick:Event<Float->Float->Void>;

    public var isOver:Bool = false;
    public var isRightDown:Bool = false;
    public var isLeftDown:Bool = false;
    public var isCenterDown:Bool = false;

    public var box:Rect; //todo add a box to use instead the transform size

    public var doubleClickTreshold:Float = 0;

    private var _lastClickTime:Float = -1;

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

    public function init(doubleClickTreshold:Float = 0.3){
        this.doubleClickTreshold = doubleClickTreshold;
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

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
    }

    public function stopOrderPropagate(){

    }

}