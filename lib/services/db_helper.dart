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
    "CREATE TABLE fridge(ingredient TEXT PRIMARY KEY, count INTEGER)",
    );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 3,
    );
  }

  void insertIngredient(IngredientSql ing) {
    db.insert(IngredientSql.FRIDGE_TABLE, ing.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<List<Ingr>>
}