import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import 'package:wifi_direct_json/GameEngine/shapes/Rectangle.dart';

class Player extends GameObject {
  Player(x,y) {
    transform.position.x = x;
    transform.position.y = y;
    renderer = new Rectangle(this, 100, 100);
  }
  // ...
  void update() {
    // ...
  }
}
