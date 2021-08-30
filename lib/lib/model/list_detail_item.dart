class ListDetailItem {
  String? aid;
  String? title;
  String? type;
  String? originTitle;
  String? otherTitle;
  String? firstPlayTime;
  String? playStatus;
  String? author;
  List<String>? storyTypes;
  String? publisher;
  String? description;
  String? cover;
  String? newTitle;

  ListDetailItem({
      this.aid, 
      this.title,
      this.type,
      this.originTitle,
      this.otherTitle,
      this.firstPlayTime,
      this.playStatus,
      this.author,
      this.storyTypes,
      this.publisher,
      this.description,
      this.cover,
      this.newTitle});

  ListDetailItem.fromJson(dynamic json) {
    aid = json["AID"];
    title = json["R动画名称"];
    type = json["R动画种类"];
    originTitle = json["R原版名称"];
    otherTitle = json["R其他名称"];
    firstPlayTime = json["R首播时间"];
    playStatus = json["R播放状态"];
    author = json["R原作"];
    storyTypes = json["R剧情类型"] != null ? json["R剧情类型"].cast<String>() : [];
    publisher = json["R制作公司"];
    description = json["R简介"];
    cover = json["R封面图小"];
    newTitle = json["R新番标题"];
  }
}