import 'package:easy_eat/models/recipe.dart';
import 'package:easy_eat/spoon_serializer/serializer.dart';
import 'package:http/http.dart';

class SpoonService {

  SpoonService();

  final String BASE_URL = "https://api.spoonacular.com";
  final String RECIPES_URL = "/recipes";
  final String RANDOM_URL = "/random";

  final String PARAM_KEY = "?apiKey=" + "68889d6d630b432a8e1f3a57db1b32cc";
  final String PARAM_NUMBER = "&number=";

  Client httpClient = Client();

  Future<List<Recipe>> getRandomRecipes(int recipeCount) async {
    Response resp = await httpClient.get(BASE_URL + RECIPES_URL + RANDOM_URL + PARAM_KEY + PARAM_NUMBER + recipeCount.toString());
    List<Recipe> recipes = SpoonSerializer.seralizeRecipe(resp);
    return Future.value(recipes);
  }

}