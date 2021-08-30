class GlobalPlayConfig {
  int? serverTime;
  String? location;
  String? location2;
  String? host;
  String? urlPath;

  GlobalPlayConfig({
      this.serverTime, 
      this.location, 
      this.location2, 
      this.host, 
      this.urlPath});

  GlobalPlayConfig.fromJson(dynamic json) {
    serverTime = json["ServerTime"];
    location = json["Location"];
    location2 = json["Location_2"];
    host = json["Host"];
    urlPath = json["UrlPath"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["ServerTime"] = serverTime;
    map["Location"] = location;
    map["Location_2"] = location2;
    map["Host"] = host;
    map["UrlPath"] = urlPath;
    return map;
  }

}