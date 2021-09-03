import 'dart:async';
import 'dart:math';

import 'package:age/components/detail_animation_info.dart';
import 'package:age/components/item_grid_sliver.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/components/video_player.dart';
import 'package:age/components/webview_video_parser.dart';
import 'package:age/lib/data_manager.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/album_info.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:age/lib/model/video_info.dart';
import 'package:age/routes/components/playlist.dart';
import 'package:age/routes/detail_playlist.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  ValueNotifier<String> _playingVideoUrl = ValueNotifier("");
  ValueNotifier<VideoInfo> _playingVideo = ValueNotifier(VideoInfo());
  ValueNotifier<bool> favorite = ValueNotifier(false);
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
      child = Center(child: CupertinoActivityIndicator());
    } else {
      child = buildBody(_animationInfo!, _relationList, _recommendList);
    }
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          builder: (context, VideoInfo value, child) {
            if (value.playVid == null) {
              return Text(title);
            }
            return Text("$title(${value.title!})");
          },
          valueListenable: _playingVideo,
        ),
      ),
      body: SafeArea(child: child),
      floatingActionButton: _animationInfo == null
          ? null
          : ValueListenableBuilder(
              builder: (context, bool value, child) {
                return FloatingActionButton(
                  child: Icon(Icons.favorite),
                  backgroundColor: value ? Colors.green : Colors.orange,
                  onPressed: () {
                    handleFavorite(value);
                  },
                );
              },
              valueListenable: favorite,
            ),
    );
  }

  void handleFavorite(bool value) {
    var listItem = ListItem(
      aid: _animationInfo!.aid,
      title: _animationInfo!.title,
      newTitle: _animationInfo!.newTitle,
      picSmall: _animationInfo!.coverSmall,
    );
    if (value) {
      favoriteManager.remove(listItem);
      Fluttertoast.showToast(msg: "取消收藏成功", gravity: ToastGravity.CENTER);
      favorite.value = false;
    } else {
      favoriteManager.add(listItem);
      Fluttertoast.showToast(msg: "收藏成功", gravity: ToastGravity.CENTER);
      favorite.value = true;
    }
  }

  /// 构造正文
  Widget buildBody(AnimationInfo animationInfo, List<ListItem> relationList, recommendList) {
    var playlists = animationInfo.playlists!.where((element) => element.length > 0).toList();
    var tabController = TabController(length: playlists.length, vsync: this);
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: ValueListenableBuilder(
            builder: (context, String value, child) {
              if (value.isEmpty) {
                return DetailAnimationInfo(info: animationInfo);
              }
              return VideoPlayer(videoUrl: value);
            },
            valueListenable: _playingVideoUrl,
          ),
        ),
        SliverToBoxAdapter(child: buildDescription(animationInfo)),
        SliverPadding(padding: const EdgeInsets.only(top: 8)),
        SliverToBoxAdapter(child: buildPlaylistHeader(playlists, tabController)),
        SliverToBoxAdapter(child: buildPlaylistBody(playlists, tabController)),
        SliverPadding(padding: const EdgeInsets.only(top: 8)),
        SliverToBoxAdapter(child: TitleBar(title: "相关动画", iconData: Icons.attachment)),
        buildRelationList(relationList),
        SliverPadding(padding: const EdgeInsets.only(top: 8)),
        SliverToBoxAdapter(child: TitleBar(title: "猜你喜欢", iconData: Icons.favorite)),
        ItemGridSliver(items: recommendList),
        SliverPadding(padding: const EdgeInsets.only(bottom: 20)),
      ],
    );
  }

  /// 构造简介
  Widget buildDescription(AnimationInfo animationInfo) {
    return Column(children: [
      Divider(),
      Padding(padding: const EdgeInsets.all(8), child: Text(animationInfo.description!)),
      Divider(),
    ]);
  }

  Future<void> loadData({cached = true}) async {
    var data = await httpClient.loadDetail(id, cached: cached);
    var animationInfo = data[0]! as AnimationInfo;
    setState(() {
      _relationList = data[1]! as List<ListItem>;
      _recommendList = data[2]! as List<ListItem>;
      _animationInfo = animationInfo;
    });
    var listItem = ListItem(
      aid: animationInfo.aid,
      title: animationInfo.title,
      newTitle: animationInfo.newTitle,
      picSmall: animationInfo.coverSmall,
    );
    await historyManager.add(listItem);
    favorite.value = await favoriteManager.exists(listItem);
  }

  /// 构造播放列表Tab
  buildPlaylistHeader(List<List<VideoInfo>> playlists, TabController tabController) {
    return PlaylistsBar(
      tabController: tabController,
      playlists: playlists,
      trailing: IconButton(
        onPressed: () async {
          var selected = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DetailPlaylistPage(playlists: playlists, defaultSelected: _playingVideo.value);
              },
              fullscreenDialog: true,
            ),
          );
          if (selected == null) {
            return;
          }
          playVideo(selected);
        },
        icon: Icon(Icons.arrow_forward_ios, color: Colors.black38),
        iconSize: 18,
      ),
    );
  }

  /// 构造单个播放列表
  Container buildPlaylistItem(List<VideoInfo> videos) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListView.builder(
        itemBuilder: (context, index) {
          var item = videos[index];
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ValueListenableBuilder(
                builder: (context, VideoInfo value, child) {
                  return PlaylistItem(video: item, active: value.playVid == item.playVid);
                },
                valueListenable: _playingVideo,
              ),
            ),
            onTap: () => playVideo(item),
          );
        },
        itemCount: videos.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  /// 构造播放列表
  buildPlaylistBody(List<List<VideoInfo>> list, TabController tabController) {
    return Container(
      height: 36,
      child: TabBarView(
        controller: tabController,
        children: list.map((e) => buildPlaylistItem(e)).toList(),
      ),
    );
  }

  /// 相关动画
  buildRelationList(List<ListItem> relationList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index.isOdd) {
            return Divider();
          }
          var item = relationList[index ~/ 2];
          return ListTile(
            visualDensity: VisualDensity(vertical: -4),
            title: Text(item.title!, style: TextStyle(fontSize: 14)),
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
            onTap: () => Navigator.pushNamed(context, "/detail", arguments: {'id': item.aid, 'title': item.title}),
          );
        },
        childCount: max(0, relationList.length * 2 - 1),
      ),
    );
  }

  /// 播放
  playVideo(VideoInfo video) async {
    if (video == _playingVideo.value) {
      return;
    }
    if (isLoading) {
      return;
    }
    isLoading = true;
    try {
      var globalConfig = await httpClient.loadGlobalPlayConfig();
      var playConfig = await httpClient.loadVideoPlayConfig(video, globalConfig);
      _playingVideo.value = video;
      var videoUrl = Uri.decodeFull(playConfig.vurl!);
      if (videoUrl.endsWith(".mp4") || videoUrl.endsWith(".m3u8")) {
        _playingVideoUrl.value = videoUrl;
        return;
      }
      _playingVideoUrl.value = await parseWebviewVideoUrl(playConfig.purlf! + playConfig.vurl!);
    } on DioError catch (err) {
      Fluttertoast.showToast(msg: "播放失败:${err.message}", gravity: ToastGravity.CENTER);
    } catch (err) {
      Fluttertoast.showToast(msg: "播放失败:${err.toString()}", gravity: ToastGravity.CENTER);
    } finally {
      isLoading = false;
    }
  }

  /// 解析webview播放器中的链接
  parseWebviewVideoUrl(String webviewUrl) async {
    var result = await showDialog(
      context: context,
      builder: (context) {
        Completer<String> completer = Completer();
        completer.future.then((value) => Navigator.pop(context, value)).catchError((err) => Navigator.pop(context, err));
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 100,
              height: 100,
              child: WebviewVideoUrlParser(result: completer, webviewUrl: webviewUrl),
            ),
          ),
        );
      },
    );
    if (result == null || result == "timeout") {
      throw "解析播放链接超时";
    }
    return result;
  }

  /// 自动播放下一集
  handleVideoEnd(List<VideoInfo> playlist) {
    var index = playlist.indexOf(_playingVideo.value);
    if (index == -1) {
      print("没在播放列表找到");
      return;
    }
    if (index == playlist.length - 1) {
      print("最后一集了");
      return;
    }
    playVideo(playlist.elementAt(index + 1));
  }
}
