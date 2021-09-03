import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Webview播放器
/// 1.如果videoUrl是mp4或m3u8则直接播放
/// 2.否则初始化webview获取播放链接
/// 3.播放webview拿到的链接
class VideoPlayer extends StatefulWidget {
  final String url;

  const VideoPlayer({Key? key, required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoPlayerState();
  }
}

class VideoPlayerState extends State<VideoPlayer> {
  /// Webview
  Completer<WebViewController> _webviewController = Completer();

  @override
  void initState() {
    super.initState();
    loadWebviewUrl(url: widget.url);
  }

  @override
  void dispose() {
    loadWebviewUrl();
    super.dispose();
  }
  Future<void> loadWebviewUrl({url = "about:blank"}) async {
    var controller = await _webviewController.future;
    controller.loadUrl(url, headers: {'Referer': url});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: WebView(
        initialUrl: "about:blank",
        javascriptMode: JavascriptMode.unrestricted,
        allowsInlineMediaPlayback: true,
        onWebViewCreated: (controller) {
          _webviewController.complete(controller);
        },
        onPageStarted: (url) {
          print("load $url");
        },
      ),
    );
  }

  @override
  void didUpdateWidget(VideoPlayer oldWidget) {
    if (oldWidget.url != widget.url) {
      loadWebviewUrl(url: widget.url);
    }
    super.didUpdateWidget(oldWidget);
  }
//
// /// 查找video的链接
// void findVideoUrl(String url) {
//   _timer?.cancel();
//   var count = 0;
//   _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
//     var controller = await _webviewController?.future;
//     var videoUrl = await controller?.evaluateJavascript("document.querySelector('video') && document.querySelector('video').src");
//     if (videoUrl != "<null>" || ++count >= 60) {
//       timer.cancel();
//     }
//     if (videoUrl != '<null>') {
//       stopWebview();
//       setState(() {
//         _webviewUrl = null;
//         _flickManager = FlickManager(videoPlayerController: VideoPlayerController.network(videoUrl!));
//       });
//     }
//   });
// }
//
// /// 解析视频链接
// Future<void> loadVideoUrl() async {
//   // 停止播放
//   stopWebview();
//   _flickManager?.flickControlManager?.pause();
//   if (widget.url.endsWith(".mp4") || widget.url.endsWith(".m3u8")) {
//     setState(() {
//       _flickManager = FlickManager(videoPlayerController: VideoPlayerController.network(widget.url));
//     });
//     return;
//   }
//
//   // 初始化webview进行解析
//   _webviewController = Completer();
//   setState(() {
//     _webviewUrl = widget.url;
//   });
// }
}
