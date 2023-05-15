import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wifi_direct_json/Menus/LeaderboardMenu.dart';
import 'package:wifi_direct_json/Utils/AudioManager.dart';
import 'package:wifi_direct_json/Utils/ImageLibrary.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '../Utils/styles.dart';
import 'ConnPage.dart';
import '/Utils/GameMods.dart';
import '/Utils/GameManager.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    AudioManager.getInstance().playMusic("win.mp3");
    GameManager.instance!.fileManager.loadScoresToGameManager();
    ImageLibrary.instance;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/PeerGameLogo.png'),
              width: 200, // Set the desired width

              fit: BoxFit.cover,
            ),
            const Text(
              'Peer Games',
              //generate a line to add padding to the text
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DIN Alternate',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'By Peer Games Studio',
              //generate a line to add padding to the text
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DIN Alternate',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            //la on met du padding
            const Padding(padding: EdgeInsets.all(40)),
            //et la un bouton de play
            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.green.shade200 ),
              onPressed: () async {
                bool? removed = await GameManager
                    .instance?.flutterP2pConnectionPlugin
                    .removeGroup(); //3

                    await GameManager.instance?.closeSocketConnection();

                GameManager.instance!.gameMode = GameMode.Solo;
                NavigationService.instance.navigateToReplacement("GAMES");
              },
              child: const Text('Solo'),
            ),
            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.purple.shade200),
              onPressed: () {
                GameManager.instance!.gameMode = GameMode.Multi;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConnPage(),
                  ),
                );
              },
              child: const Text('Multiplayer'),
            ),
            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.blue.shade200),
              onPressed: () {
                GameManager.instance!.gameMode = GameMode.Multi;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeaderboardMenu(),
                  ),
                );
              },
              child: const Text('Leaderboard'),
            ),
            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.black12),
              onPressed: () {
                NavigationService.instance.navigateToReplacement("SETTINGS");
              },
              child: const Text('Settings'),
            ),
            if (GameManager.instance!.gameMode == GameMode.Multi && GameManager.instance!.wifiP2PInfo?.isGroupOwner == true)
              ElevatedButton(
                style: Style.getBtnStyleROUNDED(Colors.pink),
                onPressed: () {
                  NavigationService.instance.navigateToReplacement("GAMES");
                },
                child: const Text('Continue your multiplayer game'),
              ),
          ],
        ),
      ),
    );
  }
}
