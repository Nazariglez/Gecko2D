package exp.components;

import exp.render.Graphics;
import exp.resources.Texture;
import exp.Assets;

class SpriteComponent extends DrawComponent {
    public var texture:Texture;

    public function init(?texture:String) {
        if(texture != null){
            this.texture = Assets.textures.get(texture);
        }
    }

    override public function draw(g:Graphics){
        if(texture == null)return;
        g.drawTexture(texture, 0, 0); //todo
    }

    override public function reset(){
        texture = null;
    }
}