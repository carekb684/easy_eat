import 'package:easy_eat/animations/fade_animation.dart';
import 'package:easy_eat/models/thin_recipe.dart';
import 'package:easy_eat/screens/home/recipe_scroll_grid.dart';
import 'package:easy_eat/services/spoonacular.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  SpoonService spoonServ;




  Future<List<ThinRecipe>> randomRecipes;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      spoonServ = Provider.of<SpoonService>(context, listen: false);
      //randomRecipes = spoonServ.getRandomRecipes(5);
    });

  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
        //color: Colors.green,//Theme.of(context).primaryColor,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [

            SizedBox(height: 20,),
            getHeaderImage(),
            SizedBox(height: 20,),

            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: double.infinity),
               // child: FutureBuilder<List<Recipe>>(
                  //future: randomRecipes,
                  //builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
                   // if (snapshot.hasData && snapshot.data != null) {
                      child: RecipeGrid(scrollable: false,),
                      //return getGrid(snapshot.data);
                    //} else {
                    //  return CircularProgressIndicator();
                   // }
                 // },
                //),
            ),

            SizedBox(height: 20,),
/*
            FutureBuilder<List<Recipe>>(
              future: randomRecipes,
              builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Text("test");
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            */
          ],
        ),

    );
  }

  Widget getHeaderImage() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              image: AssetImage('assets/images/food_home_header.jpg'),
              fit: BoxFit.cover
          )
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(.4),
                  Colors.black.withOpacity(.2),
                ]
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimation (1, Text("Check out these", style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),)),
            FadeAnimation (1.3, Text("popular recipes!", style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),)),

            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }


}
