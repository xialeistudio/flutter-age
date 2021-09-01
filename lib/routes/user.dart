import 'package:age/components/item_grid_sliver.dart';
import 'package:age/components/title_bar.dart';
import 'package:age/lib/global.dart';
import 'package:age/lib/history_manager.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserPageState();
  }
}

class UserPageState extends State<UserPage> {
  List<ListItem> historyList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    var history = await historyManager.load();
    setState(() {
      historyList = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("我的")),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: buildHistoryTitleBar(context)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: ListItemWidget(item: historyList[index]),
                      );
                    },
                    itemCount: historyList.length,
                    itemExtent: 126,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TitleBar buildHistoryTitleBar(BuildContext context) {
    return TitleBar(
      title: "历史记录",
      iconData: Icons.history,
      trailing: SizedBox(
        width: 24,
        height: 24,
        child: IconButton(
          onPressed: () => Navigator.pushNamed(context, "/history"),
          icon: Icon(Icons.arrow_forward_ios),
          iconSize: 18,
          padding: const EdgeInsets.all(0),
        ),
      ),
    );
  }
}
