import 'package:wifi_direct_json/GameEngine/transform.dart';
import 'Vector2D.dart';
import 'shapes/Renderer.dart';
import 'package:wifi_direct_json/GameEngine/shapes/Rectangle.dart';

class GameObject {
  bool destroy_ = false;

  Transform transform =
      new Transform(new Vector2D(0, 0), new Vector2D(1, 1), 0);

  Renderer renderer = new Rectangle(null, 100, 100);

  GameObject() {
    renderer = new Rectangle(this, 100, 100);
  }

  Renderer getRenderer() {
    return renderer;
  }

  destroy() {
    destroy_ = true;
  }

  // ...
  void update() {
    // ...
  }
}
