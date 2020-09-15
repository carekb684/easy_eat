import 'dart:convert';

import 'package:easy_eat/models/detail_recipe_model.dart';
import 'package:easy_eat/models/thin_recipe.dart';
import 'package:http/http.dart';

class SpoonSerializer {

  static List<ThinRecipe> seralizeMapRecipe(Response resp) {
      Map<String, dynamic> recipesMap = jsonDecode(resp.body);
      var list = recipesMap["recipes"];

      return seralizeList(list);
  }

  static List<ThinRecipe> seralizeListRecipe(Response resp) {
    List<dynamic> recipesList = jsonDecode(resp.body);
    return seralizeList(recipesList);
  }

  static List<ThinRecipe> seralizeSearchRecipe(Response resp) {
    Map<String, dynamic> recipesMap = jsonDecode(resp.body);

    return seralizeList(recipesMap["results"]);
  }

  static List<ThinRecipe> seralizeList(List<dynamic> list) {
    List<ThinRecipe> recipes = [];
    for (dynamic rec in list) {
      ThinRecipe recipe = ThinRecipe();
      recipe.name = rec["title"];
      recipe.id = rec["id"];
      recipe.imgUrl = rec["image"];
      recipes.add(recipe);
    }

    return recipes;
  }

  static DetailRecipeModel seralizeDetailRecipe(Response resp) {
    Map<String, dynamic> recipeMap = jsonDecode(resp.body);

    DetailRecipeModel recipe = DetailRecipeModel();

    recipe.instructions = recipeMap["instructions"];
    recipe.summary = recipeMap["summary"];
    recipe.servings = recipeMap["servings"];
    recipe.readyInMinutes = recipeMap["readyInMinutes"];
    recipe.spoonScore = recipeMap["spoonacularScore"];

    List<String> ingredNames = [];
    List<dynamic> ingredList = recipeMap["extendedIngredients"];
    for (dynamic ingred in ingredList) {
      ingredNames.add(ingred["original"]);
    }
    recipe.ingredients = ingredNames;

    return recipe;
  }

}