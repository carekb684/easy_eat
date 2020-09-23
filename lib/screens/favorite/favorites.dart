import 'package:easy_eat/models/detail_recipe_model.dart';
import 'package:easy_eat/screens/home/recipe_scroll_grid.dart';
import 'package:easy_eat/services/db_helper.dart';
import 'package:easy_eat/services/spoonacular.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  DBHelper db;
  SpoonService spoonService;

  List<String> favoritesId;

  Future<List<DetailRecipeModel>> favoriteRecipes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    db = Provider.of<DBHelper>(context, listen: false);
    spoonService = Provider.of<SpoonService>(context, listen: false);

    getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      width:double.infinity,
      child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top:20),
          child: FutureBuilder<List<DetailRecipeModel>>(
            future: favoriteRecipes,
            builder: (BuildContext context, AsyncSnapshot<List<DetailRecipeModel>> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data.isEmpty) {
                  return Text(
                    "No recipes favorited yet :(",
                    style: TextStyle(color: Colors.white),
                  );
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: double.infinity),
                  child: RecipeGrid(scrollable: false, detailRecipes: snapshot.data),
                );

              } else {
                return CircularProgressIndicator();
              }
            },
          ),),
    );
  }

  void getRecipes() async {
    favoritesId = await db.getFavorites();
    setState(() {
      favoriteRecipes = spoonService.getRecipesBulk(favoritesId.join(","));
    });
  }
}
