import 'dart:collection';
import 'dart:convert';
import 'package:age/lib/model/album_info.dart';
import 'package:age/lib/model/count_list_item.dart';
import 'package:age/lib/model/list_day_item.dart';
import 'package:age/lib/model/list_detail_item.dart';
import 'package:age/lib/model/list_item.dart';
import 'package:age/lib/model/global_play_config.dart';
import 'package:age/lib/model/pair.dart';
import 'package:age/lib/model/slide.dart';
import 'package:age/lib/model/tunple.dart';
import 'package:age/lib/model/video_info.dart';
import 'package:age/lib/model/video_play_config.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

final httpClient = HttpClient();

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
  Future<List<Slide>> loadSlides({cached = true}) async {
    var response = await _dio.get('/slipic', options: defaultCacheOptions(cached: cached));
    var list = response.data as List;
    return list.map((e) => Slide.fromJson(e)).toList();
  }

  // 加载首页数据
  Future<Map<String, List<dynamic>>> loadHomeList({updateCount = 12, recommendCount = 12, cached = true}) async {
    var response = await _dio.get(
      '/home-list',
      queryParameters: {'update': updateCount, 'recommend': recommendCount},
      options: defaultCacheOptions(cached: cached),
    );
    var data = response.data as Map<String, dynamic>;
    var result = HashMap<String, List<dynamic>>();
    result["recommendList"] = (data["AniPreEvDay"]! as List<dynamic>).map((e) => ListItem.fromJson(e)).toList();
    result["updateList"] = (data["AniPreUP"]! as List<dynamic>).map((e) => ListItem.fromJson(e)).toList();
    result["weekList"] = (data["XinfansInfo"]! as List<dynamic>).map((e) => ListDayItem.fromJson(e)).toList();
    return result;
  }

  /// 获取详情
  Future<List<dynamic>> loadDetail(String id, {cached = true}) async {
    var response = await _dio.get(
      "/detail/$id",
      options: defaultCacheOptions(cached: cached),
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

  Options? defaultCacheOptions({cached = true}) => cached ? buildCacheOptions(Duration(hours: 1)) : null;

  /// 获取全局播放配置
  Future<GlobalPlayConfig> loadGlobalPlayConfig() async {
    var response = await _dio.get('/_getplay', options: defaultCacheOptions());
    return GlobalPlayConfig.fromJson(response.data);
  }

  /// 获取视频播放配置
  Future<VideoPlayConfig> loadVideoPlayConfig(VideoInfo videoInfo, GlobalPlayConfig globalPlayConfig) async {
    var tokenString = "${globalPlayConfig.serverTime}{|}${videoInfo.playId}{|}${videoInfo.playVid}{|}$_playKey";
    var signature = md5.convert(utf8.encode(tokenString)).toString();
    var response = await _dio.get(
      globalPlayConfig.location!,
      queryParameters: {
        'playid': videoInfo.playId,
        'vid': videoInfo.playVid,
        'kt': globalPlayConfig.serverTime,
        'kp': signature,
      },
    );
    return VideoPlayConfig.fromJson(response.data);
  }

  /// 搜索
  Future<Pair<List<ListDetailItem>, int>> search(String keyword, {page = 1}) async {
    var response = await _dio.get(
      '/search',
      queryParameters: {
        'page': page,
        'query': keyword,
      },
    );
    var data = response.data as Map<String, dynamic>;
    var count = data["SeaCnt"]! as int;
    var list = (data["AniPreL"]! as List<dynamic>).map((e) => ListDetailItem.fromJson(e)).toList();
    return Pair(list, count);
  }

  /// 加载列表
  Future<Tuple<Map<String, List<String>>, List<ListDetailItem>, int>> loadList({
    int page = 1,
    int size = 10,
    Map<String, String>? query,
    cached = true,
  }) async {
    query = query ?? {};
    query['page'] = page.toString();
    query['size'] = size.toString();
    var response = await _dio.get(
      '/catalog',
      queryParameters: query,
      options: defaultCacheOptions(cached: cached),
    );
    var data = response.data as Map<String, dynamic>;
    var count = data["AllCnt"]! as int;
    var list = (data["AniPreL"]! as List<dynamic>).map((e) => ListDetailItem.fromJson(e)).toList();
    Map<String, List<String>> filter = {};
    data.entries.forEach((element) {
      var key = element.key;
      if (!key.startsWith("Labels")) {
        return;
      }
      var values = (element.value as List<dynamic>).map((e) => e.toString()).toList();
      filter[values[0]] = values.sublist(1);
    });
    return Tuple.name(filter, list, count);
  }

  /// 推荐
  Future<Pair<List<ListItem>, int>> loadRecommend({page = 1, size = 10, cached = true}) async {
    var response = await _dio.get('/recommend', queryParameters: {'page': page, 'size': size}, options: defaultCacheOptions(cached: cached));
    var data = response.data as Map<String, dynamic>;
    var count = data["AllCnt"]! as int;
    var list = (data["AniPre"]! as List<dynamic>).map((e) => ListItem.fromJson(e)).toList();
    return Pair(list, count);
  }

  /// 最近更新
  Future<Pair<List<ListItem>, int>> loadUpdate({page = 1, size = 10, cached = true}) async {
    var response = await _dio.get('/update', queryParameters: {'page': page, 'size': size}, options: defaultCacheOptions(cached: cached));
    var data = response.data as Map<String, dynamic>;
    var count = data["AllCnt"]! as int;
    var list = (data["AniPre"]! as List<dynamic>).map((e) => ListItem.fromJson(e)).toList();
    return Pair(list, count);
  }

  /// 排行榜
  Future<Pair<List<CountListItem>, int>> loadRank({page = 1, size = 75, int? year, cached = true}) async {
    var params = {'page': page, 'size': size};
    if (year != null && year > 0) {
      params['value'] = year;
    }
    var response = await _dio.get(
      '/rank',
      queryParameters: params,
      options: defaultCacheOptions(cached: cached),
    );
    var data = response.data as Map<String, dynamic>;
    var count = data["AllCnt"]! as int;
    var list = (data["AniRankPre"]! as List<dynamic>).map((e) => CountListItem.fromJson(e)).toList();
    return Pair(list, count);
  }
}
