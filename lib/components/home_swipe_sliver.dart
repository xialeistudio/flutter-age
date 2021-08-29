import 'package:age/components/swipe.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/slide.dart';
import 'package:flutter/material.dart';

/// 首页轮播图
class HomeSwipeSliver extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeSwipeSliverState();
  }
}

class HomeSwipeSliverState extends State<HomeSwipeSliver> {
  List<Slide> _items = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // 轮播图
  Future<void> loadData() async {
    var items = await httpClient.loadSlides();
    setState(() {
      _items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([Swipe(items: _items)]),
    );
  }
}
