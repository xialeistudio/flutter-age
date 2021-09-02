import 'dart:async';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 播放器
/// 1.如果videoUrl是mp4或m3u8则直接播放
/// 2.否则初始化webview获取播放链接
/// 3.播放webview拿到的链接
class VideoPlayerWidget extends StatefulWidget {
  /// 视频或播放器链接
  final String url;

  const VideoPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoPlayerWidgetState();
  }
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  Timer? _timer;

  /// 播放器
  FlickManager? _flickManager;

  /// Webview
  Completer<WebViewController>? _webviewController;
  String? _webviewUrl;

  @override
  void initState() {
    super.initState();
    // 加载视频
    loadVideoUrl();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _flickManager?.dispose();
    stopWebview();
    super.dispose();
  }

  Future<void> stopWebview({url = "about:blank"}) async {
    var controller = await _webviewController?.future;
    controller?.loadUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(height: 250, child: buildBody());
  }

  Widget buildBody() {
    if (_webviewUrl != null) {
      return buildWebView();
    }
    if (_flickManager == null) {
      return Center(child: CircularProgressIndicator());
    }
    return FlickVideoPlayer(flickManager: _flickManager!);
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    if (oldWidget.url != widget.url) {
      loadVideoUrl();
    }
    super.didUpdateWidget(oldWidget);
  }

  /// 构造webview
  Widget buildWebView() {
    return Stack(
      fit: StackFit.expand,
      children: [
        WebView(
          initialUrl: _webviewUrl!,
          javascriptMode: JavascriptMode.unrestricted,
          allowsInlineMediaPlayback: true,
          onWebViewCreated: (controller) {
            _webviewController?.complete(controller);
          },
          onPageFinished: (url) {
            findVideoUrl(url);
          },
        ),
        Container(decoration: BoxDecoration(color: Colors.black), child: Center(child: CircularProgressIndicator()))
      ],
    );
  }

  /// 查找video的链接
  void findVideoUrl(String url) {
    _timer?.cancel();
    var count = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      var controller = await _webviewController?.future;
      var videoUrl = await controller?.evaluateJavascript("document.querySelector('video') && document.querySelector('video').src");
      if (videoUrl != "<null>" || ++count >= 60) {
        timer.cancel();
      }
      if (videoUrl != '<null>') {
        stopWebview();
        setState(() {
          _webviewUrl = null;
          _flickManager = FlickManager(videoPlayerController: VideoPlayerController.network(videoUrl!));
        });
      }
    });
  }

  /// 解析视频链接
  Future<void> loadVideoUrl() async {
    // 停止播放
    stopWebview();
    _flickManager?.flickControlManager?.pause();
    if (widget.url.endsWith(".mp4") || widget.url.endsWith(".m3u8")) {
      setState(() {
        _flickManager = FlickManager(videoPlayerController: VideoPlayerController.network(widget.url));
      });
      return;
    }

    // 初始化webview进行解析
    _webviewController = Completer();
    setState(() {
      _webviewUrl = widget.url;
    });
  }
}
