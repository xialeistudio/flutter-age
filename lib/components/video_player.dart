import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      videoPlayerController: VideoPlayerController.network(widget.videoUrl, httpHeaders: {'Referer': widget.videoUrl}),
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
    return Column(
      children: [
        Container(
          child: FlickVideoPlayer(
            flickManager: _flickManager,
            flickVideoWithControls: FlickVideoWithControls(
              controls: FlickPortraitControls(
                iconSize: 32,
              ),
              videoFit: BoxFit.contain,
            ),
          ),
        ),
        buildVideoUrlView(),
      ],
    );
  }

  /// 视频链接
  Widget buildVideoUrlView() {
    var widgets = [
      Text("视频链接:"),
      Expanded(child: Text(widget.videoUrl, style: TextStyle(fontSize: 10))),
      InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: widget.videoUrl));
          Fluttertoast.showToast(msg: "复制成功", gravity: ToastGravity.CENTER);
        },
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Text("复制"),
        ),
      )
    ];
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Flex(children: widgets, direction: Axis.horizontal),
    );
  }

  @override
  void didUpdateWidget(VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _flickManager.handleChangeVideo(VideoPlayerController.network(widget.videoUrl, httpHeaders: {'Referer': widget.videoUrl}));
    }
  }
}
