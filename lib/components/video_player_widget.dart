import 'dart:async';
import 'dart:io';

import 'package:age/lib/model/video_play_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 播放器
/// 如果链接以mp4结尾，调用原生播放器，否则用Webview
class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayConfig videoPlayConfig;

  const VideoPlayerWidget({Key? key, required this.videoPlayConfig}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoPlayerWidgetState(videoPlayConfig: videoPlayConfig);
  }
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  final VideoPlayConfig videoPlayConfig;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  String? _videoUrl;

  VideoPlayerWidgetState({required this.videoPlayConfig});

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return buildWebPlayer();
  }

  buildWebPlayer() {
    return Column(
      children: [
        Container(
          child: WebView(
            initialUrl: "${videoPlayConfig.purlf}${videoPlayConfig.vurl}",
            javascriptMode: JavascriptMode.unrestricted,
            allowsInlineMediaPlayback: true,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (url) {
              findVideoUrl();
            },
            navigationDelegate: (request) {
              print("request ${request.url}");
              return NavigationDecision.navigate;
            },
          ),
          height: 220,
        ),
        Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.all(8),
          child: Flex(
            direction: Axis.horizontal,
            children: buildCopyVideoUrl(),
          ),
        ),
      ],
    );
  }

  /// 复制视频链接
  List<Widget> buildCopyVideoUrl() {
    var widgets = [
      Text("视频链接:"),
      Expanded(
        child: InkWell(
          child: Text(
            _videoUrl == null ? "获取中" : "获取成功(点击复制)",
            style: TextStyle(color: _videoUrl == null ? Colors.grey : Colors.green),
          ),
          onTap: () async {
            if (_videoUrl == null) {
              return;
            }
            await Clipboard.setData(ClipboardData(text: _videoUrl));
            Fluttertoast.showToast(msg: "复制成功", gravity: ToastGravity.CENTER);
          },
        ),
      ),
    ];
    return widgets;
  }

  /// 查找视频链接
  void findVideoUrl() async {
    var controller = await _controller.future;
    var javascriptString = "document.querySelector('video')&&document.querySelector('video').src";
    var data = await controller.evaluateJavascript(javascriptString);
    if (data.contains("null")) {
      return;
    }
    setState(() {
      _videoUrl = data;
    });
  }
}
