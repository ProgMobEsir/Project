import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Games/SuperSimon.dart';
import '/Menus/HomePage.dart';
import 'Menus/ClientMenu.dart';
import 'navigation/NavigationService.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(

      navigatorKey: NavigationService.instance.navigationKey,
      home: HomePage(),
      routes: {
      "GAME_SIMON":(BuildContext context) =>SuperSimon(),
      "HOME":(BuildContext context) =>HomePage(),
      "CLIENT":(BuildContext context) => ClientMenu(),

  },
    );
  }
}
