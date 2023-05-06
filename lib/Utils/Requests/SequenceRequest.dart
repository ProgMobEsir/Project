import 'dart:convert';

import 'JsonRequest.dart';

class SequenceRequest extends JsonRequest {
  String sequence = "";
  SequenceRequest(this.sequence, peer)
      : super('{"seq":"$sequence"}', peer, "sequence", "");

  SequenceRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    sequence = jsonDecoded['seq'].toString();
  }
}
 