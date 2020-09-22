import 'package:easy_eat/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {

  DBHelper db;

  List<String> favorites;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    db = Provider.of<DBHelper>(context, listen: false);
    db.getFavorites().then((value) {
      setState(() {
        favorites = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: getFavorites(),);
  }

  Widget getFavorites() {
    if( favorites == null) {
      return CircularProgressIndicator();
    }
    return Text(favorites.join(", "));
  }
}
