/// 视频
class VideoInfo {
  String? title;
  String? titleL;
  String? playId;
  String? playVid;
  String? epName;
  String? epPic;
  String? ex;

  VideoInfo({this.title, this.titleL, this.playId, this.playVid, this.epName, this.epPic, this.ex});

  VideoInfo.fromJson(dynamic json) {
    title = json["Title"];
    titleL = json["Title_l"];
    playId = json["PlayId"];
    playVid = json["PlayVid"];
    epName = json["EpName"];
    epPic = json["EpPic"];
    ex = json["Ex"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Title"] = title;
    map["Title_l"] = titleL;
    map["PlayId"] = playId;
    map["PlayVid"] = playVid;
    map["EpName"] = epName;
    map["EpPic"] = epPic;
    map["Ex"] = ex;
    return map;
  }
}
