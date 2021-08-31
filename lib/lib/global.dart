import 'package:age/routes/search.dart';
import 'package:flutter/material.dart';

class Util {
  static String adaptImageURL(String url) {
    if (url.startsWith("http://") || url.startsWith("https://")) {
      return url;
    }
    if (url.startsWith("//")) {
      return "https:$url";
    }
    return url;
  }
}

/// 构造导航栏
AppBar buildAppBar(BuildContext context, {required String title}) {
  return AppBar(
    leading: IconButton(icon: Icon(Icons.search), onPressed: () => showSearch(context: context, delegate: SearchBarDelegate())),
    title: Text(title),
    actions: [
      IconButton(icon: Icon(Icons.history), onPressed: () => Navigator.pushNamed(context, "/history")),
    ],
  );
}
