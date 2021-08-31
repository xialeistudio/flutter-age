import 'package:age/routes/search.dart';
import 'package:flutter/material.dart';

/// 构造导航栏
AppBar buildMainAppBar(BuildContext context, {required String title}) {
  return AppBar(
    leading: IconButton(icon: Icon(Icons.search), onPressed: () => showSearch(context: context, delegate: SearchBarDelegate())),
    title: Text(title),
    actions: [
      IconButton(icon: Icon(Icons.history), onPressed: () => Navigator.pushNamed(context, "/history")),
    ],
  );
}
