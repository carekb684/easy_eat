import 'package:easy_eat/models/thin_recipe.dart';
import 'package:easy_eat/models/sql/ingridient_model.dart';
import 'package:easy_eat/screens/home/recipe_scroll_grid.dart';
import 'package:easy_eat/services/db_helper.dart';
import 'package:easy_eat/services/spoonacular.dart';
import 'package:easy_eat/util/color_from_hex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';

class IngredientRecipes extends StatefulWidget {
  static final int recipeCount = 2;

  @override
  _IngredientRecipesState createState() => _IngredientRecipesState();
}

class _IngredientRecipesState extends State<IngredientRecipes> {
  DBHelper db;
  List<IngredientSql> ingredList;
  SpoonService spoonServ;

  bool ignorePantry = false;
  bool maximizeIngred = false;

  SuperTooltip tooltip;

  BuildContext tooltipContext;

  Future<List<ThinRecipe>> recipes;


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    db = Provider.of<DBHelper>(context, listen: false);
    spoonServ = Provider.of<SpoonService>(context, listen: false);

    db.getIngredientsWithCount().then((value) => ingredList = value);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPop,
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
                children: [
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(
                  children: [
                    Text("Ignore pantry items", style: TextStyle(color: ignorePantry ? Colors.white: Colors.grey[300], fontSize: 15),),

                    //builder to get widget context for showing tooltip
                    Builder(builder: (context) {
                      tooltipContext = context;
                      return IconButton(
                        icon: Icon(Icons.help_outline, color: HexColor.fromHex("#7d1e00")),
                        onPressed: onTapTooltip,
                      );
                    },
                    ),
                  ],
                ),
                Switch(
                  activeColor: Colors.white,
                  value: ignorePantry,
                  onChanged: (value) {
                    setState(() {
                      ignorePantry=value;
                    });
                    },
                ),
              ],),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Minimize missing ingredients /", style: TextStyle(color: maximizeIngred ? Colors.grey[300]: Colors.white, fontSize: 15),),
                      Text("Maximize used ingredients", style: TextStyle(color: maximizeIngred ? Colors.white: Colors.grey[300], fontSize: 15),),
                  ],),

                  Switch(
                    activeColor: Colors.white,
                    value: maximizeIngred,
                    onChanged: (value) {
                      setState(() {
                        maximizeIngred=value;
                      });
                    },
                  ),
                ],),

              SizedBox(height: 10,),
              Row(children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child: RaisedButton.icon(
                      icon: Icon(Icons.search),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColorLight,
                      elevation: 0,
                      label: Text("Search recipes"),
                      onPressed: () {
                        //searchRecipes();
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 20),

              /*FutureBuilder<List<Recipe>>(
                future: recipes,
                builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data.isEmpty) {
                      return Text(
                        "No recipes found :(",
                        style: TextStyle(color: Colors.white),
                      );
                    }
*/
            ConstrainedBox(
                constraints: BoxConstraints(maxHeight: double.infinity),
                child: RecipeGrid(scrollable: false,),
            ),

                  /*} else {
                    return CircularProgressIndicator();
                  }
                },
              ),

                   */
                  SizedBox(height: 10,),
            ]),
          ),
      ),
    );
  }

  Future<bool>_willPop() async {
    if (tooltip.isOpen) {
      tooltip.close();
      return false;
    }
    return true;
  }

  void onTapTooltip() {
    if (tooltip != null && tooltip.isOpen) {
      tooltip.close();
      return;
    }

    tooltip = SuperTooltip(
      popupDirection: TooltipDirection.down,
      content: Material(
        child: Text("The search will assume you have common pantry items like flour, sugar etc", softWrap: true,),
      ),
    );

    tooltip.show(tooltipContext);

  }

  void searchRecipes() {

    int ranking = maximizeIngred ? 1 : 2;
    List<String> ingredients = ingredList.map((e) => e.name).toList();
    setState(() {
      recipes = spoonServ.getIngredientsRecipes(IngredientRecipes.recipeCount, ignorePantry, ranking, ingredients);
    });
  }

}
