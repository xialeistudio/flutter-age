import 'package:age/lib/model/list_item.dart';
import 'package:age/lib/util.dart';
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
          return Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                // 海报
                Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    Image.network(Util.adaptImageURL(items[index].picSmall!), fit: BoxFit.fitWidth),
                    // 小标题
                    Positioned(
                      right: 4,
                      bottom: 6,
                      child: Container(
                        child: Text(
                          items[index].newTitle!,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, .65),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                // 大标题
                Text(
                  items[index].title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
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
