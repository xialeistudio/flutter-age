import 'package:age/components/poster.dart';
import 'package:age/lib/model/list_detail_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListDetailItemWidget extends StatelessWidget {
  final ListDetailItem item;

  const ListDetailItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var borderColor = Color.fromRGBO(200, 200, 200, 1);
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: borderColor, width: 0.5, style: BorderStyle.solid)),
        ),
        padding: const EdgeInsets.all(8),
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.horizontal,
          children: [
            Poster(image: item.cover!, title: item.newTitle!, scale: 1.2),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Text(
                      item.title!,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    // 元数据
                    Text(
                      "${item.type!} · ${item.author!}",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "原版名称：${item.originTitle}",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "首播时间：${item.firstPlayTime}",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "剧情类型：${item.storyTypes!.join(" ")}",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "播放状态：${item.playStatus!}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => Navigator.pushNamed(context, "/detail", arguments: {'id': item.aid, 'title': item.title}),
    );
  }
}
