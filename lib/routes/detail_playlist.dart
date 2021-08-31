import 'package:age/lib/model/video_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 详情页选集
class DetailPlaylistPage extends StatelessWidget {
  final List<List<VideoInfo>> playlists;

  const DetailPlaylistPage({Key? key, required this.playlists}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('播放列表')),
      body: SafeArea(
        child: DefaultTabController(
          length: playlists.length,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(title: buildPlaylistHeader(playlists)),
              SliverFillRemaining(child: buildPlaylistBody(playlists)),
            ],
          ),
        ),
      ),
    );
  }

  buildPlaylistHeader(List<List<VideoInfo>> playlists) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: TabBar(
        indicatorColor: Colors.orange,
        labelColor: Colors.orange,
        unselectedLabelColor: Colors.black,
        tabs: playlists.asMap().entries.map((entry) => Tab(text: "播放列表${entry.key + 1}")).toList(),
      ),
    );
  }

  /// 构造播放列表indexedStack
  buildPlaylistBody(List<List<VideoInfo>> list) {
    return TabBarView(
      children: list.map((e) => buildPlaylistItem(e)).toList(),
    );
  }

  /// 单个播放列表
  Widget buildPlaylistItem(List<VideoInfo> videos) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, mainAxisSpacing: 4, crossAxisSpacing: 4, mainAxisExtent: 40),
        itemBuilder: (context, index) {
          var item = videos[index];
          return InkWell(
            child: Container(
              child: Text(item.title!, style: TextStyle(fontSize: 14, color: Colors.black)),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(width: 0.5, color: Color.fromRGBO(200, 200, 200, 1))),
            ),
            onTap: () => Navigator.pop(context, item),
          );
        },
        itemCount: videos.length,
      ),
    );
  }
}
