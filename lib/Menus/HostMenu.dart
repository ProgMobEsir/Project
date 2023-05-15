import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Menus/NamingMenu.dart';
import '../Utils/Requests/JsonRequest.dart';
import '../Utils/styles.dart';
import 'ConnPage.dart';
import '/Utils/GameManager.dart';

class HostMenu extends StatefulWidget {
  const HostMenu({super.key});

  @override
  State<HostMenu> createState() => HostMenuState();
}

class HostMenuState extends State<HostMenu> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        backgroundColor:Colors.white.withOpacity(0.5),
        //add a button to the home page :
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConnPage(),
                ),
              );
            },
          ),
        ],
        title: const Text('Host Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "IP: ${GameManager.instance!.wifiP2PInfo == null ? "null" : GameManager.instance!.wifiP2PInfo?.groupOwnerAddress}",
              textAlign: TextAlign.center,
            ),
            GameManager.instance!.wifiP2PInfo != null
                ? Text(
                    "connected: ${GameManager.instance!.wifiP2PInfo?.isConnected}, isGroupOwner: ${GameManager.instance!.wifiP2PInfo?.isGroupOwner}, groupFormed: ${GameManager.instance!.wifiP2PInfo?.groupFormed}, groupOwnerAddress: ${GameManager.instance!.wifiP2PInfo?.groupOwnerAddress}, clients: ${GameManager.instance!.wifiP2PInfo?.clients}",
                    textAlign: TextAlign.center,
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            const Text(
              'Create a room for other to join !',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            //la on met du padding
            const Padding(padding: EdgeInsets.all(20)),
            //et la un bouton de play
            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.green),
              onPressed: () {
                setState(() {});
                GameManager.instance!
                    .sendJsonRequest(new JsonRequest("", "MENU", "NAMING"));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NamingMenu(),
                  ),
                );
              },
              child: const Text("Start the game ! "),
            ),
            const Padding(padding: EdgeInsets.all(40)),
            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.green.shade300),
              onPressed: () async {
                setState(() {});
                bool? created = await GameManager
                    .instance?.flutterP2pConnectionPlugin
                    .createGroup(); // button

                snack("created group: $created");
              },
              child: const Text("create game room"),
            ),
            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.red),
              onPressed: () async {
                setState(() {});
                bool? removed = await GameManager
                    .instance?.flutterP2pConnectionPlugin
                    .removeGroup(); //3
                snack("removed group: $removed");
              },
              child: const Text("Leave Group"),
            ),
            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.blueGrey),
              onPressed: () async {
                setState(() {});
                var info = await GameManager
                    .instance?.flutterP2pConnectionPlugin
                    .groupInfo(); //button
                showDialog(
                  context: context,
                  builder: (context) => Center(
                    child: Dialog(
                      child: SizedBox(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "groupNetworkName: ${info?.groupNetworkName}"),
                              Text("passPhrase: ${info?.passPhrase}"),
                              Text("isGroupOwner: ${info?.isGroupOwner}"),
                              Text("clients: ${info?.clients}"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text("get group info"),
            ),
            /*ElevatedButton(
              onPressed: () async {
                String? ip = await _flutterP2pConnectionPlugin.getIPAddress();
                snack("ip: $ip");
              },
              child: const Text("get ip"),
            ),*/

            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.green.shade100),
              onPressed: () async {
                setState(() {});
                GameManager.instance!.startSocket();
              },
              child: const Text("open the room"), // button 5
            ),
            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.red.shade200),
              onPressed: () async {
                setState(() {});
                GameManager.instance!.closeSocketConnection();
              },
              child: const Text("close the room"),
            ),
          ],
        ),
      ),
    );
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
}
