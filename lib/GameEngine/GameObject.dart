import 'package:wifi_direct_json/GameEngine/colliders/RectCollider.dart';
import 'package:wifi_direct_json/GameEngine/transform.dart';
import 'Vector2D.dart';
import 'colliders/collider.dart';
import 'shapes/Renderer.dart';
import 'package:wifi_direct_json/GameEngine/shapes/Rectangle.dart';

class GameObject {
  bool destroy_ = false;

  Transform transform =
      new Transform(new Vector2D(0, 0), new Vector2D(1, 1), 0);

  Renderer renderer = new Rectangle(null);

  Collider collider = new RectCollider(null);

  GameObject() {
    renderer = new Rectangle(this);
    collider = new RectCollider(this);
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
