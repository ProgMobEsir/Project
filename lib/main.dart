import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Games/DragGame/DragGame.dart';
import 'package:wifi_direct_json/Games/SimonGame/SuperSimon.dart';
import 'package:wifi_direct_json/Menus/SettingsMenu.dart';
import 'package:wifi_direct_json/Menus/WaitsMenus/GuestWaitMenu.dart';
import 'package:wifi_direct_json/Menus/WaitsMenus/HostWaitMenu.dart'
    as hostWaitMenu;
import '/Menus/HomePage.dart';
import 'Menus/ClientMenu.dart';
import 'Menus/GameMenu.dart';
import 'navigation/NavigationService.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.instance.navigationKey,
      home: HomePage(),
      routes: {
        "GAME_SIMON": (BuildContext context) => SuperSimon(),
        "HOME": (BuildContext context) => HomePage(),
        "CLIENT": (BuildContext context) => ClientMenu(),
        "GAME_DRAG": (BuildContext context) => DragGame(),
        "GAMES": (BuildContext context) => GameMenu(),
        "WAIT_GUEST": (BuildContext context) => GuestWaitMenu(
            message: "Waiting for the host to choose the next game !"),
        "WAIT_HOST": (BuildContext context) => hostWaitMenu.HostWaitMenu(
            message: "Waiting for the host to choose the next game !"),
        "SETTINGS": (BuildContext context) => SettingsMenu(),
      },
    );
  }
}

class HostWaitMenu {}
