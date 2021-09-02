import 'package:age/components/item_grid_sliver.dart';
import 'package:age/components/load_more_indicator.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/lib/global.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:age/routes/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdatePageState();
  }
}

class UpdatePageState extends State<UpdatePage> {
  List<ListItem> list = [];
  int count = 0;
  int page = 1;
  bool hasMore = true;
  final int size = 30;

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("最近更新")),
      body: SafeArea(
        child: LoadMoreIndicator(
          onLoadMore: onLoadMore,
          hasMore: hasMore,
          child: CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                refreshTriggerPullDistance: 100.0,
                refreshIndicatorExtent: 60.0,
                onRefresh: () => onRefresh(cached: false),
              ),
              SliverToBoxAdapter(
                child: TitleBar(
                  title: "最近更新",
                  iconData: Icons.update,
                  trailing: Row(children: [Text("共"), Text("$count", style: TextStyle(color: Colors.orange)), Text("部")]),
                ),
              ),
              ItemGridSliver(items: list),
            ],
          ),
        ),
      ),
    );
  }

  onRefresh({cached = true}) async {
    page = 1;
    var data = await httpClient.loadUpdate(page: page, size: size);
    setState(() {
      list = data.first;
      count = data.second;
      hasMore = data.first.length >= size;
    });
  }

  Future<void> onLoadMore() async {
    var data = await httpClient.loadUpdate(page: ++page, size: size);
    setState(() {
      list.addAll(data.first);
      count = data.second;
      hasMore = data.first.length >= size;
    });
  }
}
