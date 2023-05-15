import 'package:flutter/material.dart';
import '../Utils/styles.dart';
import 'ClientMenu.dart';
import 'HostMenu.dart';
import 'HomePage.dart';
import '/Utils/GameManager.dart';

class ConnPage extends StatefulWidget {
  const ConnPage({super.key});

  @override
  State<ConnPage> createState() => ConnPageState();
}

class ConnPageState extends State<ConnPage> with WidgetsBindingObserver {
  final TextEditingController msgText = TextEditingController();

  @override
  void initState() {
    if (GameManager.instance?.flutterP2pConnectionPlugin == null) {
      throw Exception('flutterP2pConnectionPlugin is null');
    }
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber.shade100,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          //add a button to the home page :
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
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
          title: const Text('Connect or create a group'),
        ),
        //add padding to the left of this box

        body: SingleChildScrollView(
              child: Padding(
    padding: EdgeInsets.all(10),
    child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.only(top: 20)),
                  const SizedBox(height: 10),
                  Padding(padding: const EdgeInsets.only(top: 20)),
                  DetailedCard(MenuName: "HOST", Title: "Be The Host", subTitle: "Create a game room for the other to join", BgColor1: Colors.pink, BgColor2: Colors.pink.shade50),

                  Padding(padding: const EdgeInsets.only(top: 20)),
                  DetailedCard(MenuName: "CLIENT", Title: "Be a guest", subTitle: "Join a game room already created by a host", BgColor1: Colors.pink.shade50, BgColor2: Colors.pink),

                ],
              ),

              ),
        ));
  }
}
