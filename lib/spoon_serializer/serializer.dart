import 'dart:convert';

import 'package:easy_eat/models/recipe.dart';
import 'package:http/http.dart';

class SpoonSerializer {

  static List<Recipe> seralizeRecipe(Response resp) {
      Map<String, dynamic> recipesMap = jsonDecode(resp.body);
      var list = recipesMap["recipes"];

      List<Recipe> recipes = [];
      for (dynamic rec in list) {
        Recipe recipe = Recipe();
        recipe.name = rec["title"];
        recipe.imgUrl = rec["image"];
        recipes.add(recipe);
      }

      return recipes;
  }

}