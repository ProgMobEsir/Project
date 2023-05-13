import 'dart:convert';

import 'JsonRequest.dart';

class PlayerRequest extends JsonRequest {
  String players = "";

  PlayerRequest(this.players) : super('{"players":"$players"}', "players", "");

  PlayerRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    players = jsonDecoded['players'];
  }
}
