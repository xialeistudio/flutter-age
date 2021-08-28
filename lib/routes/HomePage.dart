import 'package:age/lib/http/client.dart';
import 'package:age/lib/http/home_slide.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<HomeSlide> _slides = [];

  @override
  void initState() {
    super.initState();
    loadSlides();
  }

  Future<void> loadSlides() async {
    var slides = await httpClient.loadSlides();
    setState(() => _slides = slides);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('首页')),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            buildSlideContainer(screenWidth),
          ],
        ),
      ),
    );
  }

  // 轮播图组件
  Container buildSlideContainer(double screenWidth) {
    return Container(
      height: screenWidth * 0.53,
      child: Swiper(
        itemCount: _slides.length,
        pagination: SwiperPagination(
          builder: SwiperPagination.dots,
          margin: EdgeInsets.only(bottom: 0),
        ),
        itemBuilder: (context, index) {
          return buildSlide(screenWidth, index);
        },
      ),
    );
  }

  // 构造轮播图
  Stack buildSlide(double screenWidth, int index) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        Container(
          width: screenWidth,
          child: Image.network(_slides[index].picUrl!, fit: BoxFit.fill),
        ),
        Container(
          child: Text(
            _slides[index].title!,
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
