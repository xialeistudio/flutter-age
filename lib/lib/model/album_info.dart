import 'video_info.dart';

class AnimationInfo {
  String? aid;
  String? region;
  String? type;
  String? title;
  String? originTitle;
  String? otherTitle;
  String? titleIndex;
  String? author;
  String? publisher;
  String? firstPlayTime;
  String? playStatus;
  String? storyType;
  String? newTitle;
  String? measure;
  String? collectionTitle;
  String? officialSite;
  String? tag;
  int? recommendStar;
  String? cover;
  String? coverSmall;
  String? description;
  int? updateTimestamp;
  String? updateTime;
  String? updateDate;
  List<String>? tags;
  List<String>? storyTypes;
  List<List<VideoInfo>>? playlists;
  String? firstPlayYear;
  String? firstPlaySeason;
  int? rankCount;
  int? commentCount;
  int? collectCount;
  int? modifiedTime;
  String? lastModified;
  String? filePath;

  AnimationInfo(
      {this.aid,
      this.region,
      this.type,
      this.title,
      this.originTitle,
      this.otherTitle,
      this.titleIndex,
      this.author,
      this.publisher,
      this.firstPlayTime,
      this.playStatus,
      this.storyType,
      this.newTitle,
      this.measure,
      this.collectionTitle,
      this.officialSite,
      this.tag,
      this.updateTime,
      this.recommendStar,
      this.cover,
      this.coverSmall,
      this.description,
      this.updateTimestamp,
      this.updateDate,
      this.tags,
      this.storyTypes,
      this.playlists,
      this.firstPlayYear,
      this.firstPlaySeason,
      this.rankCount,
      this.commentCount,
      this.collectCount,
      this.modifiedTime,
      this.lastModified,
      this.filePath});

  AnimationInfo.fromJson(dynamic json) {
    aid = json["AID"];
    region = json["R地区"];
    type = json["R动画种类"];
    title = json["R动画名称"];
    originTitle = json["R原版名称"];
    otherTitle = json["R其它名称"];
    titleIndex = json["R字母索引"];
    author = json["R原作"];
    publisher = json["R制作公司"];
    firstPlayTime = json["R首播时间"];
    playStatus = json["R播放状态"];
    storyType = json["R剧情类型"];
    newTitle = json["R新番标题"];
    measure = json["R视频尺寸"];
    collectionTitle = json["R系列"];
    officialSite = json["R官方网站"];
    tag = json["R标签"];
    updateTime = json["R更新时间"];
    recommendStar = json["R推荐星级"];
    cover = json["R封面图"];
    coverSmall = json["R封面图小"];
    description = json["R简介"];
    updateTimestamp = json["R更新时间unix"];
    updateTime = json["R更新时间str"];
    updateDate = json["R更新时间str2"];
    tags = json["R标签2"] != null ? json["R标签2"].cast<String>() : [];
    storyTypes = json["R剧情类型2"] != null ? json["R剧情类型2"].cast<String>() : [];
    if (json["R在线播放All"] != null) {
      playlists = [];
      json["R在线播放All"].forEach((v) {
        List<VideoInfo> playlist = [];
        var videos = v as List<dynamic>;
        playlist.addAll(videos.map((e) => VideoInfo.fromJson(e)));
        playlists?.add(playlist);
      });
    }
    firstPlayYear = json["R首播年份"];
    firstPlaySeason = json["R首播季度"];
    rankCount = json["RankCnt"];
    commentCount = json["CommentCnt"];
    collectCount = json["CollectCnt"];
    modifiedTime = json["ModifiedTime"];
    lastModified = json["LastModified"];
    filePath = json["FilePath"];
  }

  @override
  String toString() {
    return 'AnimationInfo{aid: $aid, title: $title}';
  }
}
