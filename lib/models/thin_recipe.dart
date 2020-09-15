// used for retrieving very little info for scrolling recipes etc..
class ThinRecipe {

  ThinRecipe();
  factory ThinRecipe.create(String name, String imageUrl, String id) {
    var thinRecipe = ThinRecipe();
    thinRecipe.name = name;
    thinRecipe.imgUrl = imageUrl;
    thinRecipe.id = id;
    return thinRecipe;
  }

  String name;
  String imgUrl;
  String id;

}