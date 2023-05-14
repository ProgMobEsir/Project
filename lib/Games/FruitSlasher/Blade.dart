import 'package:wifi_direct_json/Games/FruitSlasher/Particle.dart';
import '../../GameEngine/GameObject.dart';
import '../../Utils/GameManager.dart';

class Blade extends GameObject {
  String name = "a";
  int life = 10;
  int score = 0;

  Blade(x, y, this.name){
    transform.scale.x = 50;
    transform.scale.y = 50;
    renderer.color = GameManager.instance!.playerColor;
  }

  void particles() {
    double centerx = transform.position.x + transform.scale.x / 2;
    double centery = transform.position.y + transform.scale.y / 2;
    for (int i = 0; i < 5; i++) {
      Particle particle = new Particle(
          centerx,
          centery,
          this.name);
      particle.renderer.color = this.renderer.color;
      engine!.addGameObject(particle);
    }

  }


}
