import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import '../../GameEngine/Vector2D.dart';
import 'bullet.dart';

class ISoldier extends GameObject {
  var speed = 5;
  int life = 10;
  String name = "";
  double aimx = 0.0;
  double aimy = 0.0;
  ISoldier(x, y, this.name) {
    this.aimx = 0.0;
    this.aimy = 0.0;
    transform.position.x = x;
    transform.position.y = y;
    transform.scale.x = 50;
    transform.scale.y = 50;
  }

  void shoot() {
    double centerx = transform.position.x + transform.scale.x / 2;
    double centery = transform.position.y + transform.scale.y / 2;
    Bullet bullet = new Bullet(
        centerx,
        centery,
        new Vector2D(
          this.aimx,
          this.aimy,
        ),
        this.name);
    engine!.addGameObject(bullet);
  }
}
