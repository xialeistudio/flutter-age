import 'package:age/lib/model/video_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 播放列表表头
class PlaylistsBar extends StatelessWidget {
  final TabController tabController;
  final List<List<VideoInfo>> playlists;
  final Widget? trailing;

  const PlaylistsBar({Key? key, required this.playlists, this.trailing, required this.tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tabBar = TabBar(
      controller: tabController,
      indicatorColor: Colors.orange,
      labelColor: Colors.orange,
      unselectedLabelColor: Colors.black,
      tabs: playlists.asMap().entries.map((entry) => Tab(text: "播放列表${entry.key + 1}")).toList(),
    );
    if (trailing == null) {
      return Container(decoration: BoxDecoration(color: Colors.white), child: tabBar);
    }
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Flex(
        direction: Axis.horizontal,
        children: [Expanded(child: tabBar), trailing!],
      ),
    );
  }
}

/// 播放列表视频项
class PlaylistItem extends StatelessWidget {
  final VideoInfo video;
  final bool active;

  const PlaylistItem({Key? key, required this.video, required this.active}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textColor = Colors.black;
    var borderColor = Color.fromRGBO(200, 200, 200, 1);
    if (active) {
      textColor = Colors.orange;
      borderColor = textColor;
    }
    return Container(
      child: Text(video.title!, style: TextStyle(fontSize: 12, color: textColor)),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(width: 0.5, color: borderColor)),
    );
  }
}
