import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 播放器
/// 如果链接以mp4结尾，调用原生播放器，否则用Webview
class VideoPlayerWidget extends StatelessWidget {
  final String url;
  final WebViewCreatedCallback onWebviewCreated;

  const VideoPlayerWidget({Key? key, required this.onWebviewCreated, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            allowsInlineMediaPlayback: true,
            onWebViewCreated: onWebviewCreated,
          ),
          height: 250,
        ),
      ],
    );
  }
}
