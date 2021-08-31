import 'dart:core';

import 'package:age/components/list_detail_item_widget.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/list_detail_item.dart';
import 'package:age/routes/search.dart';
import 'package:flutter/material.dart';

class CatalogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CatalogPageState();
  }
}

class CatalogPageState extends State<CatalogPage> {
  Map<String, List<String>>? filterData;
  List<ListDetailItem> list = [];
  int count = 0;
  int page = 1;
  final int size = 10;
  bool loading = false;
  bool hasMore = true;
  Map<String, String> filter = {'order': '更新时间'};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(onScroll);
    onRefresh();
  }

  @override
  void dispose() {
    _scrollController.removeListener(onScroll);
    super.dispose();
  }

  /// 下拉刷新
  Future<void> onRefresh({cached = true}) async {
    page = 1;
    var data = await httpClient.loadList(page: page, cached: cached, query: filter);
    setState(() {
      filterData = data.first;
      list = data.second;
      count = data.third;
      hasMore = data.second.length >= size;
      loading = false;
    });
  }

  /// 加载更多
  Future<void> onLoadMore() async {
    var data = await httpClient.loadList(page: ++page, cached: false, query: filter);
    setState(() {
      filterData = data.first;
      list.addAll(data.second);
      count = data.third;
      hasMore = data.second.length >= size;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Icon(Icons.search),
          onTap: () => showSearch(context: context, delegate: SearchBarDelegate()),
        ),
        title: Text('全部动漫'),
      ),
      body: filterData == null ? Center(child: CircularProgressIndicator()) : buildListView(),
    );
  }

  /// 构造列表
  Widget buildListView() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => onRefresh(cached: false),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            ListFilterSliver(filterData: filterData!, filter: filter, onChange: onFilterChange),
            SliverPadding(padding: const EdgeInsets.only(bottom: 10)),
            SliverToBoxAdapter(
              child: TitleBar(
                title: "动漫列表",
                trailing: Row(children: [Text("共"), Text("$count", style: TextStyle(color: Colors.orange)), Text("部")]),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ListDetailItemWidget(item: list[index]);
                },
                childCount: list.length,
              ),
            ),
            SliverToBoxAdapter(child: LoadMoreBar(isLoading: loading, hasMore: hasMore)),
            SliverPadding(padding: const EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }

  /// 筛选器变更回调
  void onFilterChange(String field, String value) {
    setState(() {
      filter[field] = value;
      onRefresh();
    });
  }

  /// 滚动回调
  void onScroll() {
    if (_scrollController.position.pixels != _scrollController.position.maxScrollExtent) {
      return;
    }
    if (!hasMore || loading) {
      return;
    }
    setState(() {
      loading = true;
      onLoadMore();
    });
  }
}

/// 加载更多
class LoadMoreBar extends StatelessWidget {
  final bool isLoading;
  final bool hasMore;

  const LoadMoreBar({Key? key, required this.isLoading, required this.hasMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        alignment: Alignment.center,
        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
        padding: const EdgeInsets.symmetric(vertical: 4),
      );
    }
    if (!hasMore) {
      return Container(
        child: Text('加载完毕', style: TextStyle(color: Colors.grey)),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 4),
      );
    }
    return Container();
  }
}

/// 筛选器变更回调
typedef void FilterChangeCallback(String field, String value);

/// 筛选器
class ListFilterSliver extends StatelessWidget {
  final Map<String, List<String>> filterData;
  final Map<String, String> filter;
  final FilterChangeCallback onChange;

  const ListFilterSliver({
    Key? key,
    required this.filterData,
    required this.filter,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: 40,
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // 字段标识
          var field = filterData.entries.elementAt(index).key;
          var values = filterData.entries.elementAt(index).value;
          // 字段中文名称
          var name = values.elementAt(0);
          // 字段选择项
          var options = values.sublist(1);
          var borderColor = Color.fromRGBO(200, 200, 200, 1);
          // 已选择项目
          var selectedOption = filter[field] ?? '全部';
          if (selectedOption == 'all') {
            selectedOption = '全部';
          }
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: borderColor, width: 0.5, style: BorderStyle.solid)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                SizedBox(
                  width: 40,
                  child: Text(name, style: TextStyle(color: Colors.black), textAlign: TextAlign.right),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var textColor = Colors.black;
                      var option = options[index];
                      if (selectedOption == option) {
                        textColor = Colors.orange;
                      }
                      return InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.center,
                          child: Text(option, textAlign: TextAlign.center, style: TextStyle(color: textColor)),
                        ),
                        onTap: () => onChange(field, option == '全部' ? 'all' : option),
                      );
                    },
                    itemCount: options.length,
                  ),
                ),
              ],
            ),
          );
        },
        childCount: filterData.length,
      ),
    );
  }
}
