import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 标题
class TitleBar extends StatelessWidget {
  final String title;

  const TitleBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color.fromRGBO(220, 220, 220, 0.5), width: 0.5, style: BorderStyle.solid),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Text(title, style: TextStyle(fontSize: 18, color: Colors.black)),
    );
  }
}
