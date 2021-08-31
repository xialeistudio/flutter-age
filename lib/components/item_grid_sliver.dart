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
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return GridItem(item: items[index]);
        },
        childCount: items.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        crossAxisCount: 3,
        childAspectRatio: 0.62,
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final ListItem item;

  const GridItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Poster(image: item.picSmall!, title: item.newTitle!),
            SizedBox(height: 4),
            // 大标题
            Text(
              item.title!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      onTap: () => Navigator.pushNamed(context, '/detail', arguments: {'id': item.aid, 'title': item.title}),
    );
  }
}
