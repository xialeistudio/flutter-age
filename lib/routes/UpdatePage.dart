import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdatePageState();
  }
}

class UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('最近更新')),
    );
  }
}
