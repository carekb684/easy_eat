import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class SliderMenuCustom extends StatefulWidget{

  final bool twoDrawers;

  final Widget sliderMenu;
  final Widget sliderMenu2;
  final Widget sliderMain;
  final int sliderAnimationTimeInMilliseconds;
  final double sliderMenuOpenOffset;
  final double sliderMenu2OpenOffset;
  final double sliderMenuCloseOffset;

  final Color drawerIconColor;
  final Widget drawerIcon;
  final double drawerIconSize;
  final double appBarHeight;
  final Widget title;
  final bool isTitleCenter;
  final bool isShadow;
  final Color shadowColor;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;

  final Widget trailing;
  final Color appBarColor;
  final EdgeInsets appBarPadding;

  const SliderMenuCustom({
    this.twoDrawers,
    Key key,
    this.sliderMenu,
    this.sliderMenu2,
    this.sliderMain,
    this.sliderAnimationTimeInMilliseconds = 200,
    this.sliderMenuOpenOffset = 265,
    this.sliderMenu2OpenOffset = 265,
    this.drawerIconColor = Colors.black,
    this.drawerIcon,
    this.isTitleCenter = true,
    this.trailing,
    this.appBarColor = Colors.white,
    this.appBarPadding,
    this.title,
    this.drawerIconSize = 27,
    this.appBarHeight,
    this.sliderMenuCloseOffset = 0,
    this.isShadow = false,
    this.shadowColor = Colors.grey,
    this.shadowBlurRadius = 25.0,
    this.shadowSpreadRadius = 5.0,
  })  : assert(sliderMenu != null),
        assert(sliderMain != null),
        super(key: key);



  @override
  SliderMenuCustomState createState() => SliderMenuCustomState();

}

