import '../../GameEngine/GameObject.dart';
import '../../GameEngine/shapes/TextRenderer.dart';
import 'Blade.dart';

class BladeTag extends GameObject {
  Blade? b;

  BladeTag(this.b) {
    this.renderer = new TextRenderer(this, this.b!.name, 10);
    transform.position.x = b!.transform.position.x;
    transform.position.y = b!.transform.position.y;
  }

  @override
  void update() {
    super.update();
    transform.position.x = b!.transform.position.x;
    transform.position.y = b!.transform.position.y;
    if (b!.life <= 0) {
      destroy();
    }
  }
}