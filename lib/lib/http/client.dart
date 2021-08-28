import 'dart:convert';

import 'package:age/lib/http/home_slide.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

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
  Future<List<HomeSlide>> loadSlides() async {
    var response = await _dio.get('/slipic');
    var list = response.data as List;
    return list.map((e) => HomeSlide.fromJson(e)).toList();
  }
}
