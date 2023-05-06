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
  //put ui.Images from assets folder of flutter app loaded into the imagesAssets map with a name as key
  imagesAssets["default"] = await loadImage("assets/images/default.PNG");
  imagesAssets["food"] = await loadImage("assets/images/coin.PNG");
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