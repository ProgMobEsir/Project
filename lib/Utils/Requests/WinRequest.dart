import 'dart:convert';

import 'JsonRequest.dart';

class WinRequest extends JsonRequest {
  bool win = false;
  WinRequest(this.win, peer) : super('{"Win":"$win"}', peer, "win", "");

  WinRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    win = bool.fromEnvironment(jsonDecoded['Win']);
  }
}
