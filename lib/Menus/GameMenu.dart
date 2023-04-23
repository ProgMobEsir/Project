import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Games/DragGame.dart';
import 'HomePage.dart';
import 'package:wifi_direct_json/Games/SuperSimon.dart';

import '/Utils/GameManager.dart';

class GameMenu extends StatefulWidget {
  const GameMenu({super.key});

  @override
  State<GameMenu> createState() => GameMenuState();
}

class GameMenuState extends State<GameMenu> with WidgetsBindingObserver {
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
                GameManager.instance!.sendMessage("START GAME 1 2 6");
              },
              child: const Text("START GAME"), //automatic in games
            ),
            ElevatedButton(
              onPressed: () {
                GameManager.instance!.sendMessage("GAME SIMON");

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
                GameManager.instance!.sendMessage("GAME DRAG");

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
