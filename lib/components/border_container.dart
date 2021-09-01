import 'package:flutter/cupertino.dart';

class BorderContainer extends StatelessWidget {
  final Widget child;
  bool top;
  bool bottom;
  bool left;
  bool right;
  bool all;

  BorderContainer({
    Key? key,
    required this.child,
    this.top = false,
    this.bottom = true,
    this.left = false,
    this.right = false,
    this.all = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var borderSide = BorderSide(color: Color.fromRGBO(200, 200, 200, 1), width: 0.5);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: all || bottom ? borderSide : BorderSide.none,
          left: all || left ? borderSide : BorderSide.none,
          top: all || top ? borderSide : BorderSide.none,
          right: all || right ? borderSide : BorderSide.none,
        ),
      ),
      child: child,
    );
  }
}
