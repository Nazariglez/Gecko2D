package gecko;

import gecko.math.FastFloat;
import gecko.resources.Image;
import gecko.render.Renderer;
import gecko.resources.Texture;
import gecko.math.Rect;

//crop method
class Sprite extends Container {
    public var texture(get, set):Texture;
    private var _texture:Texture;

    public var textureName(get, set):String;
    private var _textureName:String = "";

    public var trim:Rect = null;
    public var animations:AnimationManager;

    static public function fromTexture(texture:Texture) : Sprite {
        var s = new Sprite();
        s.texture = texture;
        return s;
    }

    static public function fromImage(img:Image) : Sprite {
        var s = new Sprite();
        s.texture = new Texture(img);
        return s;
    }

    public override function new(?textureName:String){
        super();
        if(textureName != null){
            this.textureName = textureName;
        }
        animations = new AnimationManager(this);
    }

    private override inline function _setSize(width:FastFloat, height:FastFloat) {
        if(_texture != null){
            size.x = _texture.width > width ? _texture.width : width;
            size.y = _texture.height > height ? _texture.height : height;
        } else {
            size.set(width, height);
        }
    }

    override public function update(dt:FastFloat) {
        super.update(dt);
        animations.update(dt);
    }

    public override function render(r:Renderer) {
        r.applyTransform(matrixTransform);
        if(_texture != null){
            if(trim != null){
                r.drawSubTexture(_texture, 0, 0, trim.x, trim.y, trim.width, trim.height);
            }else{
                r.drawTexture(_texture, 0,0);
            }
        }

        super.render(r);
    }

    function get_textureName() : String {
        return _textureName;
    }

    function set_textureName(name:String) : String {
        if(!Assets.textures.exists(name)){
            trace('Texture $name not loaded...');
            return "";
        }

        this.texture = Assets.textures[name];
        return this._textureName = name;
    }

    function get_texture() : Texture {
		return _texture;
	}

	function set_texture(texture:Texture) : Texture {
        if(texture != null){
            size.set(texture.width, texture.height);
        }
		return _texture = texture;
	}

    //todo set size by trim if exists. (needs set an observer in rect)
}