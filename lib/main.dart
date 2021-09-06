import 'package:age/routes/catalog.dart';
import 'package:age/routes/detail.dart';
import 'package:age/routes/favorite.dart';
import 'package:age/routes/history.dart';
import 'package:age/routes/home.dart';
import 'package:age/routes/rank.dart';
import 'package:age/routes/recommend.dart';
import 'package:age/routes/update.dart';
import 'package:age/routes/user.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "AGE动漫",
    home: MyApp(),
    theme: ThemeData(
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedItemColor: Colors.black87,
        selectedItemColor: Colors.orange,
        showUnselectedLabels: true,
      ),
      dividerTheme: DividerThemeData(
        space: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.orange,
      ),
    ),
    routes: {
      '/detail': (context) {
        var params = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
        return DetailPage(id: params["id"]!, title: params["title"]!);
      },
      '/history': (context) => HistoryPage(),
      '/favorite': (context) => FavoritePage(),
      '/recommend': (context) => RecommendPage(),
      '/update': (context) => UpdatePage(),
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: [HomePage(), CatalogPage(), RankPage(), UserPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "列表"),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: "排行"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
        ],
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() => _pageIndex = index);
        },
      ),
    );
  }
}
