import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 播放器
/// 如果链接以mp4结尾，调用原生播放器，否则用Webview
class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final Completer<WebViewController> controllerFuture;

  const VideoPlayerWidget({Key? key, required this.controllerFuture, required this.url}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoPlayerWidgetState();
  }
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  Timer? _timer;
  String? _videoUrl;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: WebView(
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            allowsInlineMediaPlayback: true,
            onWebViewCreated: (controller) {
              widget.controllerFuture.complete(controller);
            },
            onPageStarted: (url) {
              setState(() {
                _videoUrl = null;
              });
            },
            onPageFinished: (url) {
              findVideoUrl(url);
            },
          ),
          height: 250,
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

  List<Widget> buildCopyVideoUrl() {
    var widgets = [
      Text("视频链接:"),
      Expanded(
        child: Text(
          _videoUrl == null ? "获取中" : "获取成功",
          style: TextStyle(
            color: _videoUrl == null ? Colors.grey : Colors.green,
          ),
        ),
      ),
    ];
    if (_videoUrl != null) {
      widgets.add(InkWell(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: _videoUrl));
          Fluttertoast.showToast(msg: "复制成功", gravity: ToastGravity.CENTER);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text("复制"),
        ),
      ));
    }
    return widgets;
  }

// 查找video的链接
  void findVideoUrl(String url) {
    _timer?.cancel();
    var count = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      var controller = await widget.controllerFuture.future;
      var videoUrl = await controller.evaluateJavascript("document.querySelector('video') && document.querySelector('video').src");
      if (videoUrl != "<null>" || ++count >= 60) {
        timer.cancel();
      }
      if (videoUrl != '<null>') {
        setState(() {
          _videoUrl = videoUrl;
        });
      }
    });
  }
}
