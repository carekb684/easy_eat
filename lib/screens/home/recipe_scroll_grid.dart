import 'dart:math';

import 'package:easy_eat/models/thin_recipe.dart';
import 'package:easy_eat/screens/recipe_detail/recipe_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeGrid extends StatelessWidget {

  RecipeGrid({this.scrollable});
  bool scrollable;

  final List<String> _listItem = [
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
  ];
  final List<String> _listText = [
    'aasfas asf asf da',
    'asfa da',
    'asfas saf asf as fas fa sfa sf as fsafasfas asd asd da',
    'asfasf asf as fas da',
    'asf asf asf afs asfasfsdfgdfh da',
    'adfgadfgadfgada',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      physics: scrollable ? null : NeverScrollableScrollPhysics(),
      shrinkWrap: !scrollable,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: _listItem.map((item) => Card(
          color: Colors.transparent,
          elevation: 0,
          child:
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  RecipeDetail(thinRecipe: ThinRecipe.create("Chicken 65", "https://spoonacular.com/recipeImages/637876-556x370.jpg", "637876"))));
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: AssetImage(item),
                          fit: BoxFit.cover
                      )
                  ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(.7),
                          ])
                  ),
                ),
                ),

                Container(
                  margin: EdgeInsets.only(top:8, left: 5),
                  child: Row(
                      children: [
                        Flexible(child: Text(fitText(_listText[new Random().nextInt(6)]), style: TextStyle(color: Colors.white),)),
                      ],
                    ),
                ),
              ],
            ),
          ),
      )).toList(),
    );
  }


  String fitText(String listText) {
    if (listText.length > 50) {
      return listText.substring(0, 46) + "...";
    }
    return listText;
  }
}
