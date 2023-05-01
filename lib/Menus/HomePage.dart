import 'package:flutter/material.dart';
import 'GameMenu.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the best P2P game app ever!',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            //la on met du padding
            const Padding(padding: EdgeInsets.all(100)),
            //et la un bouton de play
            ElevatedButton(
              onPressed: () {
                GameManager.instance!.gameMode = GameMode.Solo;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameMenu(),
                  ),
                );
              },
              child: const Text('Play Solo'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConnPage(),
                  ),
                );
              },
              child: const Text('Play multiplayer'),
            ),
          ],
        ),
      ),
    );
  }
}