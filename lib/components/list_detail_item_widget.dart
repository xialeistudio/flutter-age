import 'package:age/components/poster.dart';
import 'package:age/lib/model/list_detail_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListDetailItemWidget extends StatelessWidget {
  final ListDetailItem item;

  const ListDetailItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.horizontal,
          children: [
            Poster(image: item.cover!, title: item.newTitle!, scale: 1.2),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: DefaultTextStyle(
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("${item.type!} · ${item.author!}"),
                      SizedBox(height: 8),
                      Text("原版名称：${item.originTitle}"),
                      SizedBox(height: 8),
                      Text("首播时间：${item.firstPlayTime}"),
                      SizedBox(height: 8),
                      Text("剧情类型：${item.storyTypes!.join(" ")}"),
                      SizedBox(height: 8),
                      Text("播放状态：${item.playStatus!}"),
                    ],
                  ),
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
