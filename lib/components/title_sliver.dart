import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 标题
class TitleSliver extends StatelessWidget {
  final IconData icon;
  final String title;

  const TitleSliver({Key? key, required this.icon, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(icon, color: Colors.black, size: 20),
                  SizedBox(width: 4),
                  Text(title, style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
            ),
            // 列表
          ]),
        ),
      ]),
    );
  }
}
