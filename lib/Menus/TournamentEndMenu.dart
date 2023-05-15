import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '../Utils/styles.dart';
import '/Utils/GameManager.dart';

class TournamentEndMenu extends StatefulWidget {
  const TournamentEndMenu({super.key});

  @override
  State<TournamentEndMenu> createState() => TournamentEndMenuState();
}

class TournamentEndMenuState extends State<TournamentEndMenu>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(padding: EdgeInsets.all(50.0)),
              const Text(
                'Congratulation for this tournament !',
                //generate a line to add padding to the text
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const Text(
                'You played these games :',
                //generate a line to add padding to the text
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Container(
                height: 200, // set a fixed or maximum height for the ListView.builder
                child: Scrollbar(
                  thickness: 10,
                  radius: Radius.circular(20),
                  child: ListView.builder(
                    itemCount: GameManager.instance!.tournamentManager.games.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(GameManager.instance!.tournamentManager.games[index]),
                      );
                    },
                  ),
                ),
              ),
              Text(
                GameManager.instance!.tournamentManager.games.toString(),
                textAlign: TextAlign.center,
              ),
              Text(
                "The Scores" + GameManager.instance!.scores.toString(),
                textAlign: TextAlign.center,
              ),
              Text(
                "And the Winner is " + GameManager.instance!.tournamentManager.winner + "!",
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                style : Style.getBtnStyleROUNDED(Colors.blueGrey),
                onPressed: () {
                  NavigationService.instance.navigateToReplacement('GAMES');
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
