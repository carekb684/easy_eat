import 'package:easy_eat/models/detail_recipe_model.dart';
import 'package:easy_eat/models/thin_recipe.dart';
import 'package:easy_eat/services/db_helper.dart';
import 'package:easy_eat/services/spoonacular.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

import 'hero_header.dart';

class RecipeDetail extends StatefulWidget {

  RecipeDetail({this.thinRecipe, this.detailRecipe});
  ThinRecipe thinRecipe;
  DetailRecipeModel detailRecipe;

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {

  SpoonService spoonService;
  String heroSubText = "5.0 servings in 45 minutes";

  _RecipeDetailState() {
    recipe = DetailRecipeModel();
    recipe.spoonScore = 0;
    recipe.servings = "";
    recipe.id = "";
    recipe.name = "";
    recipe.imgUrl = "";
    recipe.readyInMinutes = "";
    recipe.instructions = "";
    recipe.summary = "";
    recipe.ingredients = [];

  }
  DetailRecipeModel recipe;

  DBHelper db;
  bool isFavourite;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    spoonService = Provider.of<SpoonService>(context, listen: false);

    if (widget.detailRecipe == null) {
      spoonService.getRecipe(widget.thinRecipe.id).then((value) {
        setState(() {
          recipe = value;
        });
      });
    } else {
      recipe = widget.detailRecipe;
    }


    db = Provider.of<DBHelper>(context, listen: false);
    db.getFavorites().then((value) {
      setState(() {
        isFavourite = value.contains(widget.thinRecipe.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned:true,
            delegate: HeroHeader(
              isFavourite: isFavourite,
              imgUrl: widget.thinRecipe.imgUrl,
              heroText: widget.thinRecipe.name,
              minExtent: 190.0,
              maxExtent: 250.0,
              heroSubText: getHeroSubText(),
              favouriteMethod: changeFavourite,
            ),
          ),

          SliverToBoxAdapter(

              child: Column(
                children: [
                  SizedBox(height: 20),
                  RatingBarIndicator(
                    unratedColor: Colors.white,
                    rating: getRating(recipe.spoonScore),
                    itemCount: 5,
                    itemBuilder: (context, index) =>Icon(Icons.fastfood, color: Colors.yellow,),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: HtmlWidget(fitSummary(recipe.summary),textStyle: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(height:30),

                  Text("Ingredients", style: TextStyle(fontSize: 25, color: Colors.white,)),
                  SizedBox(height: 10,),

                  Container(
                      margin: EdgeInsets.only(left: 9, right: 40),
                      child: getIngredListTiles()
                  ),

                  Text("Instructions", style: TextStyle(fontSize: 25, color: Colors.white,)),
                  SizedBox(height: 20,),
                  getInstructions(recipe.instructions),


                  SizedBox(height: 20,),
                ],
              ),
            )

        ],
      ),
    );
  }

  // removes the suggestion links
  String fitSummary(String summary) {
    int index = summary.indexOf("Try ");
    if (index > 10) {
      return summary.substring(0, index);
    }
    return summary;
  }

  Widget getIngredListTiles() {
    List<Widget> list = [];
    for (String ingred in recipe.ingredients) {
      list.add(ListTile(
          title: Text("•  " + ingred, style: TextStyle(color: Colors.white),)));
    }
    return Column(children:list);
  }

  Widget getInstructions(String instructions) {
    if (instructions.contains("<li>")) {
      instructions = instructions == null ? "" : instructions.replaceAll("</li>", "</li><br>");

      return Container(
        margin: EdgeInsets.only(right: 40),
        child: HtmlWidget( instructions,textStyle: TextStyle(color: Colors.white),),);
    }
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      child: HtmlWidget( instructions,textStyle: TextStyle(color: Colors.white),),);

  }

  double getRating(double spoonScore) {
    double score = (spoonScore / 10) / 2;
    return score;
  }

  void changeFavourite() {
      if (isFavourite) {
        db.deleteFavorite(widget.thinRecipe.id).then((value){
          setState(() {
            isFavourite = false;
          });
        });
      } else {
        db.insertFavorite(widget.thinRecipe.id).then((value) {
          setState(() {
            isFavourite = true;
          });
        });
      }
  }

  String getHeroSubText() {
    var servings = recipe.servings;
    var readyInMinutes = recipe.readyInMinutes;

    if(servings.isEmpty || readyInMinutes.isEmpty) return "";

    return servings + " servings in " + readyInMinutes + " minutes";
  }
}
