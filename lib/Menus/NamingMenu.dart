import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Utils/Requests/NewPeerNameRequest.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';

import '/Utils/GameManager.dart';

class NamingMenu extends StatefulWidget {
  const NamingMenu({super.key});

  @override
  State<NamingMenu> createState() => _NamingMenuState();
}

class _NamingMenuState extends State<NamingMenu> with WidgetsBindingObserver {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    GameManager.instance!.resetPlayers();
    GameManager.instance!.manageScores();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter a name to play in multiplayer ! ',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            TextField(
              controller: myController,
            ),
            ElevatedButton(
                onPressed: () {
                  GameManager.instance!.playerName = myController.text;

                  if (GameManager.instance?.wifiP2PInfo?.isGroupOwner == true) {
                    GameManager.instance!.players.add(myController.text);

                    NavigationService.instance
                        .navigateToReplacement('WAIT_PLAYERS');
                  } else {
                    GameManager.instance!.sendJsonRequest(
                        new NewPeerNameRequest(
                            GameManager.instance!.playerName));
                    NavigationService.instance
                        .navigateToReplacement('WAIT_GUEST');
                  }
                },
                child: Text('Choose')),
          ],
        ),
      ),
    );
  }
}
