import 'package:flutter/material.dart';
import '../Utils/styles.dart';
import 'ConnPage.dart';
import '/Utils/GameManager.dart';

class ClientMenu extends StatefulWidget {
  const ClientMenu({super.key});

  @override
  State<ClientMenu> createState() => ClientMenuState();
}

class ClientMenuState extends State<ClientMenu> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        backgroundColor: Colors.amber,
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
        title: const Text('Guest Menu'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
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
                'Join a room and wait for the host to start the game !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              ElevatedButton(
                style: Style.getBtnStyleROUNDED(Colors.deepOrangeAccent),
                onPressed: () async {
                  setState(() {});
                },
                child: const Text("Refresh list"),
              ),
              Padding(padding: const EdgeInsets.all(10)),
              const Text("avialable devices:"),
              Divider(),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: GameManager.instance!.peers.length,
                  itemBuilder: (context, index) => Center(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Center(
                            child: AlertDialog(
                              content: SizedBox(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "name: ${GameManager.instance!.peers[index].deviceName}"),
                                    Text(
                                        "address: ${GameManager.instance!.peers[index].deviceAddress}"),
                                    Text(
                                        "isGroupOwner: ${GameManager.instance!.peers[index].isGroupOwner}"),
                                    Text(
                                        "isServiceDiscoveryCapable: ${GameManager.instance!.peers[index].isServiceDiscoveryCapable}"),
                                    Text(
                                        "primaryDeviceType: ${GameManager.instance!.peers[index].primaryDeviceType}"),
                                    Text(
                                        "secondaryDeviceType: ${GameManager.instance!.peers[index].secondaryDeviceType}"),
                                    Text(
                                        "status: ${GameManager.instance!.peers[index].status}"),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    setState(() {});
                                    Navigator.of(context).pop();
                                    bool? bo = await GameManager
                                        .instance?.flutterP2pConnectionPlugin
                                        .connect(GameManager.instance!
                                            .peers[index].deviceAddress);
                                    //on start le socker automatoque
                                    GameManager.instance!.startSocket();
                                    snack("connected: $bo");
                                  },
                                  child: const Text("connect"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            GameManager.instance!.peers[index].deviceName
                                .toString()
                                .characters
                                .first
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //la on met du padding
              const Padding(padding: EdgeInsets.all(20)),
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
              ElevatedButton(
                style: Style.getBtnStyleROUNDED(Colors.green.shade300),
                onPressed: () async {
                  setState(() {});
                  bool? discovering = await GameManager
                      .instance?.flutterP2pConnectionPlugin
                      .discover(); // button 4
                  snack("discovering $discovering");
                },
                child: const Text("Search room"),
              ),
              ElevatedButton(
                style: Style.getBtnStyleROUNDED(Colors.red.shade100),
                onPressed: () async {
                  setState(() {});
                  bool? stopped = await GameManager
                      .instance?.flutterP2pConnectionPlugin
                      .stopDiscovery();
                  snack("stopped discovering $stopped");
                },
                child: const Text("stop searching a room"),
              ),
              ElevatedButton(
                style: Style.getBtnStyleROUNDED(Colors.green),
                onPressed: () async {
                  setState(() {});
                  GameManager.instance!.connectToSocket();
                },
                child: const Text("connect to the room"), // button 6
              ),
            ],
          ),
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
