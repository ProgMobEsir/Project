import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import 'package:wifi_direct_json/GameEngine/shapes/Rectangle.dart';
import 'ISoldier.dart';

class LifeBar extends GameObject {
  ISoldier? p;

  LifeBar(this.p) {
    this.renderer = new Rectangle(
      this,
    );
    transform.position.x = p!.transform.position.x;
    transform.position.y = p!.transform.position.y;
    transform.scale.y = 20;
  }

  @override
  void update() {
    // TODO: implement update
    super.update();
    transform.position.x = p!.transform.position.x;
    transform.position.y = p!.transform.position.y + 20;
    transform.scale.x = p!.life.toDouble() * 2;
  }
}
