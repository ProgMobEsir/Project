class JsonRequest {
  //the vars
  String body = "";
  String peer = "";
  String type = "";
  String metadata = "";

  JsonRequest(String body, String peer, String type, String metadata) {
    this.body = body;
    this.peer = peer;
    this.type = type;
    this.metadata = metadata;
  }

  JsonRequest.FromString(String json) {
    var tmp = json.replaceAll("{", "").replaceAll("}", "").replaceAll("\"", "").split(",");
    for (var i = 0; i < tmp.length; i++) {
      var tmp2 = tmp[i].split(":");
      switch (tmp2[0]) {
        case "body":
          body = tmp2[1];
          break;
        case "peer":
          peer = tmp2[1];
          break;
        case "type":
          type = tmp2[1];
          break;
        case "metadata":
          metadata = tmp2[1];
          break;
      }
    }
  }

  //methode to create a Json type object in string and return it, with a body, a peer value and a type and metadata
  String getRequest() {
    return '{"body": "$body", "peer": "$peer", "type": "$type", "metadata": "$metadata"}';
  }
  
}
