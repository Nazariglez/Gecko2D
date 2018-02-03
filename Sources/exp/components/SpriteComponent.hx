package exp.components;

import exp.resources.Texture;
import exp.Assets;

class SpriteComponent extends DrawComponent {
    public var texture:Texture;

    public function init(?texture:String) {
        if(texture != null){
            this.texture = Assets.textures.get(texture);
        }
    }

    override public function draw(){
        if(texture == null)return;
        Gecko.graphics.drawTexture(texture, 0, 0); //todo
    }

    override public function reset(){
        texture = null;
    }
}