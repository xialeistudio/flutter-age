/// 详情页动画详情
import 'dart:ui';

import 'package:age/components/poster.dart';
import 'package:age/lib/model/album_info.dart';
import 'package:age/lib/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailAnimationInfo extends StatelessWidget {
  final AnimationInfo info;

  const DetailAnimationInfo({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(info.cover!.asUrl()), fit: BoxFit.fill), color: Colors.black54),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Flex(
                crossAxisAlignment: CrossAxisAlignment.start,
                direction: Axis.horizontal,
                children: [
                  Poster(image: info.coverSmall!, title: info.newTitle!),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: DefaultTextStyle(
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 标题
                            Text(info.title!, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text("${info.region!} · ${info.type!} · ${info.author!}"),
                            SizedBox(height: 8),
                            Text("原版名称：${info.originTitle}"),
                            SizedBox(height: 8),
                            Text("系列名称：${info.collectionTitle}"),
                            SizedBox(height: 8),
                            Text("首播时间：${info.firstPlayTime}"),
                            SizedBox(height: 8),
                            Text("剧情类型：${info.storyType!}"),
                            SizedBox(height: 8),
                            Text("播放状态：${info.playStatus!}"),
                            SizedBox(height: 8),
                            Text("更新时间：${info.updateTime!}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(10),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.local_fire_department_outlined, color: Colors.orange, size: 20),
                SizedBox(width: 4),
                Text("${info.rankCount}"),
              ],
            ),
            Row(
              children: [
                Icon(Icons.comment_outlined, color: Colors.orange, size: 20),
                SizedBox(width: 4),
                Text("${info.commentCount!}"),
              ],
            ),
            Row(
              children: [
                Icon(Icons.star_outline, color: Colors.orange, size: 20),
                SizedBox(width: 4),
                Text("${info.collectCount!}"),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
