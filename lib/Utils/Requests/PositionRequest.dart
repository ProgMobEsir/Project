import 'dart:convert';

import 'JsonRequest.dart';

class PositionRequest extends JsonRequest {
  double x = 0;
  double y = 0;
  PositionRequest(this.x, this.y)
      : super('{"x":"$x","y":"$y"}', "position", "");

  PositionRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    x = double.parse(jsonDecoded['x'].toString());
    y = double.parse(jsonDecoded['y'].toString());
  }
}
