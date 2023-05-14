import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '../Utils/AudioManager.dart';
import '../Utils/GameManager.dart';

class GameTourMenu extends StatefulWidget {
  const GameTourMenu({super.key});

  @override
  State<GameTourMenu> createState() => GameTourMenuState();
}

class GameTourMenuState extends State<GameTourMenu> with WidgetsBindingObserver {
  int numberOfGames= 3 ;
  final myController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              NavigationService.instance.navigateToReplacement('GAMES');
            },
          ),
        ],
        title: const Text('Tournament Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Select the number of game you want in your tournament ! ',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            //la on met du padding
            const Padding(padding: EdgeInsets.all(100)),
            //et la un bouton de play
            Slider(
              value: numberOfGames.toDouble(),
              max:6,
              min:2,
              divisions: 4,
              label: numberOfGames.round().toString(),
              onChanged: (double value) {
                setState(() {
                  numberOfGames = value.toInt();
                });
              },
            ),
            ElevatedButton(onPressed: (){
              GameManager.instance!.getTournamentManager().init(numberOfGames);
              print("tournament started");
            }, child: Text('Start the tournament !'))
          ],
        ),
      ),
    );
  }
}
