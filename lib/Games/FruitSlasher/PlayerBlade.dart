import 'package:wifi_direct_json/GameEngine/shapes/ImageRenderer.dart';
import '../../Utils/GameManager.dart';
import 'Blade.dart';

class PlayerBlade extends Blade {
  PlayerBlade(x, y, name) : super(x, y, name) {
    renderer = new ImageRenderer(this, "blade");
    renderer.color = GameManager.instance!.playerColor;
  }

}
