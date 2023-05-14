import 'dart:convert';

import 'JsonRequest.dart';

class InstanciationRequest extends JsonRequest {
  String type = "";
  double x = 0;
  double y = 0;
  double scalex = 0;
  double scaley = 0;
  String color = "";
  double dx = 0;
  double dy = 0;


  InstanciationRequest(this.x, this.y, this.type, this.scalex, this.scaley, this.color, this.dx, this.dy)
      : super('{"x":"$x","y":"$y","type":"$type","scalex":"$scalex","scaley":"$scaley","color":"$color","dx":"$dx","dy":"$dy"}', "instanciation", "");

  InstanciationRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    x = double.parse(jsonDecoded['x'].toString());
    y = double.parse(jsonDecoded['y'].toString());
    scalex = double.parse(jsonDecoded['scalex'].toString());
    scaley = double.parse(jsonDecoded['scaley'].toString());
    color = jsonDecoded['color'].toString();
    dx = double.parse(jsonDecoded['dx'].toString());
    dy = double.parse(jsonDecoded['dy'].toString());

    type = jsonDecoded['type'].toString();
  }
}
