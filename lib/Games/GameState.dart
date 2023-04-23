import 'package:flutter/cupertino.dart';
import '/Utils/Reciever.dart';

import '/Utils/GameManager.dart';

class GameState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver, Reciever {
  String name = "game";

  @override
  void initState() {
    super.initState();
    GameManager.instance!.subscribe(this);
    print("subscribed");
  }

  @override
  void dispose() {
    super.dispose();
    GameManager.instance!.unsubscribe(this);
    print("unsubscribed");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  void send(String req) {
    GameManager.instance!.sendMessage(req);
  }

  @override
  void onRecieve(req) {
    setState(() {});
  }
}
