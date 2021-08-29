import 'package:age/lib/http/client.dart';
import 'package:age/lib/model/slide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
/// 轮播图组件
class Swipe extends StatelessWidget {
  final List<Slide> items;

  Swipe({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.53,
      child: Swiper(
        itemCount: items.length,
        pagination: SwiperPagination(
          builder: SwiperPagination.dots,
          // margin: EdgeInsets.only(bottom: 0),
        ),
        itemBuilder: (context, index) {
          return SwipeItem(slide: items[index]);
        },
      ),
    );
  }
}

/// 轮播图图片
class SwipeItem extends StatelessWidget {
  final Slide slide;

  SwipeItem({required this.slide});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        Container(
          width: screenWidth,
          child: Image.network(slide.picUrl!, fit: BoxFit.fill),
        ),
        Container(
          child: Text(
            slide.title!,
            style: TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(color: Color.fromRGBO(64, 64, 64, .5)),
          width: screenWidth,
        )
      ],
    );
  }
}
