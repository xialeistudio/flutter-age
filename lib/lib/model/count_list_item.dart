class CountListItem {
  String? aid;
  String? href;
  String? newTitle;
  String? picSmall;
  String? title;
  int? cCnt;
  int? no;

  CountListItem({
      this.aid, 
      this.href, 
      this.newTitle, 
      this.picSmall, 
      this.title, 
      this.cCnt, 
      this.no});

  CountListItem.fromJson(dynamic json) {
    aid = json['AID'];
    href = json['Href'];
    newTitle = json['NewTitle'];
    picSmall = json['PicSmall'];
    title = json['Title'];
    cCnt = json['CCnt'];
    no = json['NO'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['AID'] = aid;
    map['Href'] = href;
    map['NewTitle'] = newTitle;
    map['PicSmall'] = picSmall;
    map['Title'] = title;
    map['CCnt'] = cCnt;
    map['NO'] = no;
    return map;
  }

}