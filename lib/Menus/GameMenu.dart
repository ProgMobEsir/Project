import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Games/Accel/AccelGame.dart';
import 'package:wifi_direct_json/Games/DragGame/DragGame.dart';
import 'package:wifi_direct_json/Games/FruitSlasher/FruitSlasher.dart';
import 'package:wifi_direct_json/Games/Quizz/QuizzGame.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '../Games/MultiplayerShooterGame/ShooterGame.dart';
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
        backgroundColor: Colors.blueGrey,
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
                    new JsonRequest("", "GAME", randomGameName));

                NavigationService.instance
                    .navigateToReplacement("GAME_" + randomGameName);
              },
              child: const Text("Ramdom Game"), //automatic in games
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.purple),
              ),
              onPressed: () async {

                NavigationService.instance
                    .navigateToReplacement("GAME_TOURNAMENT");
              },
              child: const Text("Game Tournament "), //automatic in games
            ),
            ElevatedButton(
              onPressed: () {
                GameManager.instance!
                    .sendJsonRequest(new JsonRequest("", "GAME", "SIMON"));

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SuperSimon(),
                  ),
                );
              },
              child: const Text("Simon"),
            ),
            ElevatedButton(
              onPressed: () {
                GameManager.instance!
                    .sendJsonRequest(new JsonRequest("", "GAME", "DRAG"));

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DragGame(),
                  ),
                );
              },
              child: const Text("food quest"),
            ),
            ElevatedButton(
              onPressed: () {
                GameManager.instance!
                    .sendJsonRequest(new JsonRequest("", "GAME", "ACCEL"));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccelGame(),
                  ),
                );
              },
              child: const Text("Bubble rush"),
            ),
            ElevatedButton(
              onPressed: () {
                GameManager.instance!
                    .sendJsonRequest(new JsonRequest("", "GAME", "QUIZZ"));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizzGame(),
                  ),
                );
              },
              child: const Text("Quizz"),
            ),
            ElevatedButton(
              onPressed: () {
                GameManager.instance!
                    .sendJsonRequest(new JsonRequest("", "GAME", "SHOOTER"));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShooterGame(),
                  ),
                );
              },
              child: const Text("Multiplayer Shooter"),
            ),
            ElevatedButton(
              onPressed: () {
                GameManager.instance!
                    .sendJsonRequest(new JsonRequest("", "GAME", "FRUIT"));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FruitSlasherGame(),
                  ),
                );
              },
              child: const Text("Multiplayer Fruit Slasher"),
            ),
            if (GameManager.instance!.tournamentManager.running)
              ElevatedButton(
                onPressed: () {
                  GameManager.instance!.tournamentManager.stopTournament();
                  setState(() {

                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                ),
                child: const Text('Exit Tournament'),
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