class SliderMenuCustomState extends State<SliderMenuCustom>
    with SingleTickerProviderStateMixin {

  double _slideBarXOffset = 0;
  double _slideBarYOffset = 0;
  bool _isSlideBarOpen = false;
  AnimationController _animationController;

  SliderOpen sliderOpen = SliderOpen.LEFT_TO_RIGHT;

  Widget drawerIcon;

  /// check whether drawer is open
  bool get isDrawerOpen => _isSlideBarOpen;

  /// Toggle drawer
  void toggle(SliderOpen open) {
    setState(() {
      sliderOpen = open;
      _isSlideBarOpen
          ? _animationController.reverse()
          : _animationController.forward();

      _slideBarXOffset = _isSlideBarOpen
          ? widget.sliderMenuCloseOffset
          : sliderOpen == SliderOpen.LEFT_TO_RIGHT ?
      widget.sliderMenuOpenOffset : widget.sliderMenu2OpenOffset;

      _isSlideBarOpen = !_isSlideBarOpen;
    });
  }


  /// Open drawer
  void openDrawer() {
    setState(() {
      sliderOpen = SliderOpen.LEFT_TO_RIGHT;
      _animationController.forward();
      _slideBarXOffset = widget.sliderMenuOpenOffset;

      _isSlideBarOpen = true;
    });
  }

  /// Close drawer
  void closeDrawer() {
    setState(() {
      _animationController.reverse();
      if (sliderOpen == SliderOpen.LEFT_TO_RIGHT ||
          sliderOpen == SliderOpen.RIGHT_TO_LEFT) {
        _slideBarXOffset = widget.sliderMenuCloseOffset;
      } else {
        _slideBarYOffset = widget.sliderMenuCloseOffset;
      }
      _isSlideBarOpen = false;
    });
  }
  /// Open drawer
  void openDrawer2() {
    setState(() {
      sliderOpen = SliderOpen.RIGHT_TO_LEFT;
      _animationController.forward();
      _slideBarXOffset = widget.sliderMenu2OpenOffset;

      _isSlideBarOpen = true;
    });
  }

  /// Close drawer
  void closeDrawer2() {
    setState(() {
      sliderOpen = SliderOpen.RIGHT_TO_LEFT;
      _animationController.reverse();
      _slideBarXOffset = widget.sliderMenuCloseOffset;

      _isSlideBarOpen = false;
    });
  }


  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration:
        Duration(milliseconds: widget.sliderAnimationTimeInMilliseconds));
  }

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
              transform: getTranslationValuesForShadow(sliderOpen),
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
              transform: getTranslationValues(sliderOpen),
              child: Column(
                children: <Widget>[
                  Container(
                    color: widget.appBarColor,

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

  List<Widget> appBar() {
    List<Widget> list = [
      widget.drawerIcon ??
          IconButton(
              icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  color: widget.drawerIconColor,
                  size: widget.drawerIconSize,
                  progress: _animationController),
              onPressed: () {
                toggle(SliderOpen.LEFT_TO_RIGHT);
              }),
      Expanded(
        child: widget.isTitleCenter
            ? Center(
          child: widget.title,
        )
            : widget.title,
      ),

      get2ndDrawerIcon(),

    ];

    //ugly solution
    //if (sliderOpen == SliderOpen.RIGHT_TO_LEFT) {
      //return list.reversed.toList();
    //}
    return list;
  }

  /// Build and Align the Menu widget based on the slide open type
  menuWidget() {
    switch (sliderOpen) {
      case SliderOpen.LEFT_TO_RIGHT:
        return Container(
          width: widget.sliderMenuOpenOffset,
          child: widget.sliderMenu,
        );
        break;
      case SliderOpen.RIGHT_TO_LEFT:
        return Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: widget.sliderMenu2OpenOffset,
            child: widget.sliderMenu2,
          ),
        );
      case SliderOpen.TOP_TO_BOTTOM:
        return Positioned(
          right: 0,
          left: 0,
          top: 0,
          child: Container(
            width: widget.sliderMenuOpenOffset,
            child: widget.sliderMenu,
          ),
        );
        break;
    }
  }

  ///
  /// This method get Matrix4 data base on [sliderOpen] type
  ///

  Matrix4 getTranslationValues(SliderOpen sliderOpen) {
    switch (sliderOpen) {
      case SliderOpen.LEFT_TO_RIGHT:
        return Matrix4.translationValues(
            _slideBarXOffset, _slideBarYOffset, 1.0);
      case SliderOpen.RIGHT_TO_LEFT:
        return Matrix4.translationValues(
            -_slideBarXOffset, _slideBarYOffset, 1.0);

      case SliderOpen.TOP_TO_BOTTOM:
        return Matrix4.translationValues(0, _slideBarYOffset, 1.0);

      default:
        return Matrix4.translationValues(0, 0, 1.0);
    }
  }

  Matrix4 getTranslationValuesForShadow(SliderOpen sliderOpen) {
    switch (sliderOpen) {
      case SliderOpen.LEFT_TO_RIGHT:
        return Matrix4.translationValues(
            _slideBarXOffset - 30, _slideBarYOffset, 1.0);
      case SliderOpen.RIGHT_TO_LEFT:
        return Matrix4.translationValues(
            -_slideBarXOffset - 5, _slideBarYOffset, 1.0);

      case SliderOpen.TOP_TO_BOTTOM:
        return Matrix4.translationValues(0, _slideBarYOffset - 20, 1.0);

      default:
        return Matrix4.translationValues(0, 0, 1.0);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Widget get2ndDrawerIcon() {
    if (widget.twoDrawers) {

      return IconButton(
          onPressed: () {
            toggle(SliderOpen.RIGHT_TO_LEFT);
          },
          icon: Icon(_isSlideBarOpen ? Icons.close : Icons.settings, color: Colors.white, size: 27,));
    }

    return widget.trailing ?? SizedBox(width: 35,);
  }

  void rightSwipe() {
    if (isDrawerOpen) {
      if(sliderOpen == SliderOpen.RIGHT_TO_LEFT) {
        closeDrawer2();
      }
    } else {
      openDrawer();
    }
  }

  void leftSwipe() {
    if (isDrawerOpen) {
      if(sliderOpen == SliderOpen.LEFT_TO_RIGHT) {
        closeDrawer();
      }
    } else if (widget.twoDrawers){
      openDrawer2();
    }
  }

}