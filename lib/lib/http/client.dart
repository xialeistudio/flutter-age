import 'dart:collection';
import 'package:age/lib/model/album_info.dart';
import 'package:age/lib/model/list_day_item.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:age/lib/model/slide.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

var httpClient = HttpClient();

class HttpClient {
  static final String _playKey = 'agefans3382-getplay-1719';
  static final String _baseUrl = 'https://api.agefans.app/v2';
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) Mobile/15E148 Safari/604.1',
      },
    ),
  );

  HttpClient() {
    _dio.interceptors.add(DioCacheManager(CacheConfig(baseUrl: _baseUrl)).interceptor);
  }

  // 加载轮播图
  Future<List<Slide>> loadSlides() async {
    var response = await _dio.get('/slipic', options: buildCacheOptions(Duration(hours: 1)));
    var list = response.data as List;
    return list.map((e) => Slide.fromJson(e)).toList();
  }

  // 加载首页数据
  Future<Map<String, List<dynamic>>> loadHomeList({updateCount = 12, recommendCount = 12}) async {
    var response = await _dio.get(
      '/home-list',
      queryParameters: {'update': updateCount, 'recommend': recommendCount},
      options: buildCacheOptions(Duration(hours: 1)),
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
    var response = await _dio.get(
      "/detail/$id",
      options: buildCacheOptions(Duration(hours: 1)),
    );
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
