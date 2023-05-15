import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '../../Utils/GameMods.dart';
import '../../Utils/styles.dart';
import '/Utils/GameManager.dart';

class HostWaitMenu extends StatefulWidget {
  final String message;
  const HostWaitMenu({super.key, required this.message});

  @override
  State<HostWaitMenu> createState() => _HostWaitMenuState();
}

class _HostWaitMenuState extends State<HostWaitMenu>
    with WidgetsBindingObserver {

  var btState = "t'as pas appuié";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "And the winner is "+ GameManager.instance!.getLastWinner().toString() + " !",
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              " " + GameManager.instance!.getLastWinner().toString() + " !",
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Text(widget.message),
            Text(
              GameManager.instance!.tournamentManager.running ? 'click next to go the next game in tournament!' : 'click next to choose the next game !'  ,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),

            ),
            Text(
              "Scores " + GameManager.instance!.scores.toString(),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.green),
              onPressed: () {

                if(GameManager.instance!.gameMode == GameMode.Multi && GameManager.instance!.wifiP2PInfo!.isGroupOwner){

                  GameManager.instance!.sendPlayers();
                }
                if (GameManager.instance!.tournamentManager.running)
                {

                  GameManager.instance!.tournamentManager.NextGame();
                }else{

                  NavigationService.instance.navigateToReplacement('GAMES');
                }

              },
              child: const Text('Next'),
            ),
            Text(
              ""
            ),
            if (GameManager.instance!.tournamentManager.running)
              ElevatedButton(
                style: Style.getBtnStyleROUNDED(Colors.purple),
                onPressed: () {
                  GameManager.instance!.tournamentManager.stopTournament();
                },
                child: const Text('Exit Tournament'),
              ),
          ],
        ),
      ),
    );
  }
}
