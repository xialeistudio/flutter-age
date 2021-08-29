class Slide {
  String? aid;
  String? title;
  String? newTitle;
  String? picUrl;
  int? time;

  Slide({this.aid, this.title, this.newTitle, this.picUrl, this.time});

  Slide.fromJson(dynamic json) {
    aid = json["AID"];
    title = json["Title"];
    newTitle = json["NewTitle"];
    picUrl = json["PicUrl"];
    time = json["Time"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["AID"] = aid;
    map["Title"] = title;
    map["NewTitle"] = newTitle;
    map["PicUrl"] = picUrl;
    map["Time"] = time;
    return map;
  }

  @override
  String toString() {
    return 'Slide{aid: $aid, title: $title, newTitle: $newTitle, picUrl: $picUrl, time: $time}';
  }
}
