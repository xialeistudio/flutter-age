import 'package:age/components/item_grid_sliver.dart';
import 'package:age/components/load_more_indicator.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/lib/global.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:age/routes/search.dart';
import 'package:flutter/material.dart';

class RecommendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecommendPageState();
  }
}

class RecommendPageState extends State<RecommendPage> {
  List<ListItem> list = [];
  int count = 0;
  int page = 1;
  bool hasMore = true;
  final int size = 12;

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMainAppBar(context, title: "每日推荐"),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => onRefresh(cached: false),
          child: LoadMoreIndicator(
            onLoadMore: onLoadMore,
            hasMore: hasMore,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: TitleBar(
                    title: "推荐列表",
                    iconData: Icons.recommend,
                    trailing: Row(children: [Text("共"), Text("$count", style: TextStyle(color: Colors.orange)), Text("部")]),
                  ),
                ),
                ItemGridSliver(items: list),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onRefresh({cached = true}) async {
    page = 1;
    var data = await httpClient.loadRecommend(page: page, size: size);
    setState(() {
      list = data.first;
      count = data.second;
      hasMore = data.first.length >= size;
    });
  }

  Future<void> onLoadMore() async {
    var data = await httpClient.loadRecommend(page: ++page, size: size);
    setState(() {
      list.addAll(data.first);
      count = data.second;
      hasMore = data.first.length >= size;
    });
  }
}
