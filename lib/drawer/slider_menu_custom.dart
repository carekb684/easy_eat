import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class SliderMenuCustom extends SliderMenuContainer {

  SliderMenuCustom({Color barColor, Key key, Text title, Widget sliderMenu, Widget sliderMain}) : super(
    appBarColor: barColor,
    key: key,
    sliderOpen: SliderOpen.LEFT_TO_RIGHT,
    appBarPadding: const EdgeInsets.only(top: 10),
    sliderMenuOpenOffset: 210,
    appBarHeight: 60,
    drawerIconColor: Colors.white,
    title: title,
    sliderMenu: sliderMenu,
    sliderMain: sliderMain,
  );

  @override
  SliderMenuCustomState createState() => SliderMenuCustomState();

}

class SliderMenuCustomState extends SliderMenuContainerState {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: <Widget>[
          /// Display Menu
          menuWidget(),

          /// Displaying the  shadow
          if (widget.isShadow) ...[
            AnimatedContainer(
              duration:
              Duration(milliseconds: widget.sliderAnimationTimeInMilliseconds),
              curve: Curves.easeIn,
              width: double.infinity,
              height: double.infinity,
              transform: getTranslationValuesForShadow(widget.sliderOpen),
              decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
                BoxShadow(
                  color: widget.shadowColor,
                  blurRadius: widget.shadowBlurRadius, // soften the shadow
                  spreadRadius: widget.shadowSpreadRadius, //extend the shadow
                  offset: Offset(
                    15.0, // Move to right 10  horizontally
                    15.0, // Move to bottom 10 Vertically
                  ),
                )
              ]),
            ),
          ],

          /// Display Main Screen
          AnimatedContainer(
              duration: Duration(milliseconds: widget.sliderAnimationTimeInMilliseconds),
              curve: Curves.easeIn,
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              transform: getTranslationValues(widget.sliderOpen),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: widget.appBarColor,
                      border: Border.all(width: 0, style: BorderStyle.none),
                    ),
                    padding: widget.appBarPadding ?? const EdgeInsets.only(top: 24),
                    child: Row(
                      children: appBar(),
                    ),
                  ),

                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: widget.appBarColor,
                            border: Border.all(width: 0, style: BorderStyle.none),
                          ),
                          child: widget.sliderMain)),
                ],
              )),
        ]));
  }
}