import 'package:easy_eat/models/recipe.dart';
import 'package:easy_eat/services/spoonacular.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  SpoonService spoonServ;


  final List<String> _listItem = [
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
    'assets/images/food_home_header.jpg',
  ];
  final List<String> _listText = [
    'aasfas asf asf da',
    'asfa da',
    'asfas saf asf as fas fa sfa sf as fsafasfas asd asd da',
    'asfasf asf as fas da',
    'asf asf asf afs asfasfsdfgdfh da',
    'adfgadfgadfgada',
  ];

  Future<List<Recipe>> randomRecipes;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      spoonServ = Provider.of<SpoonService>(context, listen: false);
      //randomRecipes = spoonServ.getRandomRecipes(5);
    });

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [

            SizedBox(height: 20,),
            getHeaderImage(),
            SizedBox(height: 20,),

            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: double.infinity),
               // child: FutureBuilder<List<Recipe>>(
                  //future: randomRecipes,
                  //builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
                   // if (snapshot.hasData && snapshot.data != null) {
                      child: getGrid(null),
                      //return getGrid(snapshot.data);
                    //} else {
                    //  return CircularProgressIndicator();
                   // }
                 // },
                //),
            ),

            SizedBox(height: 20,),
/*
            FutureBuilder<List<Recipe>>(
              future: randomRecipes,
              builder: (BuildContext context, AsyncSnapshot<List<Recipe>> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Text("test");
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            */
          ],
        ),
      ),
    );
  }

  Widget getHeaderImage() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              image: AssetImage('assets/images/food_home_header.jpg'),
              fit: BoxFit.cover
          )
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(.4),
                  Colors.black.withOpacity(.2),
                ]
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Check out these", style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),),
            Text("popular recipes!", style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),),

            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  Widget getGrid(List<Recipe> data) {

    return GridView.count(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: _listItem.map((item) => Card(
        color: Colors.transparent,
        elevation: 0,
        child:
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(item),
                    fit: BoxFit.cover
                  )
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Flexible(child: Text(fitText(_listText[new Random().nextInt(6)]))),
                  ],
                ),
              ),
            ],
          )

      )).toList(),
    );
  }

  String fitText(String listText) {
    if (listText.length > 50) {
      return listText.substring(0, 46) + "...";
    }
    return listText;
  }
}
