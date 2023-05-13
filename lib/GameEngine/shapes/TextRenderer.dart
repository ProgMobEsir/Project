import 'dart:ui';
import 'package:wifi_direct_json/GameEngine/Camera.dart';

import 'Renderer.dart';

class TextRenderer extends Renderer {
  String text = "";
  double fontSize = 10;
  Paragraph? paragraph;

  TextRenderer(parent, this.text, this.fontSize)
      : super(parent, Color.fromARGB(255, 0, 0, 0)) {
    print("init text renderer");
    paragraph = getTextBuilder(text, fontSize, this.color);
  }

  bool draw(Canvas canvas, Paint paint) {
    paint.color = this.color;
    canvas.drawParagraph(
        paragraph!,
        Offset(parent!.transform.position.x.toDouble() - Camera.dx,
            parent!.transform.position.y.toDouble() - Camera.dy));
    return true;
  }

  void setText(String newText) {
    text = newText;
    _createParagraph();
  }

  void _createParagraph() {
    if (text.isNotEmpty) {
      paragraph = getTextBuilder(text, 18, this.color);
    }
  }

  Paragraph getTextBuilder(String text, double textFont, Color color) {
    Paint paint = Paint();
    paint.color = Color.fromARGB(100, 255, 255, 255);
    var builder = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 18,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    ));
    builder.pushStyle(
      TextStyle(
          color: color,
          textBaseline: TextBaseline.alphabetic,
          background: paint),
    );
    builder.addText(text);
    Paragraph paragraph = builder.build();
    paragraph.layout(ParagraphConstraints(width: 100));

    return paragraph;
  }
}
