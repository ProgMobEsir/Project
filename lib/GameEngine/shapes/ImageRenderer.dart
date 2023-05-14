import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Utils/ImageLibrary.dart';
import '../Camera.dart';
import 'Renderer.dart';

class ImageRenderer extends Renderer {
  String name;
  ui.Image img = ImageLibrary.instance.getAsset("default");

  ImageRenderer(parent, this.name) : super(parent, new Color(0xFF0000FF)) {
    img = ImageLibrary.instance.getAsset(this.name);
  }

  Future<bool> draw(Canvas canvas, Paint paint) async {
  paint.color = this.color;

  // Calculate the destination rectangle based on the parent's transform
  final destRect = Rect.fromLTWH(
    parent!.transform.position.x -  Camera.dx,
    parent!.transform.position.y - Camera.dy,
    parent!.transform.scale.x,
    parent!.transform.scale.y,
  );

  canvas.drawImageRect(
    img,
    Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
    destRect,
    paint,
  );

  return true;
  }
}
