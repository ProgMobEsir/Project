import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import 'package:wifi_direct_json/GameEngine/shapes/TextRenderer.dart';
import 'ISoldier.dart';

class PlayerTag extends GameObject {
  ISoldier? p;

  PlayerTag(this.p) {
    this.renderer = new TextRenderer(this, this.p!.name, 10);
    transform.position.x = p!.transform.position.x;
    transform.position.y = p!.transform.position.y;
  }

  @override
  void update() {
    // TODO: implement update
    super.update();
    transform.position.x = p!.transform.position.x;
    transform.position.y = p!.transform.position.y;
  }
}
