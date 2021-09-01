import 'package:age/components/poster.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:age/lib/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 动画列表网格
class ItemGridSliver extends StatelessWidget {
  final List<ListItem> items;

  const ItemGridSliver({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ListItemWidget(item: items[index]);
          },
          childCount: items.length,
        ),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          crossAxisSpacing: 8,
          mainAxisExtent: 200,
          maxCrossAxisExtent: 126,
        ),
      ),
    );
  }
}

class ListItemWidget extends StatelessWidget {
  final ListItem item;

  const ListItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Poster(image: item.picSmall!, title: item.newTitle!),
          SizedBox(height: 4),
          // 大标题
          Text(
            item.title!,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: {'id': item.aid, 'title': item.title}),
    );
  }
}
