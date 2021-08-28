class HomeItem {
  String? aid;
  String? title;
  String? newTitle;
  String? picSmall;
  String? href;

  HomeItem({
      this.aid, 
      this.title, 
      this.newTitle, 
      this.picSmall, 
      this.href});

  HomeItem.fromJson(dynamic json) {
    aid = json["AID"];
    title = json["Title"];
    newTitle = json["NewTitle"];
    picSmall = json["PicSmall"];
    href = json["Href"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["AID"] = aid;
    map["Title"] = title;
    map["NewTitle"] = newTitle;
    map["PicSmall"] = picSmall;
    map["Href"] = href;
    return map;
  }

}