import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '../Utils/GameManager.dart';
import '../Utils/styles.dart';

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
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        backgroundColor:Colors.white.withOpacity(0.5),
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
             Text(
              "You will play " + numberOfGames.toString() + " games",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            Slider(
              activeColor: Colors.purple,
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
            const Padding(padding: EdgeInsets.all(50)),
            ElevatedButton(
                style: Style.getBtnStyleROUNDED(Colors.purple.shade200),
                onPressed: (){
              
              GameManager.instance!.getTournamentManager().init(numberOfGames);
              print("tournament started");
            }, child: Padding(padding: EdgeInsets.all(10),
            child:Text('Start the tournament !'))),
          ],
        ),
      ),
    );
  }
}
