import 'package:flutter/material.dart';


class CatalogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CatalogPageState();
  }
}

class CatalogPageState extends State<CatalogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('目录')),
    );
  }
}
