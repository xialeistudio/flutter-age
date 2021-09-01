import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 标题
class TitleBar extends StatelessWidget {
  final String title;
  final IconData? iconData;
  final double fontSize;
  final Widget? trailing;

  const TitleBar({Key? key, required this.title, this.trailing, this.fontSize = 16, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Expanded(child: Text(title, style: TextStyle(fontSize: fontSize))),
    ];
    if (iconData != null) {
      widgets.insert(0, Icon(iconData, size: 20));
      widgets.insert(1, SizedBox(width: 4));
    }
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
