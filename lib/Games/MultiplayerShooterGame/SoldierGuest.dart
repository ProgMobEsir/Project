import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import 'package:wifi_direct_json/Games/MultiplayerShooterGame/ISoldier.dart';

import '../../GameEngine/Camera.dart';

class SoldierGuest extends ISoldier {

  GameObject cible = new GameObject();

  SoldierGuest(super.x, super.y, super.name);

  void update() {}
}
