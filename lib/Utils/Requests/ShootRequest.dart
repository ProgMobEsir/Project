import 'dart:convert';

import 'JsonRequest.dart';

class ShootRequest extends JsonRequest {
  double aimx = 0;
  double aimy = 0;
  ShootRequest(this.aimx, this.aimy)
      : super('{"aimx":"$aimx","aimy":"$aimy"}', "shoot", "");

  ShootRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    aimx = double.parse(jsonDecoded['aimx']);
    aimy = double.parse(jsonDecoded['aimy']);
  }
}
