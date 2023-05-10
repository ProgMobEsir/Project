import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Utils/AudioManager.dart';
import 'package:wifi_direct_json/Utils/ImageLibrary.dart';
import 'package:wifi_direct_json/Utils/Requests/NewPeerNameRequest.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import 'GameMenu.dart';
import 'ConnPage.dart';
import '/Utils/GameMods.dart';
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
