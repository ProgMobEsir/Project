import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '../Utils/Requests/JsonRequest.dart';
import '../Utils/styles.dart';
import 'HomePage.dart';
import '/Utils/GameManager.dart';

class GameMenuV2 extends StatefulWidget {
  const GameMenuV2({super.key});

  @override
  State<GameMenuV2> createState() => GameMenuV2State();
}

class GameMenuV2State extends State<GameMenuV2> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.5),
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
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Text(
              'Game collection',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            Padding(padding: const EdgeInsets.all(10)),
            DetailedCard(
              MenuName:"GAME_TOURNAMENT",
              Title:"Tournament",
              subTitle: "Play a random serie of games in a row ! ",
              BgColor1:Colors.purple.shade200,
              BgColor2:Colors.pink,

            ),

            Divider(),
            Padding(padding: const EdgeInsets.all(10)),
            GameCard(gameName:"SIMON",Title:"Simon",subTitle: "Play this old game as you never did before ! ",BgColor1:Colors.blue.shade200,BgColor2:Colors.red),
            Padding(padding: const EdgeInsets.all(10)),
            GameCard(gameName:"DRAG",Title:"Money quest",subTitle: "In a open map, chase 10 pieces and win this game ! ",BgColor1:Colors.blue.shade200,BgColor2:Colors.red),
            Padding(padding: const EdgeInsets.all(10)),
            GameCard(gameName:"ACCEL",Title:"Bubble rush",subTitle: "When the goal appear, be fast to rush it ! ",BgColor1:Colors.blue.shade200,BgColor2:Colors.red),
            Padding(padding: const EdgeInsets.all(10)),
            GameCard(gameName:"QUIZZ",Title:"Quizz",subTitle: "Let see if you have culture ! ",BgColor1:Colors.blue.shade200,BgColor2:Colors.red),
            Padding(padding: const EdgeInsets.all(10)),
            GameCard(gameName:"SHOOTER",Title:"Battle Game",subTitle: "Defeat all the player on the map to win ! ",BgColor1:Colors.blue.shade200,BgColor2:Colors.red),
            Padding(padding: const EdgeInsets.all(10)),
            GameCard(gameName:"FRUIT",Title:"Fruity Slasher",subTitle: "Cut the maximum of fruit before dying !",BgColor1:Colors.blue.shade200,BgColor2:Colors.red),
            Padding(padding: const EdgeInsets.all(10)),
            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.blue.shade200),
              onPressed: () async {
                var randomGameName = "";
                var random = Random().nextInt(6);
                randomGameName = GameManager.instance!.gameList[random].split("_")[1];
                GameManager.instance!.sendJsonRequest(
                    new JsonRequest("", "GAME", randomGameName));

                NavigationService.instance
                    .navigateToReplacement("GAME_" + randomGameName);
              },
              child: const Text("Ramdom Game"), //automatic in games
            ),
            Text("Comming soon...",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
            Padding(padding: const EdgeInsets.all(10)),
          ],
        ),
      ),),
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
