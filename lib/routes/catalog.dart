import 'dart:core';

import 'package:age/components/list_detail_item_widget.dart';
import 'package:age/components/load_more_indicator.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/lib/global.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/list_detail_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CatalogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CatalogPageState();
  }
}

class CatalogPageState extends State<CatalogPage> {
  final int size = 10;
  final ScrollController _scrollController = ScrollController();

  Map<String, List<String>>? _filterData;
  List<ListDetailItem> _list = [];
  int _count = 0;
  int _page = 1;
  bool _hasMore = true;
  Map<String, String> _filter = {'order': '更新时间'};
  bool _showGoTopButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(listenForGoTop);
    onRefresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 下拉刷新
  Future<void> onRefresh({cached = true}) async {
    _page = 1;
    var data = await httpClient.loadList(page: _page, cached: cached, query: _filter);
    setState(() {
      _filterData = data.first;
      _list = data.second;
      _count = data.third;
      _hasMore = data.second.length >= size;
    });
  }

  /// 加载更多
  Future<void> onLoadMore() async {
    var data = await httpClient.loadList(page: ++_page, cached: false, query: _filter);
    setState(() {
      _filterData = data.first;
      _list.addAll(data.second);
      _count = data.third;
      _hasMore = data.second.length >= size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMainAppBar(context, title: "全部动漫"),
      body: _filterData == null ? Center(child: CupertinoActivityIndicator()) : buildListView(),
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

  /// 构造列表
  Widget buildListView() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => onRefresh(cached: false),
        child: LoadMoreIndicator(
          hasMore: _hasMore,
          onLoadMore: onLoadMore,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              ListFilterSliver(filterData: _filterData!, filter: _filter, onChange: onFilterChange),
              SliverPadding(padding: const EdgeInsets.only(bottom: 10)),
              SliverToBoxAdapter(
                child: TitleBar(
                  title: "动漫列表",
                  trailing: Row(children: [Text("共"), Text("$_count", style: TextStyle(color: Colors.orange)), Text("部")]),
                  iconData: Icons.list,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index.isOdd) {
                      return Divider();
                    }
                    return ListDetailItemWidget(item: _list[index ~/ 2]);
                  },
                  childCount: _list.length * 2,
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
      _filter[field] = value;
      onRefresh();
    });
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
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index.isOdd) {
            return Divider();
          }
          // 字段标识
          var field = filterData.entries.elementAt(index ~/ 2).key;
          var values = filterData.entries.elementAt(index ~/ 2).value;
          // 字段中文名称
          var name = values.elementAt(0);
          // 字段选择项
          var options = values.sublist(1);
          // 已选择项目
          var selectedOption = filter[field] ?? '全部';
          if (selectedOption == 'all') {
            selectedOption = '全部';
          }
          return Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                SizedBox(width: 40, child: Text(name, style: TextStyle(color: Colors.black), textAlign: TextAlign.right)),
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
        childCount: filterData.length * 2,
      ),
    );
  }
}
