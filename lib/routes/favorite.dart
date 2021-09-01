import 'package:age/components/item_grid_sliver.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/lib/data_manager.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FavoritePageState();
  }
}

class FavoritePageState extends State<FavoritePage> {
  List<ListItem> list = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadData,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: TitleBar(
                  title: "我的收藏",
                  iconData: Icons.favorite,
                  trailing: InkWell(child: Text("清空", style: TextStyle(color: Colors.orange)), onTap: () => confirmClear(context)),
                ),
              ),
              ItemGridSliver(items: list),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    var list = await favoriteManager.load();
    setState(() {
      this.list = list;
    });
  }

  confirmClear(BuildContext context) async {
    var result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("确定清空吗?"),
          actions: [
            TextButton(
                child: Text("清空"),
                onPressed: () async {
                  Navigator.of(context).pop(true);
                }),
            TextButton(
              child: Text("取消"),
              onPressed: () {
                Navigator.of(context).pop(); //关闭对话框
              },
            ),
          ],
        );
      },
    );
    if (!result) {
      return;
    }
    await favoriteManager.clear();
    Fluttertoast.showToast(msg: "清空完成", gravity: ToastGravity.CENTER);
    setState(() {
      list = [];
    });
  }
}
