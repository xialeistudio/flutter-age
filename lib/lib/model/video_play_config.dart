class VideoPlayConfig {
  String? purl;
  String? purlf;
  String? vurl;
  String? playid;
  String? vurlBak;
  String? purlMp4;
  String? ex;

  VideoPlayConfig({
      this.purl, 
      this.purlf, 
      this.vurl, 
      this.playid, 
      this.vurlBak, 
      this.purlMp4, 
      this.ex});

  VideoPlayConfig.fromJson(dynamic json) {
    purl = json["purl"];
    purlf = json["purlf"];
    vurl = json["vurl"];
    playid = json["playid"];
    vurlBak = json["vurl_bak"];
    purlMp4 = json["purl_mp4"];
    ex = json["ex"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["purl"] = purl;
    map["purlf"] = purlf;
    map["vurl"] = vurl;
    map["playid"] = playid;
    map["vurl_bak"] = vurlBak;
    map["purl_mp4"] = purlMp4;
    map["ex"] = ex;
    return map;
  }

  @override
  String toString() {
    return 'VideoPlayConfig{purl: $purl, purlf: $purlf, vurl: $vurl, playid: $playid, vurlBak: $vurlBak, purlMp4: $purlMp4, ex: $ex}';
  }
}