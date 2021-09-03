import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Webview播放器
/// 1.如果videoUrl是mp4或m3u8则直接播放
/// 2.否则初始化webview获取播放链接
/// 3.播放webview拿到的链接
class VideoPlayer extends StatefulWidget {
  /// 视频链接
  final String videoUrl;
  final Function? onVideoEnd;

  VideoPlayer({Key? key, required this.videoUrl, this.onVideoEnd}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoPlayerState();
  }
}

class VideoPlayerState extends State<VideoPlayer> {
  /// 播放器
  late FlickManager _flickManager;

  @override
  void initState() {
    super.initState();
    _flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.videoUrl),
      onVideoEnd: widget.onVideoEnd,
    );
  }

  @override
  void dispose() {
    _flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: FlickVideoPlayer(
        flickManager: _flickManager,
        flickVideoWithControlsFullscreen: FlickVideoWithControls(
          controls: const FlickPortraitControls(),
          videoFit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _flickManager.handleChangeVideo(VideoPlayerController.network(widget.videoUrl));
    }
  }
}
