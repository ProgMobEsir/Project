import 'package:wifi_direct_json/GameEngine/GameObject.dart';


class MapBorder extends GameObject {

  MapBorder(x, y, w, h) {
    transform.position.x = x;
    transform.position.y = y;
    transform.scale.x = w;
    transform.scale.y = h;
  }
}
