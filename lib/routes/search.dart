import 'package:age/components/list_detail_item_widget.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/list_detail_item.dart';
import 'package:age/lib/model/pair.dart';
import 'package:flutter/material.dart';

/// 搜索页
class SearchBarDelegate extends SearchDelegate<String> {
  final List<ListDetailItem> list = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        query = "";
        if (query.isEmpty) {
          close(context, "");
          return;
        }
        showSuggestions(context);
      },
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text("搜索动画"),
      );
    }
    return FutureBuilder<Pair<List<ListDetailItem>, int>>(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          }
          return buildSearchList(snapshot.data!);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      future: httpClient.search(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("搜索动画"),
    );
  }

  /// 搜索列表
  Widget buildSearchList(Pair<List<ListDetailItem>, int> data) {
    var list = data.first;
    var count = data.second;
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: TitleBar(
            fontSize: 16,
            title: "[$query]搜索结果",
            leading: Row(children: [Text("共"), Text("$count", style: TextStyle(color: Colors.orange)), Text("部")]),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ListDetailItemWidget(item: list[index]);
            },
            childCount: count,
          ),
        ),
      ],
    );
  }
}
