import 'Vector2D.dart';

class Transform {
  Vector2D position;
  Vector2D scale;
  double rotation;
  Transform.zero() : this(Vector2D.zero(), Vector2D.zero(), 0);
  Transform(this.position, this.scale, this.rotation);

  @override
  String toString() {
    return 'Transform{position: $position, scale: $scale, rotation: $rotation}';
  }

}
