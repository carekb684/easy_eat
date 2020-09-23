import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_eat/models/detail_recipe_model.dart';
import 'package:easy_eat/models/thin_recipe.dart';
import 'package:easy_eat/screens/recipe_detail/recipe_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeGrid extends StatelessWidget {

  RecipeGrid({this.scrollable, this.thinRecipes, this.detailRecipes}){
    if ((thinRecipes == null || thinRecipes.isEmpty) && detailRecipes != null && detailRecipes.isNotEmpty) {
      populateThinRecipes();
    }
  }

  bool scrollable;
  List<ThinRecipe> thinRecipes;
  List<DetailRecipeModel> detailRecipes;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      physics: scrollable ? null : NeverScrollableScrollPhysics(),
      shrinkWrap: !scrollable,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: thinRecipes.map((item) => Card(
          color: Colors.transparent,
          elevation: 0,
          child:
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  RecipeDetail(thinRecipe: item, detailRecipe: findDetailRecipe(item.id),)));
            },
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: item.imgUrl == null ? "" : item.imgUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
                ),

                Container(
                  margin: EdgeInsets.only(top:8, left: 5),
                  child: Row(
                      children: [
                        Flexible(child: Text(fitText(item.name), style: TextStyle(color: Colors.white),)),
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

  void populateThinRecipes() {
    thinRecipes = [];
    for (DetailRecipeModel detail in detailRecipes) {
      thinRecipes.add(ThinRecipe.create(detail.name, detail.imgUrl, detail.id));
    }
  }

  DetailRecipeModel findDetailRecipe(String id) {
    if (detailRecipes == null) return null;

    for(DetailRecipeModel detail in detailRecipes) {
      if(detail.id == id) {
        return detail;
      }
    }
    return null;
  }
}
