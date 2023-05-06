import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Games/DragGame/DragGame.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '../Utils/Requests/JsonRequest.dart';
import 'HomePage.dart';
import 'package:wifi_direct_json/Games/SimonGame/SuperSimon.dart';

import '/Utils/GameManager.dart';

class GameMenu extends StatefulWidget {
  const GameMenu({super.key});

  @override
  State<GameMenu> createState() => GameMenuState();
}

class GameMenuState extends State<GameMenu> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        //add a button to the home page :
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
        ],
        title: const Text('Game Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            const Text(
              'Click on a game to start it !',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Divider(),
            Padding(padding: const EdgeInsets.all(10)),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () async {
                var randomGameName = "";
                var random = Random().nextInt(2);
                print(random);
                if (random == 0) {
                  randomGameName = "SIMON";
                } else {
                  randomGameName = "DRAG";
                }
                //random game
                GameManager.instance!.sendJsonRequest(
                    new JsonRequest("", "0", "GAME", randomGameName));

                NavigationService.instance
                    .navigateToReplacement("GAME_" + randomGameName);
              },
              child: const Text("Ramdom Game"), //automatic in games
            ),
            ElevatedButton(
              onPressed: () {
                GameManager.instance!
                    .sendJsonRequest(new JsonRequest("", "0", "GAME", "SIMON"));

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuperSimon(),
                  ),
                );
              },
              child: const Text("Game Simon"),
            ),
            ElevatedButton(
              onPressed: () {
                GameManager.instance!
                    .sendJsonRequest(new JsonRequest("", "0", "GAME", "DRAG"));

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DragGame(),
                  ),
                );
              },
              child: const Text("Game Drag"),
            ),
          ],
        ),
      ),
    );
  }

  void snack(String msg) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          msg,
        ),
      ),
    );
  }
}
