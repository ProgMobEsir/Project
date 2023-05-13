import 'dart:convert';

import 'JsonRequest.dart';

class LifeRequest extends JsonRequest {
  int life = 0;
  LifeRequest(this.life) : super('{"life":"$life"}', "life", "");

  LifeRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    life = int.parse(jsonDecoded['life']);
  }
}
