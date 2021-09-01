import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'model/list_item.dart';

final historyManager = DataManager(key: "history");
final favoriteManager = DataManager(key: "favorite");

/// 数据管理器
class DataManager {
  final String key;

  DataManager({required this.key});

  Future<bool> exists(ListItem item) async {
    var list = await load();
    return list.contains(item);
  }

  Future<List<ListItem>> load() async {
    var prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(key);
    if (value == null || value.isEmpty) {
      return [];
    }
    var list = jsonDecode(value) as List<dynamic>;
    return list.map((e) => ListItem.fromJson(e)).toList();
  }

  Future<void> remove(ListItem item) async {
    var list = await load();
    // 存在，删除掉
    if (list.contains(item)) {
      list.remove(item);
    }
    var string = jsonEncode(list);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(key, string);
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
    prefs.setString(key, string);
  }

  Future<void> clear() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
