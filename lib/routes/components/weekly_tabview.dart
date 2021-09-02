/// 每周放送
import 'package:age/lib/model/list_day_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeeklyTabView extends StatelessWidget {
  final Map<int, List<ListDayItem>> weeklyList;
  final Map<int, String> weekdayNameMap = {1: '周一', 2: '周二', 3: '周三', 4: '周四', 5: '周五', 6: '周六', 0: '周日'};

  WeeklyTabView({Key? key, required this.weeklyList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var weekday = DateTime.now().weekday;
    if (weekday == 7) {
      weekday = 0;
    }
    return DefaultTabController(
      initialIndex: weekdayNameMap.keys.toList().indexOf(weekday),
      length: weeklyList.length,
      child: Column(
        children: [buildTabBar(context), buildTabview(context)],
      ),
    );
  }

  /// 标签筛选
  buildTabBar(BuildContext context) {
    return TabBar(
      indicatorColor: Colors.orange,
      labelColor: Colors.orange,
      unselectedLabelColor: Colors.black,
      tabs: weeklyList.entries.map((e) => Tab(text: weekdayNameMap[e.key])).toList(),
    );
  }

  /// Tabview
  buildTabview(BuildContext context) {
    return Container(
      height: 400,
      child: TabBarView(
        children: weeklyList.values.map((e) => buildPlaylist(e)).toList(),
      ),
    );
  }

  /// 单个播放列表
  Widget buildPlaylist(List<ListDayItem> list) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var item = list[index];
        List<Widget> titleWidgets = [Text(item.name!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14))];
        if (item.isnew!) {
          titleWidgets.add(SizedBox(width: 4));
          titleWidgets.add(Icon(Icons.new_releases, size: 16, color: Colors.orange));
        }
        return ListTile(
          onTap: () => Navigator.pushNamed(context, "/detail", arguments: {'id': item.id, 'title': item.name}),
          title: Row(children: titleWidgets),
          trailing: Text(item.namefornew!),
          visualDensity: VisualDensity(vertical: -4, horizontal: -4),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: list.length,
    );
  }
}
