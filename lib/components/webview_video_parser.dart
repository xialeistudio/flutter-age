import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Webview视频链接解析器
class WebviewVideoUrlParser extends StatefulWidget {
  /// 解析结果
  final Completer<String> result;

  /// webview地址
  final String webviewUrl;

  /// 获取超时时间
  final int timeout;

  const WebviewVideoUrlParser({Key? key, required this.result, required this.webviewUrl, this.timeout = 10}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WebviewVideoUrlParserState();
  }
}

class WebviewVideoUrlParserState extends State<WebviewVideoUrlParser> {
  final Completer<WebViewController> _controller = Completer();
  Timer? _timer;
  ValueNotifier<int> time = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    loadWebviewUrl(url: widget.webviewUrl);
  }

  @override
  void didUpdateWidget(covariant WebviewVideoUrlParser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.webviewUrl != widget.webviewUrl) {
      loadWebviewUrl(url: widget.webviewUrl);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    loadWebviewUrl();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        WebView(
          initialUrl: "about:blank",
          javascriptMode: JavascriptMode.unrestricted,
          allowsInlineMediaPlayback: true,
          onWebViewCreated: (controller) {
            _controller.complete(controller);
          },
          onPageFinished: (url) {
            findVideoUrl();
          },
        ),
        Container(
          child: CupertinoActivityIndicator(radius: 20),
          decoration: BoxDecoration(color: Colors.white),
          alignment: Alignment.center,
        ),
      ],
    );
  }

  /// 加载网页
  loadWebviewUrl({url = "about:blank"}) async {
    print("loadWebviewUrl $url");
    var controller = await _controller.future;
    controller.loadUrl(url, headers: {'Referer': url});
  }

  /// 查找视频链接
  void findVideoUrl() {
    _timer?.cancel();
    time.value = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      var controller = await _controller.future;
      var videoUrl = await controller.evaluateJavascript("document.querySelector('video') && document.querySelector('video').src");
      // 获取成功
      if (videoUrl != "<null>") {
        loadWebviewUrl();
        timer.cancel();
        widget.result.complete(videoUrl);
        return;
      }
      if (++time.value >= widget.timeout) {
        loadWebviewUrl();
        timer.cancel();
        widget.result.completeError("timeout");
      }
    });
  }
}
