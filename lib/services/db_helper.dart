import 'package:easy_eat/models/sql/ingridient_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

  static final String FRIDGE_TABLE = "fridge";

  Database db;
  DBHelper({this.db});

  static Future<Database> init() async {
    return openDatabase(
        join(await getDatabasesPath(), 'fridge_database.db'),
      onCreate: (db, version) {
        return db.execute(
        "CREATE TABLE fridge(name TEXT PRIMARY KEY, count INTEGER)",
    );
    },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < newVersion) {
          db.execute("DROP TABLE IF EXISTS fridge");
          db.execute("CREATE TABLE fridge(name TEXT PRIMARY KEY, count INTEGER)");
        }
      },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 8,
    );
  }

  Future<bool> insertIngredient(IngredientSql ing) async {
    try {
      var future = await db.insert(FRIDGE_TABLE, ing.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
    } catch(e) {
      return false;
    }
    return true;
  }

  Future<List<IngredientSql>> getIngredients() async {
    List<Map<String, dynamic>> maps = await db.query(FRIDGE_TABLE);

    return List.generate(maps.length, (index) {
      return IngredientSql(name: maps[index]["name"], count: maps[index]["count"]);
    });
  }

  // gets ingredients but ignores if they have null or zero COUNT
  Future<List<IngredientSql>> getIngredientsWithCount() async {
    List<Map<String, dynamic>> maps = await db.query(FRIDGE_TABLE, where: "count != ? AND count != ?", whereArgs: ["0", "NULL"]);

    return List.generate(maps.length, (index) {
      return IngredientSql(name: maps[index]["name"], count: maps[index]["count"]);
    });
  }

  void updateIngredient(IngredientSql ingred) {
    db.update(FRIDGE_TABLE, ingred.toMap(), where: "name = ?", whereArgs: [ingred.name]);
  }

  Future<int> deleteIngredient(String name) {
    var future = db.delete(FRIDGE_TABLE, where: "name = ?", whereArgs: [name]);
    return future;
  }

}