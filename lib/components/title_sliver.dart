import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 标题
class TitleSliver extends StatelessWidget {
  final String title;

  const TitleSliver({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(8),
        child: Text(title, style: TextStyle(fontSize: 18, color: Colors.black)),
      ),
    );
  }
}
