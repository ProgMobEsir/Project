import 'dart:ui';
import 'Renderer.dart';

class Rectangle extends Renderer {
  double dx;
  double dy;

  Rectangle(parent, this.dx, this.dy) : super(parent, new Color(0xFF0000FF)) {}

  Rectangle.withColor(parent, this.dx, this.dy, Color color)
      : super(parent, color) {}

  bool contains(int x, int y) {
    return x + dx > this.parent!.transform.position.x &&
        x < this.parent!.transform.position.x + dx &&
        y + dy > this.parent!.transform.position.y &&
        y < this.parent!.transform.position.y + dy;
  }

  @override
  bool intersectsRectangle(Rectangle other) {
    return parent!.transform.position.x + dx >
            other.parent!.transform.position.x &&
        parent!.transform.position.x <
            other.parent!.transform.position.x + other.dx &&
        parent!.transform.position.y + dy >
            other.parent!.transform.position.y &&
        parent!.transform.position.y <
            other.parent!.transform.position.y + other.dy;
  }

  bool draw(Canvas canvas, Paint paint) {
    paint.color = this.color;

    canvas.drawRect(
        Rect.fromLTWH(parent!.transform.position.x.toDouble(),
            parent!.transform.position.y.toDouble(), dx, dy),
        paint);
    return true;
  }
}
