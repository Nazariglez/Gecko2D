package;

import prime.Game;
import prime.Actor;
import prime.Sprite;
import prime.Container;
import prime.Renderer;
import prime.Color;
import prime.Text;
import kha.math.FastMatrix3;
import kha.Assets;
import kha.input.Mouse;
import kha.Font;

class Game extends prime.Game {
  var rabbits:Array<Rabbit> = [];
  var gravity:Float = 0.5;

  var count:Int = 0;

  var minX:Float = 0;
  var maxX:Float = 1024;
  var minY:Float = 0;
  var maxY:Float = 768;

  var font:Font;

  var cleanMatrix:FastMatrix3 = FastMatrix3.identity();
  var counter:Counter = new Counter();
  var container:Container = new Container();

  var fps:Float = 0;
  var totalFrames:Float = 0;
  var elapsed:Float = 0;

  public function new(){
    super("Mi Juego", 1024, 768);
    //_loop.setFPS(30);
  }

  override function onInit() : Void {
    super.onInit();
    Assets.loadEverything(function(){
      var scale = Math.min(windowWidth/maxX, windowHeight/maxY);
      stage.position.set(
        windowWidth/2 - maxX*scale/2, windowHeight/2 - maxY*scale/2
      );
      stage.scale.set(scale);
      trace(scale);
      stage.addChild(container);

      counter.font = Assets.fonts.mainfont;
      counter.position.set(
        515, 5
      );
      stage.addChild(counter);
      font = Assets.fonts.mainfont;
      Mouse.get().notify(mouseDown, null, null, null);

      for(i in 0...1000){
        addRabbit();
      }
    });
  }

  function mouseDown(button:Int, x:Int, y:Int) : Void {
    for(i in 0...500){
      addRabbit();
    }
  }

  public function addRabbit(){
    var rabbit = new Rabbit();
    rabbit.speed.x = Math.random() * 5;
    rabbit.speed.y = Math.random() * 5 - 2.5;
    rabbit.tint = Color.fromFloats(Math.random(), Math.random(), Math.random());
    container.addChild(rabbit);

    rabbits.push(rabbit);
    count++;
    counter.count = count;
  }

  override function render() : Void {
      counter.fps = stats.renderFps;
      counter.ms = stats.renderMs;
      super.render();
  }

  override function update(delta:Float) : Void {
    super.update(delta);

    if(rabbits.length > 0){
      for(i in 0...rabbits.length){
        var bunny = rabbits[i];
        bunny.position.x += bunny.speed.x;
        bunny.position.y += bunny.speed.y;
        bunny.speed.y += gravity;

        if (bunny.position.x > maxX) {
          bunny.speed.x *= -1;
          bunny.position.x = maxX;
        } else if (bunny.position.x < minX) {
          bunny.speed.x *= -1;
          bunny.position.x = minX;
        } if (bunny.position.y > maxY) {
          bunny.speed.y *= -0.8;
          bunny.position.y = maxY;
          if (Math.random() > 0.5) bunny.speed.y -= 3 + Math.random() * 4;
        }  else if (bunny.position.y < minY) {
          bunny.speed.y = 0;
          bunny.position.y = minY;
        }	

      }
    }
  }
}

class Rabbit extends Sprite {
  public var speed:prime.Point = new prime.Point();

  public function new(){
    super(Assets.images.rabbit);
  }
}

class Counter extends Actor {
  public var font:Font;
  public var count:Int = 0;
  public var fps:Float = 0;
  public var ms:Float = 0;
  private var text:Text = new Text("", null);

  override function render(r:Renderer) : Void {
    super.render(r);
    r.color = Color.Cyan;
    r.fillRect(0, 0, 300, 30);
    //r.fillCircle(0, 0, 30);

    if(font != null){
      text.font = font;
      text.size = 26;
      text.tint = Color.Red;
      //r.color = Color.Red;
      //r.font = font;
      //r.fontSize = 26;
      //r.drawString("Obj: " + count + " - MS: " + ms + " - FPS: " + fps, 5, 0);
      text.text = "Obj: " + count + " - MS: " + ms + " - FPS: " + fps;
      r.renderActor(text);
    }
  }
}