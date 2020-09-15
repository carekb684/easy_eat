import 'package:easy_eat/models/detail_recipe_model.dart';
import 'package:easy_eat/models/thin_recipe.dart';
import 'package:easy_eat/spoon_serializer/serializer.dart';
import 'package:http/http.dart';

class SpoonService {

  SpoonService();

  final String BASE_URL = "https://api.spoonacular.com";
  final String RECIPES_URL = "/recipes";

  final String RANDOM_URL = "/random";
  final String INGREDIENTS_URL = "/findByIngredients";
  final String SEARCH_URL = "/complexSearch";
  final String INFORMATION_URL = "/information";

  final String PARAM_KEY = "?apiKey=" + "68889d6d630b432a8e1f3a57db1b32cc";

  final String PARAM_NUMBER = "&number=";
  final String PARAM_INGREDIENTS = "&ingredients=";
  final String PARAM_RANKING = "&ranking=";
  final String PARAM_IGNORE_PANTRY = "&ignorePantry=";
  final String PARAM_QUERY = "&query=";
  final String PARAM_SORT = "&sort=";

  Client httpClient = Client();

  Future<List<ThinRecipe>> getRandomRecipes(int recipeCount) async {
    Response resp = await httpClient.get(BASE_URL + RECIPES_URL + RANDOM_URL + PARAM_KEY + PARAM_NUMBER + recipeCount.toString());
    List<ThinRecipe> recipes = SpoonSerializer.seralizeMapRecipe(resp);
    return Future.value(recipes);
  }

  Future<List<ThinRecipe>> getIngredientsRecipes(
      int recipeCount, bool ignorePantry,
      int ranking, List<String> ingreds) async {
    Response resp = await httpClient.get(
        BASE_URL + RECIPES_URL + INGREDIENTS_URL + PARAM_KEY + PARAM_NUMBER + recipeCount.toString() +
            PARAM_IGNORE_PANTRY + ignorePantry.toString() + PARAM_RANKING + ranking.toString() + PARAM_INGREDIENTS + ingreds.join(",")
    );
    List<ThinRecipe> recipes = SpoonSerializer.seralizeListRecipe(resp);
    return Future.value(recipes);
  }

  Future<DetailRecipeModel> getRecipe(String id) async {
    Response resp = await httpClient.get(
        BASE_URL + RECIPES_URL + "/$id" + INFORMATION_URL + PARAM_KEY);
    DetailRecipeModel recipe = SpoonSerializer.seralizeDetailRecipe(resp);
    return Future.value(recipe);
  }

  Future<List<ThinRecipe>> fullSearch(String query, int recipeCount) async{
    Response resp = await httpClient.get(
        BASE_URL + RECIPES_URL + SEARCH_URL + PARAM_KEY + PARAM_NUMBER + recipeCount.toString() +
            PARAM_QUERY + query + PARAM_SORT + "popularity"
    );
    List<ThinRecipe> recipes = SpoonSerializer.seralizeSearchRecipe(resp);
    return Future.value(recipes);
  }

}