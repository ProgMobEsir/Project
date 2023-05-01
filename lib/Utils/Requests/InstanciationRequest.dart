import 'dart:convert';

import 'JsonRequest.dart';

class InstanciationRequest extends JsonRequest {
  String type = "";
  double x = 0;
  double y = 0;

  InstanciationRequest(this.x, this.y, this.type, peer)
      : super('{"x":"$x","y":"$y","type":"$type"}', peer, "instanciation", "");

  InstanciationRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    x = double.parse(jsonDecoded['x'].toString());
    y = double.parse(jsonDecoded['y'].toString());
    type = jsonDecoded['type'].toString();
  }
}
