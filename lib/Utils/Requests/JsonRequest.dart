import 'dart:convert';

import 'package:wifi_direct_json/Utils/GameManager.dart';
import 'package:wifi_direct_json/Utils/Requests/PositionRequest.dart';
import 'package:wifi_direct_json/Utils/Requests/ScoreRequest.dart';
import 'package:wifi_direct_json/Utils/Requests/SequenceRequest.dart';
import 'package:wifi_direct_json/Utils/Requests/WinRequest.dart';

import 'InstanciationRequest.dart';

class JsonRequest {
  //the vars
  String body = "";
  String peer = "";
  String type = "";
  String metadata = "";

  JsonRequest(String body, String type, String metadata) {
    this.body = body;
    this.peer = GameManager.instance!.getMyID();
    this.type = type;
    this.metadata = metadata;
  }

  JsonRequest.FromString(String json) {
    //parse the string json with the JsonDecoder
    var jsonDecoded = JsonDecoder().convert(json);
    //set the values of the vars
    body = jsonDecoded["body"];
    peer = jsonDecoded["peer"];
    type = jsonDecoded["type"];
    metadata = jsonDecoded["metadata"];
  }

  //methode to create a Json type object in string and return it, with a body, a peer value and a type and metadata
  String getRequest() {
    //send the vars in a json format with encoder
    var jsonEncoded = JsonEncoder().convert({
      "body": body,
      "peer": peer,
      "type": type,
      "metadata": metadata,
    });
    return jsonEncoded;
  }

  PositionRequest getPositionRequest() {
    return new PositionRequest.FromString(getRequest());
  }

  InstanciationRequest getInstanciationRequest() {
    return new InstanciationRequest.FromString(getRequest());
  }

  WinRequest getWinRequest() {
    return new WinRequest.FromString(getRequest());
  }

  SequenceRequest getSequenceRequest() {
    return new SequenceRequest.FromString(getRequest());
  }

  ScoreRequest getScoreRequest() {
    return new ScoreRequest.FromString(getRequest());
  }
}
