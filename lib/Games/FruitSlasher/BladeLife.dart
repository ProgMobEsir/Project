import 'dart:ui';

import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import 'package:wifi_direct_json/GameEngine/shapes/Rectangle.dart';
import 'Blade.dart';

class BladeLife extends GameObject {
  Blade? p;
  BladeLife(this.p) {
    this.renderer = new Rectangle(
      this,
    );
    renderer.color =  Color.fromARGB(255, 0, 255, 0);
    transform.position.x = p!.transform.position.x;
    transform.position.y = p!.transform.position.y;
    transform.scale.y = 20;
  }

  @override
  void update() {
    super.update();

    if (p!.life > 5){
      renderer.color =  Color.fromARGB(255, 0, 255, 0);
    } else if (p!.life > 2){
      renderer.color =  Color.fromARGB(255, 255, 255, 0);
    } else {
      renderer.color =  Color.fromARGB(255, 255, 0, 0);
    }

    transform.position.x = p!.transform.position.x;
    transform.position.y = p!.transform.position.y -20;
    transform.scale.x = p!.life.toDouble() * 5;
    if (p!.life <= 0) {
      destroy();
    }
  }
}
