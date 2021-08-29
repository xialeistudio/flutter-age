class ListDayItem {
  bool? isnew;
  String? id;
  int? wd;
  String? name;
  String? mtime;
  String? namefornew;

  ListDayItem({this.isnew, this.id, this.wd, this.name, this.mtime, this.namefornew});

  ListDayItem.fromJson(dynamic json) {
    isnew = json["isnew"];
    id = json["id"];
    wd = json["wd"];
    name = json["name"];
    mtime = json["mtime"];
    namefornew = json["namefornew"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["isnew"] = isnew;
    map["id"] = id;
    map["wd"] = wd;
    map["name"] = name;
    map["mtime"] = mtime;
    map["namefornew"] = namefornew;
    return map;
  }
}
