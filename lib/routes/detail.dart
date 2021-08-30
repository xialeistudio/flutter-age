import 'package:age/components/detail_animation_info.dart';
import 'package:age/components/item_grid_sliver.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/album_info.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:age/lib/model/video_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  DetailPageState({required this.id, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: FutureBuilder(
          future: loadData(),
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              var animationInfo = snapshot.data![0] as AnimationInfo;
              var relationList = snapshot.data![1] as List<ListItem>;
              var recommendList = snapshot.data![2] as List<ListItem>;
              return buildBody(animationInfo, relationList, recommendList);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
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
          SliverToBoxAdapter(child: DetailAnimationInfo(info: animationInfo)),
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
      onRefresh: loadData,
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

  Future<List<dynamic>> loadData() => httpClient.loadDetail(id);

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
      child: Wrap(
        spacing: 8,
        runSpacing: 10,
        children: videos.map((e) {
          return Container(
            child: Text(e.title!, style: TextStyle(fontSize: 14)),
            width: MediaQuery.of(context).size.width * 0.3,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(border: Border.all(width: 0.5, color: Color.fromRGBO(200, 200, 200, 1))),
          );
        }).toList(),
      ),
    );
  }

  /// 构造播放列表indexedStack
  buildPlaylistBody(List<List<VideoInfo>> list, TabController controller) {
    return Container(
      height: 200,
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
}
