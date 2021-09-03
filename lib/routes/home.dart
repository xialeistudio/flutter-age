import 'package:age/components/home_swipe_sliver.dart';
import 'package:age/components/item_grid_sliver.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/lib/global.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/list_day_item.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:age/routes/components/weekly_tabview.dart';
import 'package:age/routes/search.dart';
import 'package:flutter/cupertino.dart';
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
  Map<int, List<ListDayItem>>? _weeklyList;

  @override
  void initState() {
    super.initState();
    loadList();
  }

  // 列表数据
  Future<void> loadList({cached = true}) async {
    var data = await httpClient.loadHomeList(cached: cached);
    setState(() {
      _recommendList = data['recommendList'] as List<ListItem>;
      _updateList = data['updateList'] as List<ListItem>;
      _weeklyList = buildWeeklyList(data["weekList"] as List<ListDayItem>);
    });
  }

  // 构造每周列表
  Map<int, List<ListDayItem>> buildWeeklyList(List<ListDayItem> data) {
    Map<int, List<ListDayItem>> map = {1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 0: []};
    data.forEach((item) {
      map[item.wd]!.add(item);
    });
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMainAppBar(context, title: "首页"),
      body: SafeArea(child: buildBody(context)),
    );
  }

  Widget buildBody(BuildContext context) {
    if (_weeklyList == null) {
      return Center(child: CupertinoActivityIndicator());
    }
    return RefreshIndicator(
      child: CustomScrollView(
        slivers: [
          HomeSwipeSliver(),
          SliverToBoxAdapter(child: TitleBar(title: "每周放送", iconData: Icons.calendar_today)),
          SliverToBoxAdapter(child: WeeklyTabView(weeklyList: _weeklyList!)),
          SliverToBoxAdapter(
            child: TitleBar(
              title: "每日推荐",
              iconData: Icons.recommend,
              trailing: SizedBox(
                width: 24,
                height: 24,
                child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, "/recommend"),
                  icon: Icon(Icons.arrow_forward_ios),
                  iconSize: 18,
                  color: Colors.black38,
                  padding: const EdgeInsets.all(0),
                ),
              ),
            ),
          ),
          ItemGridSliver(items: _recommendList),
          SliverToBoxAdapter(
            child: TitleBar(
              title: "最近更新",
              iconData: Icons.update,
              trailing: Container(
                width: 24,
                height: 24,
                child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, "/update"),
                  icon: Icon(Icons.arrow_forward_ios),
                  iconSize: 18,
                  color: Colors.black38,
                  padding: const EdgeInsets.all(0),
                ),
              ),
            ),
          ),
          ItemGridSliver(items: _updateList),
        ],
      ),
      onRefresh: () => loadList(cached: false),
    );
  }
}
