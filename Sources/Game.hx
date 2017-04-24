package;

import prime.Game;
import prime.Actor;
import prime.Sprite;
import prime.Container;
import kha.graphics2.Graphics;
import kha.Color;
import kha.Assets;

class Game extends prime.Game {
  public function new(){
    super("Mi Juego", 800, 600);
  }

  override function onInit() : Void {
    super.onInit();
    Assets.loadEverything(function(){
      var sprite = new Sprite(Assets.images.rabbit);
      sprite.position.set(
        _width*0.5,
        _height*0.5
      );
      sprite.scale.set(4);
      stage.addChild(sprite);
    });
  }
}