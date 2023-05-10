import 'dart:convert';

import 'JsonRequest.dart';

class NewPeerNameRequest extends JsonRequest {
  String name = "";

  NewPeerNameRequest(this.name) : super('{"name":"$name"}', "newPeerName", "");

  NewPeerNameRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    name = jsonDecoded['name'].toString();
  }
}
