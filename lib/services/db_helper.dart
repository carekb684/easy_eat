import 'package:easy_eat/models/sql/ingridient_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {

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
    version: 7,
    );
  }

  Future<bool> insertIngredient(IngredientSql ing) async {
    try {
      var future = await db.insert(IngredientSql.FRIDGE_TABLE, ing.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
    } catch(e) {
      return false;
    }
    return true;
  }

  Future<List<IngredientSql>> getIngredients() async {
    List<Map<String, dynamic>> maps = await db.query(IngredientSql.FRIDGE_TABLE);

    return List.generate(maps.length, (index) {
      return IngredientSql(name: maps[index]["name"], count: maps[index]["count"]);
    });
  }

}