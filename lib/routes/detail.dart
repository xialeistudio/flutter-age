import 'package:age/components/detail_animation_info.dart';
import 'package:age/components/item_grid_sliver.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/components/video_player_widget.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/album_info.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:age/lib/model/video_info.dart';
import 'package:age/lib/model/video_play_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 详情页
class DetailPage extends StatefulWidget {
  final String id;
  final String title;

  const DetailPage({Key? key, required this.id, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailPageState(id: id, title: title);
  }
}

class DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  final String id;
  final String title;

  // 页面数据
  AnimationInfo? _animationInfo;
  List<ListItem> _relationList = [];
  List<ListItem> _recommendList = [];

  // 播放相关
  ValueNotifier<String> playingVideoUrl = ValueNotifier("");
  ValueNotifier<String> playingVideoVid = ValueNotifier("");
  bool isLoading = false;

  DetailPageState({required this.id, required this.title});

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_animationInfo == null) {
      child = Center(child: CircularProgressIndicator());
    } else {
      child = buildBody(_animationInfo!, _relationList, _recommendList);
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(child: child),
    );
  }

  /// 构造正文
  RefreshIndicator buildBody(AnimationInfo animationInfo, List<ListItem> relationList, recommendList) {
    var playlists = animationInfo.playlists!.where((element) => element.length > 0).toList();
    var controller = TabController(length: playlists.length, vsync: this);
    return RefreshIndicator(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ValueListenableBuilder(
              builder: (context, String value, child) {
                if (value == "") {
                  return DetailAnimationInfo(info: animationInfo);
                }
                return VideoPlayerWidget(url: value);
              },
              valueListenable: playingVideoUrl,
            ),
          ),
          SliverToBoxAdapter(child: buildDescription(animationInfo)),
          SliverPadding(padding: const EdgeInsets.only(top: 8)),
          SliverToBoxAdapter(child: buildPlaylistHeader(playlists, controller)),
          SliverToBoxAdapter(child: buildPlaylistBody(playlists, controller)),
          SliverPadding(padding: const EdgeInsets.only(top: 8)),
          SliverToBoxAdapter(child: TitleBar(title: "相关动画")),
          buildRelationList(relationList),
          SliverPadding(padding: const EdgeInsets.only(top: 8)),
          SliverToBoxAdapter(child: TitleBar(title: "猜你喜欢")),
          ItemGridSliver(items: recommendList),
          SliverPadding(padding: const EdgeInsets.only(bottom: 20)),
        ],
      ),
      onRefresh: () => loadData(cached: false),
    );
  }

  /// 构造简介
  Container buildDescription(AnimationInfo animationInfo) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(animationInfo.description!),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color.fromRGBO(220, 220, 220, 0.5), width: 1, style: BorderStyle.solid),
        ),
      ),
    );
  }

  Future<void> loadData({cached = true}) async {
    var data = await httpClient.loadDetail(id, cached: cached);
    setState(() {
      _relationList = data[1]! as List<ListItem>;
      _recommendList = data[2]! as List<ListItem>;
      _animationInfo = data[0]! as AnimationInfo;
    });
  }

  /// 构造播放列表Tab
  buildPlaylistHeader(List<List<VideoInfo>> playlists, TabController controller) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          TabBar(
            controller: controller,
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.black,
            tabs: playlists.asMap().entries.map((entry) => Tab(text: "播放列表${entry.key + 1}")).toList(),
          ),
        ],
      ),
    );
  }

  /// 构造单个播放列表
  Container buildPlaylistItem(List<VideoInfo> videos) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListView.builder(
        itemBuilder: (context, index) {
          var item = videos[index];
          return InkWell(
            child: ValueListenableBuilder(
              builder: (context, String value, child) {
                var borderColor = Color.fromRGBO(200, 200, 200, 1);
                var textColor = Colors.black;
                if (value == item.playVid) {
                  borderColor = Colors.orange;
                  textColor = borderColor;
                }
                return Container(
                  child: Text(item.title!, style: TextStyle(fontSize: 14, color: textColor)),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.only(right: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(width: 0.5, color: borderColor)),
                );
              },
              valueListenable: playingVideoVid,
            ),
            onTap: () => playVideo(item),
          );
        },
        itemCount: videos.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  /// 构造播放列表indexedStack
  buildPlaylistBody(List<List<VideoInfo>> list, TabController controller) {
    return Container(
      height: 40,
      child: TabBarView(
        children: list.map((e) => buildPlaylistItem(e)).toList(),
        controller: controller,
      ),
    );
  }

  /// 相关动画
  buildRelationList(List<ListItem> relationList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index.isOdd) {
            return Divider(color: Color.fromRGBO(220, 220, 220, 0.5), height: 0.5);
          }
          var item = relationList[index ~/ 2];
          return ListTile(
            title: Text(item.title!),
            tileColor: Colors.white,
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
            onTap: () => Navigator.pushNamed(context, "/detail", arguments: {'id': item.aid, 'title': item.title}),
          );
        },
        childCount: relationList.length * 2 - 1,
      ),
    );
  }

  /// 播放
  playVideo(VideoInfo e) async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    try {
      var globalConfig = await httpClient.loadGlobalPlayConfig();
      var playConfig = await httpClient.loadVideoPlayConfig(e, globalConfig);
      playingVideoUrl.value = playConfig.purlf! + playConfig.vurl!;
      playingVideoVid.value = e.playVid!;
    } on DioError catch (err) {
      Fluttertoast.showToast(msg: "播放失败:${err.message}", gravity: ToastGravity.CENTER);
    } finally {
      isLoading = false;
    }
  }
}
