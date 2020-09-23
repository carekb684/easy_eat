import 'package:easy_eat/drawer/search_drawer_right.dart';
import 'package:easy_eat/drawer/slider_menu_custom.dart';
import 'package:easy_eat/screens/favorite/favorites.dart';
import 'package:easy_eat/screens/fridge/fridge.dart';
import 'package:easy_eat/screens/home/home.dart';
import 'package:easy_eat/screens/ingredient_recipe_search/ingredient_recipe_search.dart';
import 'package:easy_eat/screens/recipes_search/recipes_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:provider/provider.dart';

import 'drawer_menu.dart';

class SlideDrawer extends StatefulWidget {
  SlideDrawer({Key key}) : super(key: key);

  @override
  _SlideDrawerState createState() => _SlideDrawerState();
}

class _SlideDrawerState extends State<SlideDrawer> {

  GlobalKey<SliderMenuCustomState> _key = new GlobalKey<SliderMenuCustomState>();

  GlobalKey<DrawerSearchMenuState> _drawerSearchkey = new GlobalKey<DrawerSearchMenuState>();

  String titleHeader = "Home";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          color: Theme.of(context).primaryColorDark,

          child: SafeArea(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if(details.primaryVelocity > 0){
                  //_key.currentState.toggle(SliderOpen.LEFT_TO_RIGHT);
                  _key.currentState.rightSwipe();
                } else if (details.primaryVelocity < 0) {
                  //_key.currentState.toggle(SliderOpen.RIGHT_TO_LEFT);
                  _key.currentState.leftSwipe();
                }
              },
              child: SliderMenuCustom(
                appBarColor: Theme.of(context).primaryColor,
                key: _key,
                twoDrawers: titleHeader == "Recipes" ? true : false,
                sliderMenu2: titleHeader == "Recipes" ? DrawerSearchMenu(key: _drawerSearchkey,) : null,
                drawerIconColor: Colors.white,
                appBarPadding: const EdgeInsets.only(top: 10),
                sliderMenuOpenOffset: 210,
                sliderMenu2OpenOffset: 280,
                appBarHeight: 60,
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

        ),
    );
  }

  Widget getPageWidget() {
    Widget page;
    switch(titleHeader) {
      case "Home": { page=Home(); break;}
      case "Favorites": { page=Favorites(); break;}
      case "Fridge": { page=Fridge(); break;}
      case "Recipes": {
        page=Provider<GlobalKey<DrawerSearchMenuState>>(
          create: (_) => _drawerSearchkey,
          child: Recipes()); break;
      }
      case "What can I cook?": { page=IngredientRecipes(); break;}
      default: { page=Home(); break;}
    }

    return page;

  }
}

