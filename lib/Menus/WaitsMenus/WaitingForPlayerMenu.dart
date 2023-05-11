import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '/Utils/GameManager.dart';

class WaitingForPlayerMenu extends StatefulWidget {
  const WaitingForPlayerMenu({super.key});

  @override
  State<WaitingForPlayerMenu> createState() => _WaitingForPlayerMenuState();
}

class _WaitingForPlayerMenuState extends State<WaitingForPlayerMenu>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'click next to choose the next game !',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Players :" + GameManager.instance!.players.toString(),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});

                GameManager.instance!.manageScores();
                
              },
              child: const Text('ReloadPlayerList'),
            ),
            ElevatedButton(
              onPressed: () {
                NavigationService.instance.navigateToReplacement('GAMES');
                GameManager.instance!.manageScores();
              },
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}