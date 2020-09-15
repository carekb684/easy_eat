import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HeroHeader implements SliverPersistentHeaderDelegate {

  HeroHeader({
    this.heroText,
    this.heroSubText,
    this.minExtent,
    this.maxExtent,
    this.imgUrl,
  });

  double maxExtent;
  double minExtent;
  String heroText;
  String heroSubText;
  String imgUrl;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: imgUrl,
          //placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.fitWidth,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black54,
              ],
              stops: [0.5, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Positioned(
          left: 4.0,
          top: 4.0,
          child: SafeArea(
            child: RawMaterialButton(
              child: Icon(Icons.arrow_back, color: Colors.white),
              shape: CircleBorder(),
              fillColor: Theme.of(context).primaryColorDark,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Positioned(
          left: 16.0,
          right: 16.0,
          bottom: 30.0,
          child: Text(
            heroText,
            style: TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        Positioned(
          left: 19.0,
          right: 16.0,
          bottom: 15.0,
          child: Text(
            heroSubText,
            style: TextStyle(fontSize: 12.0, color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();
}
