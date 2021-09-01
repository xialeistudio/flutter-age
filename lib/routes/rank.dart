import 'package:age/components/title_bar.dart';
import 'package:age/lib/global.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/count_list_item.dart';
import 'package:age/routes/search.dart';
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
        child: RefreshIndicator(
          onRefresh: () => onRefresh(cached: false),
          child: CustomScrollView(
            slivers: [
              buildOptionsSliver(),
              SliverPadding(padding: const EdgeInsets.only(top: 10)),
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
      ),
    );
  }

  SliverList buildListSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var item = list[index];
          var color = Colors.grey;
          if (index < 10) {
            color = Colors.orange;
          }
          return Container(
            child: ListTile(
              onTap: () => Navigator.pushNamed(context, "/detail", arguments: {'id': item.aid, 'title': item.title}),
              leading: Container(
                width: 32,
                height: 26,
                alignment: Alignment.center,
                child: Text("${index + 1}", style: TextStyle(color: color)),
                decoration: BoxDecoration(border: Border.all(color: color)),
              ),
              title: Text(item.title!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14)),
              trailing: Text("${item.cCnt}"),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color.fromRGBO(220, 220, 220, 0.5), width: 1, style: BorderStyle.solid))),
          );
        },
        childCount: list.length,
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

  onRefresh({cached = true}) async {
    var data = await httpClient.loadRank(year: year, cached: cached);
    setState(() {
      list = data.first;
      count = data.second;
    });
  }

  buildOptionsSliver() {
    return SliverToBoxAdapter(
      child: Container(
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
    );
  }

  onChange(int option) {
    setState(() {
      year = option;
      onRefresh();
    });
  }
}
