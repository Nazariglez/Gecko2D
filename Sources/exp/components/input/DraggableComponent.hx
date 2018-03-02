package exp.components.input;

import exp.math.Rect;
import exp.utils.Event;
import exp.components.Component;
import exp.input.MouseButton;

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

    public function setBounds(x:Float32, y:Float32, width:Float32, height:Float32) {
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