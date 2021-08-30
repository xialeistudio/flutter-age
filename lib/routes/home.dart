import 'package:age/components/home_swipe_sliver.dart';
import 'package:age/components/item_grid_sliver.dart';
import 'package:age/components/title_sliver.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/list_day_item.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:age/lib/util.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<ListItem> _recommendList = [];
  List<ListItem> _updateList = [];
  Map<int, List<ListDayItem>> _weeklyList = {};

  @override
  void initState() {
    super.initState();
    loadList();
  }

  // 列表数据
  Future<void> loadList() async {
    var data = await httpClient.loadHomeList();
    setState(() {
      _recommendList = data['recommendList'] as List<ListItem>;
      _updateList = data['updateList'] as List<ListItem>;
      _weeklyList = buildWeeklyList(data["weekList"] as List<ListDayItem>);
    });
  }

  // 构造每周列表
  Map<int, List<ListDayItem>> buildWeeklyList(List<ListDayItem> data) {
    Map<int, List<ListDayItem>> map = {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: []};
    data.forEach((item) {
      map[item.wd]!.add(item);
    });
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('首页')),
      body: RefreshIndicator(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            HomeSwipeSliver(),
            SliverPadding(padding: const EdgeInsets.only(top: 8)),
            TitleSliver(title: "每日推荐"),
            ItemGridSliver(items: _recommendList),
            SliverPadding(padding: const EdgeInsets.only(top: 8)),
            TitleSliver(title: "最近更新"),
            ItemGridSliver(items: _updateList),
            SliverPadding(padding: const EdgeInsets.only(bottom: 20)),
          ],
        ),
        onRefresh: loadList,
      ),
    );
  }
}
