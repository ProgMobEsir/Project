import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import 'package:wifi_direct_json/GameEngine/Vector2D.dart';
import 'package:wifi_direct_json/GameEngine/colliders/RectCollider.dart';
import 'package:wifi_direct_json/GameEngine/shapes/Circle.dart';
import 'package:wifi_direct_json/Games/MultiplayerShooterGame/ISoldier.dart';

class Bullet extends GameObject {
  static var list = [];
  var speed = 15;
  var life = 0;
  var maxLife = 10;
  String owner = "";
  Vector2D direction = new Vector2D(0, 0);

  Bullet(x, y, direction, this.owner) {
    list.add(this);
    renderer = new Circle(this, 10);
    this.direction = direction.normalized;
    transform.position.x = x;
    transform.position.y = y;
    transform.scale.x = 50;
    transform.scale.y = 50;
  }
  @override
  void update() {
    transform.position += direction * speed.toDouble();
    life++;
    if (life > maxLife) {
      list.remove(this);
      destroy();
    }
  }

  bool isCollidingPlayer(ISoldier s) {
    return (s.collider.isCollidingRectCollider(this.collider as RectCollider) &&
        s.name != this.owner);
  }
}
