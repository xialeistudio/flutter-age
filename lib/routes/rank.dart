import 'dart:math';

import 'package:age/components/title_bar.dart';
import 'package:age/lib/global.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/count_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RankPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RankPageState();
  }
}

class RankPageState extends State<RankPage> {
  List<CountListItem> list = [];
  int count = 0;
  int year = 0;
  List<int> years = [0];

  @override
  void initState() {
    super.initState();
    initYears();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMainAppBar(context, title: "排行榜"),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 100.0,
              refreshIndicatorExtent: 60.0,
              onRefresh: () => onRefresh(),
            ),
            buildOptionsSliver(),
            SliverToBoxAdapter(
              child: TitleBar(
                title: "排行榜",
                iconData: Icons.timeline,
                trailing: Row(children: [Text("前"), Text("${list.length}", style: TextStyle(color: Colors.orange)), Text("部")]),
              ),
            ),
            buildListSliver(),
            SliverPadding(padding: const EdgeInsets.only(top: 20)),
          ],
        ),
      ),
    );
  }

  SliverList buildListSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index.isOdd) {
            return Divider();
          }
          var item = list[index ~/ 2];
          var color = Colors.grey;
          if (index < 10) {
            color = Colors.orange;
          }
          return ListTile(
            onTap: () => Navigator.pushNamed(context, "/detail", arguments: {'id': item.aid, 'title': item.title}),
            leading: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: Text("${index + 1}", style: TextStyle(color: color)),
              decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(16)),
            ),
            title: Text(item.title!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14)),
            trailing: Text("${item.cCnt}"),
            visualDensity: VisualDensity(vertical: -4, horizontal: -4),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          );
        },
        childCount: max(0, list.length * 2 - 1),
      ),
    );
  }

  void initYears() {
    List<int> options = [0];
    for (var i = DateTime.now().year; i >= 2000; i--) {
      options.add(i);
    }
    setState(() {
      years = options;
    });
  }

  onRefresh() async {
    var data = await httpClient.loadRank(year: year, cached: false);
    setState(() {
      list = data.first;
      count = data.second;
    });
  }

  buildOptionsSliver() {
    return SliverToBoxAdapter(
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white),
          height: 50,
          child: Flex(
            direction: Axis.horizontal,
            children: [
              SizedBox(
                width: 56,
                child: Text("首播年份", style: TextStyle(color: Colors.black), textAlign: TextAlign.right),
              ),
              SizedBox(width: 5),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var textColor = Colors.black;
                    var option = years[index];
                    if (year == option) {
                      textColor = Colors.orange;
                    }
                    return InkWell(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.center,
                        child: Text((option == 0 ? '全部' : option).toString(), textAlign: TextAlign.center, style: TextStyle(color: textColor)),
                      ),
                      onTap: () => onChange(option),
                    );
                  },
                  itemCount: years.length,
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ]),
    );
  }

  onChange(int option) {
    setState(() {
      year = option;
      onRefresh();
    });
  }
}
