class IngredientSql {
  IngredientSql({this.name, this.count});

  String name;
  int count;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "name": name,
      "count": count,
    };

    return map;
  }

  IngredientWrapper toWrapper(){
    return IngredientWrapper(ingredient: this);
  }

}

class IngredientWrapper {
  IngredientWrapper({this.ingredient});

  IngredientSql ingredient;
  bool hasChanged = false;

  @override
  bool operator ==(other) {
    // TODO: implement ==
    return this.ingredient.name == other.name;
  }
}
