import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 标题
class TitleBar extends StatelessWidget {
  final String title;
  final double fontSize;
  final Widget? trailing;

  const TitleBar({Key? key, required this.title, this.trailing, this.fontSize = 18}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Expanded(child: Text(title, style: TextStyle(fontSize: fontSize, color: Colors.black))),
    ];
    if (trailing != null) {
      widgets.add(trailing!);
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color.fromRGBO(220, 220, 220, 0.5), width: 0.5, style: BorderStyle.solid),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Flex(direction: Axis.horizontal, children: widgets),
    );
  }
}
