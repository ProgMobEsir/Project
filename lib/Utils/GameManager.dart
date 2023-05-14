import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:wifi_direct_json/Utils/Requests/JsonRequest.dart';
import 'package:wifi_direct_json/Utils/Requests/NewPeerNameRequest.dart';
import 'package:wifi_direct_json/Utils/Requests/PlayersRequest.dart';
import 'package:wifi_direct_json/Utils/TournamentManager.dart';
import '../navigation/NavigationService.dart';
import '/Utils/Reciever.dart';
import '/Utils/GameMods.dart';

class GameManager {

  List<String> gameList = [
    "GAME_SIMON",
    "GAME_DRAG",
    "GAME_ACCEL",
    "GAME_SHOOTER",
    "GAME_QUIZZ",
    "GAME_FRUIT",
  ];

  TournamentManager tournamentManager = TournamentManager();

  var lastWinner = "";
  var playerName = "You";

  Color playerColor = Colors.blue;

  List<String> players = [];

  GameMode gameMode = GameMode.Solo;
  Map<dynamic, dynamic> scores = {};

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

  Color getPlayerColor(){
    return playerColor;
  }

  void setPlayerColor(Color color){
    playerColor = color;
  }

  TournamentManager getTournamentManager(){
    return tournamentManager;
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

    else if (jsonReq.type == "MENU") {
      if (jsonReq.metadata == "NAMING") {
        NavigationService.instance.navigateToReplacement("NAMING");
      }
    }

    else if (jsonReq.type == "GAME") {
      for (String game in gameList) {
        if(game.contains(jsonReq.metadata)){
          NavigationService.instance.navigateToReplacement(game);
        }
      }
    }
    else if (jsonReq.type == "SCREEN"){
      NavigationService.instance.navigateToReplacement("TOURNAMENT_END");
    }

    else if (jsonReq.type == "scores") {
      scores = jsonReq.getScoreRequest().scores;
    }

    else if (jsonReq.type == "players") {
      print("recieving players");
      players = jsonReq.getPlayerRequest().players.split(",");
    }
  }

  void sendPlayers() {
    if (wifiP2PInfo!.isGroupOwner) {
      String tmp = players.join(",");
      sendJsonRequest(PlayerRequest(tmp));
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
    scores = {};
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
    resetPlayers();
    bool closed = _flutterP2pConnectionPlugin.closeSocket();
  }

  Future sendMessage(String s) async {
    sendJsonRequest(JsonRequest("MESSAGE", s, ""));
  }

  Future sendJsonRequest(JsonRequest toSend) async {
    _flutterP2pConnectionPlugin.sendStringToSocket(toSend.getRequest());
  }

  String getMyID() {
    return playerName;
  }
}
