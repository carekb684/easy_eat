class IngredientSql {
  IngredientSql({this.name, this.count});

  static final String FRIDGE_TABLE = "fridge";

  String name;
  int count;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "name": name,
      "count": count,
    };

    return map;
  }

}
