import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ImageLibrary{
  static ImageLibrary instance = ImageLibrary();

var  imagesAssets = {};

  Future<ui.Image> loadImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    return await decodeImageFromList(bytes);
  }


Future<void> loadAsset() async {
  imagesAssets["default"] = await loadImage("assets/images/default.PNG");
  imagesAssets["food"] = await loadImage("assets/images/coin.PNG");
  imagesAssets["blade"] = await loadImage("assets/images/blade.png");
  imagesAssets["banane"] = await loadImage("assets/images/banane.png");
  imagesAssets["bomb"] = await loadImage("assets/images/bomb.png");
}

ui.Image getAsset(String name){
  print(imagesAssets);
  return imagesAssets[name];
}

  ImageLibrary(){
    print("loading assets");
    loadAsset();
  }

  ImageLibrary getInstance(){
    return instance;
  }
}