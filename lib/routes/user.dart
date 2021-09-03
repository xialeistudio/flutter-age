import 'package:age/components/item_grid_sliver.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/lib/global.dart';
import 'package:age/lib/data_manager.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserPageState();
  }
}

class UserPageState extends State<UserPage> {
  List<ListItem> historyList = [];
  List<ListItem> favoriteList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    var data = await Future.wait([historyManager.load(), favoriteManager.load()]);
    setState(() {
      historyList = data[0];
      favoriteList = data[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMainAppBar(context, title: "我的"),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadData,
          child: CustomScrollView(
            slivers: [
              buildTitleBarSliver(context, "历史记录", Icons.history, () => Navigator.pushNamed(context, "/history")),
              buildDataListSliver(historyList),
              buildTitleBarSliver(context, "收藏列表", Icons.favorite, () => Navigator.pushNamed(context, "/favorite")),
              buildDataListSliver(favoriteList),
            ],
          ),
        ),
      ),
    );
  }

  /// 构造数据列表
  Widget buildDataListSliver(List<ListItem> list) {
    if (list.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 100,
          child: Text("暂无数据"),
          alignment: Alignment.center,
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: ListItemWidget(item: list[index]),
              );
            },
            itemCount: list.length,
            itemExtent: 126,
          ),
        ),
      ),
    );
  }

  /// 构造标题栏
  Widget buildTitleBarSliver(BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    return SliverToBoxAdapter(
      child: TitleBar(
        title: title,
        iconData: icon,
        trailing: SizedBox(
          width: 24,
          height: 24,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.arrow_forward_ios),
            iconSize: 18,
            padding: const EdgeInsets.all(0),
          ),
        ),
      ),
    );
  }
}
