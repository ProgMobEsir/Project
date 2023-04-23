import 'dart:ui';

import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import 'package:wifi_direct_json/GameEngine/shapes/Rectangle.dart';

class Food extends GameObject {
  Food(x, y) {
    transform.position.x = x;
    transform.position.y = y;

    renderer = new Rectangle(this, 10, 10);
    renderer.color = Color.fromARGB(255, 145, 28, 20);
  }
  // ...
  void update() {
    // ...
  }
}
