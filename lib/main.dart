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
      scaffoldBackgroundColor: Color.fromRGBO(240, 240, 240, 1),
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
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: [
          HomePage(),
          CatalogPage(),
          RecommendPage(),
          UpdatePage(),
          RankPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "目录"),
          BottomNavigationBarItem(icon: Icon(Icons.recommend), label: "推荐"),
          BottomNavigationBarItem(icon: Icon(Icons.refresh), label: "更新"),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: "排行"),
        ],
        currentIndex: _pageIndex,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.orange,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() => _pageIndex = index);
        },
      ),
    );
  }
}
