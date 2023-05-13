import 'dart:ui';
import 'package:wifi_direct_json/GameEngine/Camera.dart';
import 'package:wifi_direct_json/GameEngine/Vector2D.dart';

import 'Renderer.dart';

class LineRenderer extends Renderer {
  Vector2D p1 = new Vector2D(0, 0);
  Vector2D p2 = new Vector2D(0, 0);

  LineRenderer(parent, Vector2D p1, Vector2D p2)
      : super(parent, new Color(0xFF0000FF)) {}

  bool draw(Canvas canvas, Paint paint) {
    paint.color = this.color;

    canvas.drawLine(Offset(p1.x - Camera.dx, p1.y - Camera.dy),
        Offset(p2.x - Camera.dx, p2.y - Camera.dy), paint);
    return true;
  }
}
