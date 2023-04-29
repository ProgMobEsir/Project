import 'package:wifi_direct_json/Utils/GameManager.dart';
import '/Utils/Reciever.dart';
import 'GameObject.dart';

class TrackedGameObject extends GameObject with Reciever {
  var data;
  TrackedGameObject(x, y) {
    transform.position.x = x;
    transform.position.y = y;
  }

  void update() {
    GameManager.instance!.sendMessage(transform.position.x.toString() +
        " " +
        transform.position.y.toString());
  }

  @override
  void onRecieve(req) {
    // TODO: implement onRecieve
    super.onRecieve(req);
    data = req;
  }

}
