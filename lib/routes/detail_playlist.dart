import 'package:age/lib/model/video_info.dart';
import 'package:age/routes/components/playlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 详情页选集

class DetailPlaylistPage extends StatefulWidget {
  final List<List<VideoInfo>> playlists;
  final VideoInfo? defaultSelected;

  const DetailPlaylistPage({Key? key, required this.playlists, this.defaultSelected}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailPlaylistPageState();
  }
}

class DetailPlaylistPageState extends State<DetailPlaylistPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var controller = TabController(length: widget.playlists.length, vsync: this);
    return Scaffold(
      appBar: AppBar(title: Text("播放列表")),
      body: SafeArea(
        child: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: PlaylistsBar(playlists: widget.playlists, tabController: controller)),
            SliverFillRemaining(child: TabBarView(children: widget.playlists.map((e) => buildPlaylistItem(e)).toList(), controller: controller)),
          ],
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
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(crossAxisSpacing: 4, mainAxisExtent: 36, maxCrossAxisExtent: 64, mainAxisSpacing: 4),
        itemBuilder: (context, index) {
          var item = videos[index];
          return InkWell(
            child: PlaylistItem(video: item, active: widget.defaultSelected?.playVid == item.playVid),
            onTap: () => Navigator.pop(context, item),
          );
        },
        itemCount: videos.length,
      ),
    );
  }
}
