import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'model/list_item.dart';

final historyManager = HistoryManager();

/// 播放历史
class HistoryManager {
  static const KEY = "HISTORY";

  Future<List<ListItem>> load() async {
    var prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(KEY);
    if (value == null || value.isEmpty) {
      return [];
    }
    var list = jsonDecode(value) as List<dynamic>;
    return list.map((e) => ListItem.fromJson(e)).toList();
  }

  Future<void> add(ListItem item) async {
    var list = await load();
    // 存在，删除掉
    if (list.contains(item)) {
      list.remove(item);
    }
    // 插入
    list.insert(0, item);
    // 最多缓存100条
    if (list.length > 100) {
      list.removeLast();
    }

    var string = jsonEncode(list);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(KEY, string);
  }

  Future<void> clear() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(KEY);
  }
}
