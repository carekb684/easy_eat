import 'package:easy_eat/services/db_helper.dart';
import 'package:easy_eat/services/spoonacular.dart';
import 'package:easy_eat/util/color_from_hex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'drawer/slider_drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DBHelper dbHelper;

  @override
  void initState() {
    super.initState();
    getDB();
  }

  @override
  Widget build(BuildContext context) {

    return LoadDbThenShowPage(context);
  }

  getDB() async {
    final Future<Database> future = DBHelper.init();

    future.then((value){
      setState(() {
        dbHelper = DBHelper(db: value);
      });
    });
  }

  Widget LoadDbThenShowPage(BuildContext context) {
    if (dbHelper == null) {
      return Container(
        color: HexColor.fromHex("#ef5e2a"),
      );
    } else {
      return MultiProvider(
        providers: [
          Provider<SpoonService>( create: (_) => SpoonService()),
          Provider<DBHelper>( create: (_) => dbHelper),
        ],

        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              accentColor: HexColor.fromHex("#ef5e2a"),
              primaryColor: HexColor.fromHex("#ef5e2a"), // usage color: Theme.of(context).
              primaryColorDark: HexColor.fromHex("#b52b00"),
              primaryColorLight: HexColor.fromHex("#ff8f57"),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: SlideDrawer(),
            routes: {
              //"/profile": (context) => MyProfile(),
              "/screens.home": (context) => SlideDrawer(),
            }
        ),
      );
    }

  }
}

