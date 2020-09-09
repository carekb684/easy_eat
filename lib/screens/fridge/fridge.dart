import 'package:easy_eat/models/sql/ingridient_model.dart';
import 'package:easy_eat/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class Fridge extends StatefulWidget {

  @override
  _FridgeState createState() => _FridgeState();
}

class _FridgeState extends State<Fridge> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String savedIngredient;

  DBHelper db;
  Future<List<IngredientSql>> futureIng;

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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height:20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: TextFormField(
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

              SizedBox(height:20),

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
                      if (savedIngredient.isEmpty) {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Please enter some text')));
                      } else {
                        insertIngredient(savedIngredient);
                      }
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ),

              SizedBox(height:40),

              getFridgeList(),

            ],
          ),
        )
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
              return Text("No ingredients added yet :(");
            }
            return Text("data should be here");
          } else {
            return CircularProgressIndicator();
          }
        },
      );

    }
  }

  void insertIngredient(String savedIngredient) {
    Future<bool> success = db.insertIngredient(IngredientSql(name: savedIngredient,));
    success.then((success) {
      if (success) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Added ingredient')));
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('This ingredient is already added')));
      }
    });
  }
}
