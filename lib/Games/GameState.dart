import 'dart:async';

import 'package:flutter/cupertino.dart';
import '../GameEngine/Engine.dart';
import '/Utils/Reciever.dart';

import '/Utils/GameManager.dart';

class GameState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver, Reciever {
  GameEngine engine = GameEngine();

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      Mupdate();
    });
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

  void Mupdate() {
    if (mounted) setState(() {});
    update();
  }

  void update() {}
}
