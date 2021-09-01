import 'dart:core';

import 'package:age/components/list_detail_item_widget.dart';
import 'package:age/components/load_more_indicator.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/lib/global.dart';
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
  bool hasMore = true;
  final int size = 10;
  Map<String, String> filter = {'order': '更新时间'};

  @override
  void initState() {
    super.initState();
    onRefresh();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMainAppBar(context, title: "全部动漫"),
      body: filterData == null ? Center(child: CircularProgressIndicator()) : buildListView(),
    );
  }

  /// 构造列表
  Widget buildListView() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => onRefresh(cached: false),
        child: LoadMoreIndicator(
          hasMore: hasMore,
          onLoadMore: onLoadMore,
          child: CustomScrollView(
            slivers: [
              ListFilterSliver(filterData: filterData!, filter: filter, onChange: onFilterChange),
              SliverPadding(padding: const EdgeInsets.only(bottom: 10)),
              SliverToBoxAdapter(
                child: TitleBar(
                  title: "动漫列表",
                  trailing: Row(children: [Text("共"), Text("$count", style: TextStyle(color: Colors.orange)), Text("部")]),
                  iconData: Icons.list,
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
            ],
          ),
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
