import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:wifi_direct_json/Utils/Requests/JsonRequest.dart';
import 'package:wifi_direct_json/Utils/Requests/NewPeerNameRequest.dart';
import '../navigation/NavigationService.dart';
import '/Utils/Reciever.dart';
import '/Utils/GameMods.dart';

class GameManager {
  var lastWinner = "";

  var playerName = "";

  List<String> players = [];

  GameMode gameMode = GameMode.Solo;
  var scores = {};

  List<DiscoveredPeers> peers = [];

  WifiP2PInfo? wifiP2PInfo;
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  FlutterP2pConnection _flutterP2pConnectionPlugin = FlutterP2pConnection();

  FlutterP2pConnection get flutterP2pConnectionPlugin =>
      _flutterP2pConnectionPlugin;

  static GameManager? _instance;
  //table of all the subscribers
  List<Reciever> subscribers = [];

  static GameManager? get instance {
    if (_instance == null) {
      _instance = GameManager();
      _instance!.init();
    }
    return _instance;
  }

  void subscribe(game) {
    subscribers.add(game);
  }

  void unsubscribe(game) {
    game.subscribed = false;
  }

  void onRecieve(String reqette) {
    JsonRequest jReq = JsonRequest.FromString(reqette);
    var tounsubscribe = [];
    for (var sub in subscribers) {
      if (sub.subscribed)
        sub.onRecieve(jReq);
      else {
        tounsubscribe.add(sub);
      }
    }
    for (var sub in tounsubscribe) {
      subscribers.remove(sub);
    }

    parseRequest(jReq);
  }

  void parseRequest(JsonRequest jsonReq) {
    //set the request in a table

    if (jsonReq.type == "newPeerName") {
      NewPeerNameRequest newPeerNameRequest = jsonReq.getNewPeerNameRequest();
      players.add(newPeerNameRequest.name);
      print("new player connected ! " + newPeerNameRequest.name);
    }

    if (jsonReq.type == "MENU") {
      if (jsonReq.metadata == "NAMING") {
        NavigationService.instance.navigateToReplacement("NAMING");
      }
    }

    if (jsonReq.type == "GAME") {
      if (jsonReq.metadata == "SIMON") {
        print("starting simon");
        NavigationService.instance.navigateToReplacement("GAME_SIMON");
      } else if (jsonReq.metadata == "DRAG") {
        print("starting agar");
        NavigationService.instance.navigateToReplacement("GAME_DRAG");
      } else if (jsonReq.metadata == "ACCEL") {
        print("starting agar");
        NavigationService.instance.navigateToReplacement("GAME_ACCEL");
      }
    }
    if (jsonReq.type == "scores") {
      scores = {1: 2};
    }
  }

  void manageScores() {
    scores = {};
    for (var player in players) {
      scores[player] = 0;
    }
  }

  void setLastWinner(String winner) {
    lastWinner = winner;
  }

  String? getLastWinner() {
    return lastWinner;
  }

  void resetPlayers() {
    players = [];
  }

  void init() async {
    await _flutterP2pConnectionPlugin.initialize();
    await _flutterP2pConnectionPlugin.register();
    _streamWifiInfo =
        _flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
      wifiP2PInfo = event;
    });
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      peers = event;
    });

    //here try to switch on the location if not enable
    (await _flutterP2pConnectionPlugin.checkLocationEnabled())
        ? "enabled"
        : await _flutterP2pConnectionPlugin.enableLocationServices();

    (await _flutterP2pConnectionPlugin.checkWifiEnabled())
        ? "enabled"
        : await _flutterP2pConnectionPlugin.enableWifiServices();

    await _flutterP2pConnectionPlugin.removeGroup();

    bool? discovering = await _flutterP2pConnectionPlugin.discover();
  }

  Future startSocket() async {
    if (wifiP2PInfo != null) {
      bool started = await _flutterP2pConnectionPlugin.startSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 2,
        deleteOnError: true,
        onConnect: (name, address) {},
        transferUpdate: (transfer) {
          if (transfer.completed) {}
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (req_) async {
          GameManager.instance!.onRecieve(req_);
        },
      );
    }
  }

  Future connectToSocket() async {
    if (wifiP2PInfo != null) {
      await _flutterP2pConnectionPlugin.connectToSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 3,
        deleteOnError: true,
        onConnect: (address) {
          print("connected to $address");
        },
        transferUpdate: (transfer) {
          // if (transfer.count == 0) transfer.cancelToken?.cancel();
          if (transfer.completed) {}
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (req_) async {
          GameManager.instance!.onRecieve(req_);
        },
      );
    }
  }

  Future closeSocketConnection() async {
    bool closed = _flutterP2pConnectionPlugin.closeSocket();
  }

  Future sendMessage(String s) async {
    sendJsonRequest(JsonRequest("MESSAGE", s, ""));
  }

  Future sendJsonRequest(JsonRequest toSend) async {
    _flutterP2pConnectionPlugin.sendStringToSocket(toSend.getRequest());
  }

  String getMyID() {
    print("my id is " + playerName);
    return playerName;
  }
}
