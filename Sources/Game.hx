package;

import prime.Game;
import prime.Actor;
import kha.graphics2.Graphics;
import kha.Color;

class Game extends prime.Game {
  public function new(){
    super("Mi Juego", 800, 600);
  }

  override function onInit() : Void {
    super.onInit();
    var actor:Actor = new Actor1();
    stage.addChild(actor);
  }

  override function update(delta:Float) : Void {
    super.update(delta);
  }

  override function render(g:Graphics) : Void {
    super.render(g);
		g.color = Color.Pink;
		g.drawLine(10, 10, 50, 50, 10);
		g.color = Color.Red;
		g.fillRect(200, 300, 200, 220);
		g.color = Color.Magenta;
		g.drawRect(200, 300, 200, 220);
  }
}

class Actor1 extends Actor {
  override public function render(g:Graphics) : Void {
      super.render(g);
      g.color = Color.Orange;
      g.fillRect(position.x+450, position.y+0, 100, 100);
  }

  override public function update(delta:Float) : Void {
    super.update(delta);
    trace(delta);
    position.x += 100*delta;
    position.y += 20*delta;
  }
}