import 'package:easy_eat/animations/fade_animation.dart';
import 'package:easy_eat/drawer/search_drawer_right.dart';
import 'package:easy_eat/models/sql/ingridient_model.dart';
import 'package:easy_eat/models/thin_recipe.dart';
import 'package:easy_eat/screens/home/recipe_scroll_grid.dart';
import 'package:easy_eat/services/db_helper.dart';
import 'package:easy_eat/services/spoonacular.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

class Recipes extends StatefulWidget {
  @override
  _RecipesState createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {

  SpoonService spoonServ;
  Future<List<ThinRecipe>> recipes;

  GlobalKey<DrawerSearchMenuState> drawerSearchKey;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    spoonServ = Provider.of<SpoonService>(context, listen: false);
    drawerSearchKey = Provider.of<GlobalKey<DrawerSearchMenuState>>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[

              SizedBox(height: 20,),
              getHeader(),
              SizedBox(height: 20,),

              FutureBuilder<List<ThinRecipe>>(
                future: recipes,
                builder: (BuildContext context, AsyncSnapshot<List<ThinRecipe>> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data.isEmpty) {
                      return Text(
                        "No recipes found :(",
                        style: TextStyle(color: Colors.white),
                      );
                    }

                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: double.infinity),
                      child: RecipeGrid(scrollable: false, thinRecipes: snapshot.data),
                    );

                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),


              SizedBox(height: 20,),

            ]),
          ),
      ),
    );
  }

 Widget getHeader() {

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage('assets/images/food_recipes_header.jpg'),
            fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(begin: Alignment.bottomRight,
                colors: [
                  Colors.transparent,
                  Colors.black38,
                  //Colors.black.withOpacity(.8),
                  //Colors.black.withOpacity(.2),
                ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FadeAnimation(1,
                Text(
                  "What you would like to find?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 30,
            ),
            FadeAnimation(1.3,
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        hintText: "Search for recipes..."),
                        onSubmitted: (value) {
                          if (value.isEmpty) {
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter some text before searching."),));
                          } else {
                            String diet = drawerSearchKey.currentState.diet;
                            String type = drawerSearchKey.currentState.type;
                            var intolerances = drawerSearchKey.currentState.intolerances;
                            String sorting = drawerSearchKey.currentState.sorting;
                            searchRecipes(value, diet, type, sorting, intolerances);
                          }

                        },
                  ),
                )),
            SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }

  void searchRecipes(String value, String diet, String type, String sort, Map<String, bool> intolerances) {
    List<String> intolList = [];
    intolerances.forEach((key, value) {
      if (value) intolList.add(key);
    });
    String intolStr = intolList.join(",");

    setState(() {
      recipes = spoonServ.fullSearch(value, type, diet, sort, intolStr, 6);
    });

  }


}
