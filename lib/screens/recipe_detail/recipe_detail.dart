import 'package:easy_eat/models/detail_recipe_model.dart';
import 'package:easy_eat/models/thin_recipe.dart';
import 'package:easy_eat/services/spoonacular.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

import 'hero_header.dart';

class RecipeDetail extends StatefulWidget {

  RecipeDetail({this.thinRecipe});
  ThinRecipe thinRecipe;

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {

  SpoonService spoonService;
  Future<DetailRecipeModel> recipe;
  String heroSubText = "5.0 servings in 45 minutes";

  _RecipeDetailState() {
    asd = DetailRecipeModel();
    asd.spoonScore = 37.0;
    asd.servings = "6";
    asd.servings = "6";
    asd.readyInMinutes = "45";
    asd.instructions = "<ol><li>Take a large bowl mix in the ginger and garlic paste, yogurt, red chilly powder, turmeric powder, and salt.</li><li>Mix well to from smooth and thick paste, add the chicken pieces to the masala paste and  marinaded for 4 hours.</li><li>Heat enough oil in a pan to deep fry the marinaded chicken pieces. Deep fry the chicken pieces in batches till crisp and golden color.</li><li>Note: The taste of the Chicken 65 depends mainly on the amount of time it gets marinated in the masala, it is best to marinate the chicken pieces the day before.</li></ol>";
    asd.summary = "Need a <b>gluten free hor d'oeuvre</b>? Chicken 65 could be a super recipe to try. This recipe makes 6 servings with <b>113 calories</b>, <b>18g of protein</b>, and <b>3g of fat</b> each. For <b>\$1.03 per serving</b>, this recipe <b>covers 10%</b> of your daily requirements of vitamins and minerals. Only a few people made this recipe, and 5 would say it hit the spot. Head to the store and pick up yogurt, chili powder, salt, and a few other things to make it today. From preparation to the plate, this recipe takes roughly <b>45 minutes</b>. All things considered, we decided this recipe <b>deserves a spoonacular score of 40%</b>. This score is solid. Try <a href=\"https://spoonacular.com/recipes/i-aint-chicken-chicken-crispy-roasted-chicken-breasts-with-orange-and-cardamom-310658\">I Ain't Chicken Chicken: Crispy Roasted Chicken Breasts with Orange and Cardamom</a>, <a href=\"https://spoonacular.com/recipes/the-best-shredded-chicken-for-your-chicken-dishes-+-homemade-chicken-broth-528123\">The Best Shredded Chicken For Your Chicken Dishes + Homemade Chicken Broth</a>, and <a href=\"https://spoonacular.com/recipes/popeye-tsos-chicken-general-tsos-chicken-made-with-popeyes-chicken-nuggets-196521\">Popeye Tso's Chicken (General Tso's Chicken Made with Popeye's Chicken Nuggets)</a> for similar recipes.";
    asd.ingredients = [
      "500 grams boneless chicken breast",
      "2-3 tsp chili powder",
      "4 tbsp Ginger and Garlic paste",
      "½ tbsp. salt",
      "1/4 tsp Turmeric powder",
      "4 tbsp yogurt",
    ];
  }
  DetailRecipeModel asd;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    spoonService = Provider.of<SpoonService>(context, listen: false);
    //recipe = spoonService.getRecipe(widget.thinRecipe.id);
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
              imgUrl: widget.thinRecipe.imgUrl,
              heroText: widget.thinRecipe.name,
              minExtent: 150.0,
              maxExtent: 250.0,
              heroSubText: heroSubText,
            ),
          ),

          /*
          SliverToBoxAdapter(
            child: FutureBuilder<DetailRecipeModel>(
              future: recipe,
              builder: (BuildContext context, AsyncSnapshot<DetailRecipeModel> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Text("data");
                }
                return CircularProgressIndicator();

              }
            ),

          ),*/

          SliverToBoxAdapter(

              child: Column(
                children: [
                  SizedBox(height: 20),
                  RatingBarIndicator(
                    unratedColor: Colors.white,
                    rating: getRating(asd.spoonScore),
                    itemCount: 5,
                    itemBuilder: (context, index) =>Icon(Icons.fastfood, color: Colors.yellow,),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: HtmlWidget(fitSummary(asd.summary),textStyle: TextStyle(color: Colors.white),),
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
                  Container(
                    margin: EdgeInsets.only(right: 40),
                    child: HtmlWidget(fitInstructions(asd.instructions) ,textStyle: TextStyle(color: Colors.white),),
                  ),

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
    return summary.substring(0,summary.indexOf("Try "));
  }

  Widget getIngredListTiles() {
    List<Widget> list = [];
    for (String ingred in asd.ingredients) {
      list.add(ListTile(
          title: Text("•  " + ingred, style: TextStyle(color: Colors.white),)));
    }
    return Column(children:list);
  }

  String fitInstructions(String instructions) {
    return instructions.replaceAll("</li>", "</li><br>");
  }

  double getRating(double spoonScore) {
    double score = (spoonScore / 10) / 2;
    return score;
  }
}
