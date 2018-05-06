package gecko.components.input;

import gecko.math.Rect;
import gecko.utils.Event;
import gecko.components.Component;
import gecko.input.MouseButton;

class DraggableComponent extends Component {
    public var onDragStart:Event<Void->Void>;
    public var onDragStop:Event<Void->Void>;

    public var dragButton:MouseButton = MouseButton.LEFT;

    public var isDragged:Bool = false;
    public var bounds:Rect;

    public function new(){
        super();
        onDragStart = Event.create();
        onDragStop = Event.create();
    }

    public function init(button:MouseButton = MouseButton.LEFT) {
        dragButton = button;
    }

    public function setBounds(x:Float, y:Float, width:Float, height:Float) {
        if(bounds == null){
            bounds = Rect.create(x, y, width, height);
        }else{
            bounds.set(x, y, width, height);
        }
    }

    override public function beforeDestroy(){
        onDragStart.clear();
        onDragStop.clear();

        dragButton = MouseButton.LEFT;
        isDragged = false;

        if(bounds != null){
            bounds.destroy();
            bounds = null;
        }

        super.beforeDestroy();
    }
}