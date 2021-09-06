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
  final ScrollController _scrollController = ScrollController();

  List<CountListItem> _list = [];
  int _count = 0;
  int _year = 0;
  List<int> _years = [0];
  bool _showGoTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(listenForGoTop);
    initYears();
    onRefresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 返回顶部监听
  void listenForGoTop() {
    if (_scrollController.offset < 1000 && _showGoTopButton) {
      setState(() {
        _showGoTopButton = false;
      });
    } else if (_scrollController.offset >= 1000 && !_showGoTopButton) {
      setState(() {
        _showGoTopButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMainAppBar(context, title: "排行榜"),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              buildOptionsSliver(),
              SliverToBoxAdapter(
                child: TitleBar(
                  title: "排行榜",
                  iconData: Icons.timeline,
                  trailing: Row(children: [Text("前"), Text("${_list.length}", style: TextStyle(color: Colors.orange)), Text("部")]),
                ),
              ),
              buildListSliver(),
              SliverPadding(padding: const EdgeInsets.only(top: 20)),
            ],
          ),
        ),
      ),
      floatingActionButton: _showGoTopButton
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
              },
              child: Icon(Icons.arrow_upward),
            )
          : null,
    );
  }

  SliverList buildListSliver() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index.isOdd) {
            return Divider();
          }
          var item = _list[index ~/ 2];
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
        childCount: _list.length * 2,
      ),
    );
  }

  void initYears() {
    List<int> options = [0];
    for (var i = DateTime.now().year; i >= 2000; i--) {
      options.add(i);
    }
    setState(() {
      _years = options;
    });
  }

  Future<void> onRefresh() async {
    var data = await httpClient.loadRank(year: _year, cached: false);
    setState(() {
      _list = data.first;
      _count = data.second;
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
                    var option = _years[index];
                    if (_year == option) {
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
                  itemCount: _years.length,
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
      _year = option;
      onRefresh();
    });
  }
}
