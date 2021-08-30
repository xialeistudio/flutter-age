import 'dart:collection';
import 'package:age/lib/model/album_info.dart';
import 'package:age/lib/model/list_day_item.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:age/lib/model/slide.dart';
import 'package:dio/dio.dart';

var httpClient = HttpClient();

class HttpClient {
  final String _playKey = 'agefans3382-getplay-1719';
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.agefans.app/v2',
      headers: {
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) Mobile/15E148 Safari/604.1',
      },
    ),
  );

  // 加载轮播图
  Future<List<Slide>> loadSlides() async {
    var response = await _dio.get('/slipic');
    var list = response.data as List;
    Map<String, dynamic> a = HashMap();
    return list.map((e) => Slide.fromJson(e)).toList();
  }

  // 加载首页数据
  Future<Map<String, List<dynamic>>> loadHomeList({updateCount = 12, recommendCount = 12}) async {
    var response = await _dio.get(
      '/home-list',
      queryParameters: {'update': updateCount, 'recommend': recommendCount},
    );
    var data = response.data as Map<String, dynamic>;
    var result = HashMap<String, List<dynamic>>();
    result["recommendList"] = (data["AniPreEvDay"]! as List<dynamic>).map((e) => ListItem.fromJson(e)).toList();
    result["updateList"] = (data["AniPreUP"]! as List<dynamic>).map((e) => ListItem.fromJson(e)).toList();
    result["weekList"] = (data["XinfansInfo"]! as List<dynamic>).map((e) => ListDayItem.fromJson(e)).toList();
    return result;
  }

  /// 获取详情
  Future<List<dynamic>> loadDetail(String id) async {
    var response = await _dio.get("/detail/$id");
    var data = response.data as Map<String, dynamic>;
    var animationInfo = AnimationInfo.fromJson(data["AniInfo"]!);
    var relationList = (data["AniPreRel"]! as List<dynamic>).map((e) => ListItem.fromJson(e)).toList();
    var recommendList = (data["AniPreSim"]! as List<dynamic>).map((e) => ListItem.fromJson(e)).toList();
    var list = [];
    list.add(animationInfo);
    list.add(relationList);
    list.add(recommendList);
    return list;
  }
}
