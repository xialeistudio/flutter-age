import 'package:age/lib/model/video_info.dart';
import 'package:age/routes/components/playlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 详情页选集
class DetailPlaylistPage extends StatelessWidget {
  final List<List<VideoInfo>> playlists;
  final VideoInfo? defaultSelected;

  const DetailPlaylistPage({Key? key, required this.playlists, required this.defaultSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("播放列表")),
      body: SafeArea(
        child: DefaultTabController(
          length: playlists.length,
          child: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: PlaylistsBar(playlists: playlists)),
              SliverFillRemaining(child: TabBarView(children: playlists.map((e) => buildPlaylistItem(e)).toList())),
            ],
          ),
        ),
      ),
    );
  }

  /// 单个播放列表
  Widget buildPlaylistItem(List<VideoInfo> videos) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.all(4),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          crossAxisSpacing: 4,
          mainAxisExtent: 36,
          maxCrossAxisExtent: 64,
          mainAxisSpacing: 4
        ),
        itemBuilder: (context, index) {
          var item = videos[index];
          return InkWell(
            child: PlaylistItem(video: item, active: defaultSelected?.playVid == item.playVid),
            onTap: () => Navigator.pop(context, item),
          );
        },
        itemCount: videos.length,
      ),
    );
  }
}
