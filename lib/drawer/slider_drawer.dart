import 'package:easy_eat/screens/fridge/fridge.dart';
import 'package:easy_eat/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import 'drawer_menu.dart';

class SlideDrawer extends StatefulWidget {
  SlideDrawer({Key key}) : super(key: key);

  @override
  _SlideDrawerState createState() => _SlideDrawerState();
}

class _SlideDrawerState extends State<SlideDrawer> {

  GlobalKey<SliderMenuContainerState> _key = new GlobalKey<SliderMenuContainerState>();

  String titleHeader = "Home";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColorDark,
        child: SafeArea(
          child: SliderMenuContainer(
            appBarColor: Theme.of(context).primaryColor,
            key: _key,
            sliderOpen: SliderOpen.LEFT_TO_RIGHT,
            appBarPadding: const EdgeInsets.only(top: 10),
            sliderMenuOpenOffset: 210,
            appBarHeight: 60,
            drawerIconColor: Colors.white,
            title: Text(
              titleHeader,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            sliderMenu: DrawerMenuWidget(
              onItemClick: (title) {
                _key.currentState.closeDrawer();
                setState(() {
                  titleHeader = title;
                });
              },
            ),
            sliderMain: getPageWidget(),
          ),
        ),
      ),
    );
  }

  Widget getPageWidget() {
    Widget page;
    switch(titleHeader) {
      case "Home": { page=Home(); break;}
      case "Fridge": { page=Fridge(); break;}
      default: { page=Home(); break;}
    }

    return page;

  }
}
