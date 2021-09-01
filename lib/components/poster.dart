import 'package:age/lib/extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Poster extends StatelessWidget {
  final String image;
  final String title;
  final double scale;

  const Poster({Key? key, required this.image, required this.title, this.scale = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Image(
          image: CachedNetworkImageProvider(image.asUrl(), scale: scale),
          fit: BoxFit.fitWidth,
        ),
        // 小标题
        Positioned(
          right: 4,
          bottom: 4,
          child: Container(
            child: Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, .65),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
      ],
    );
  }
}
