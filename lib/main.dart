import 'package:age/routes/CatalogPage.dart';
import 'package:age/routes/HomePage.dart';
import 'package:age/routes/RankPage.dart';
import 'package:age/routes/RecommendPage.dart';
import 'package:age/routes/UpdatePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "AGE动漫",
    home: MyApp(),
    theme: ThemeData(
      primaryColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomePage(),
          CatalogPage(),
          RecommendPage(),
          UpdatePage(),
          RankPage(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(),
        labelColor: Colors.orange,
        unselectedLabelColor: Colors.black,
        tabs: <Widget>[
          Tab(text: "首页", icon: Icon(Icons.house)),
          Tab(text: "目录", icon: Icon(Icons.list)),
          Tab(text: "推荐", icon: Icon(Icons.recommend)),
          Tab(text: "更新", icon: Icon(Icons.refresh)),
          Tab(text: "排行", icon: Icon(Icons.timeline)),
        ],
      ),
    );
  }
}
