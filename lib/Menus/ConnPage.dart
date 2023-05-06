import 'package:flutter/material.dart';
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
        appBar: AppBar(
          backgroundColor: Colors.amber,
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
            padding: const EdgeInsets.only(left: 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.only(top: 20)),
                  Text(
                      "IP: ${GameManager.instance!.wifiP2PInfo == null ? "null" : GameManager.instance!.wifiP2PInfo?.groupOwnerAddress}"),
                  GameManager.instance!.wifiP2PInfo != null
                      ? Text(
                          "connected: ${GameManager.instance!.wifiP2PInfo?.isConnected}, isGroupOwner: ${GameManager.instance!.wifiP2PInfo?.isGroupOwner}, groupFormed: ${GameManager.instance!.wifiP2PInfo?.groupFormed}, groupOwnerAddress: ${GameManager.instance!.wifiP2PInfo?.groupOwnerAddress}, clients: ${GameManager.instance!.wifiP2PInfo?.clients}")
                      : const SizedBox.shrink(),
                  const SizedBox(height: 10),
                  Padding(padding: const EdgeInsets.only(top: 20)),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClientMenu(),
                        ),
                      );
                    },
                    child: const Text("Play as a guest"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HostMenu(),
                        ),
                      );
                    },
                    child: const Text("Play as Host"),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 20)),
                ],
              ),
            ),
          ),
        ));
  }
}
