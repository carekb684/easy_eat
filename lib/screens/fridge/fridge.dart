import 'package:easy_eat/models/sql/ingridient_model.dart';
import 'package:easy_eat/services/db_helper.dart';
import 'package:easy_eat/util/string_capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_counter/flutter_counter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class Fridge extends StatefulWidget {
  @override
  _FridgeState createState() => _FridgeState();
}

class _FridgeState extends State<Fridge> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController saveIngredController = TextEditingController();
  String savedIngredient;

  DBHelper db;
  Future<List<IngredientSql>> futureIng;
  List<IngredientWrapper> ingreList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      db = Provider.of<DBHelper>(context, listen: false);
      setState(() {
        futureIng = db.getIngredients();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
            child: Form( key: _formKey,
              child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: saveIngredController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.fastfood),
                    hintText: "Add your ingredient here ...",
                  ),
                  onSaved: (String str) {
                    savedIngredient = str;
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 180,
                height: 50,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColorLight,
                  elevation: 0,
                  child: Text("Save"),
                  onPressed: () {
                    _formKey.currentState.save();
                    if (savedIngredient.isNotEmpty) {
                      insertIngredient(savedIngredient);
                      saveIngredController.clear();
                    }
                    updateIngredients();

                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 40),
              getFridgeList(),
            ],
          ),
        )
    );
  }

  Widget getFridgeList() {
    if (futureIng == null) {
      return SizedBox();
    } else {
      return FutureBuilder<List<IngredientSql>>(
        future: futureIng,
        builder: (BuildContext context, AsyncSnapshot<List<IngredientSql>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data.isEmpty) {
              return Text(
                "No ingredients added yet :(",
                style: TextStyle(color: Colors.white),
              );
            }
            print(snapshot.connectionState.toString());

            if (snapshot.connectionState == ConnectionState.done) {
              ingreList = ingredToWrapper(snapshot.data);
            }

            return ingredientList();
          } else {
            return CircularProgressIndicator();
          }
        },
      );
    }
  }

  void insertIngredient(String savedIngredient) {
    Future<bool> success = db.insertIngredient(IngredientSql(
      name: savedIngredient.toLowerCase(),
    ));
    success.then((success) {
      if (success) {
        setState(() {
          futureIng = db.getIngredients();
        });
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Added ingredient')));
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('"$savedIngredient" ingredient is already added')));
      }
    });
  }

  Widget ingredientList() {
    return Flexible(
      child: ListView.builder(
        itemCount: ingreList.length,
        itemBuilder: (context, index) {
          final wrap = ingreList[index];
          return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              actions: [
                IconSlideAction(
                    foregroundColor: Colors.red,
                    caption: "Delete",
                    color: Colors.white,
                    icon: Icons.delete_forever,
                    onTap: () {
                      deleteIngredient(index);
                    })
              ],
              child: ListTile(
                title: Text(
                  wrap.ingredient.name.capitalize(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                trailing: Counter(
                  initialValue: wrap.ingredient.count ?? 0,
                  minValue: 0,
                  maxValue: 99,
                  step: 1,
                  decimalPlaces: 0,
                  color: Theme.of(context).primaryColorDark,
                  buttonSize: 50,
                  textStyle: TextStyle(color: Colors.white, fontSize: 20),
                  onChanged: (value) {
                    setState(() {
                      ingreList[index].ingredient.count = value;
                      ingreList[index].hasChanged = true;
                    });
                  },
                ),
              ));
        },
      ),
    );
  }

  void updateIngredients() {
    for (IngredientWrapper wrap in ingreList) {
      if (wrap.hasChanged) {
        db.updateIngredient(wrap.ingredient);
        wrap.hasChanged = false;
      }
    }
  }

  List<IngredientWrapper> ingredToWrapper(List<IngredientSql> data) {
    for (IngredientSql ingred in data) {
      if (ingreList.contains(ingred)) {
        continue;
      }
      ingreList.add(ingred.toWrapper());
    }
    return ingreList;
  }

  void deleteIngredient(int index) {
    var future = db.deleteIngredient(ingreList[index].ingredient.name);
    future.then((value) {
      futureIng = db.getIngredients();
      futureIng.then((value){ //dont reload until new data has arrived
        setState(() {
          ingreList.removeAt(index);
        });
      });
    });
  }
}
