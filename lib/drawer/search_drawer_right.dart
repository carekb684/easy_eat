import 'package:flutter/material.dart';

class DrawerSearchMenu extends StatefulWidget {

  DrawerSearchMenu({Key key}) : super(key: key);

  @override
  DrawerSearchMenuState createState() => DrawerSearchMenuState();
}

class DrawerSearchMenuState extends State<DrawerSearchMenu> {
  Map<String, bool> intolerances = {
    "Dairy": false,
    "Egg": false,
    "Gluten": false,
    "Grain": false,
    "Peanut": false,
    "Soy": false,
    "Wheat": false,
  };

  DrawerSearchMenuState() {
    sortList = createDropdownList(["Popularity", "Healthiness", "Time"]);
    dietList = createDropdownList(["Vegetarian", "Vegan", "Pescetarian", "Ketogenic"]);
    typeList = createDropdownList(["Main course", "Dessert", "Salad", "Bread", "Breakfast", "Soup", "Snack", "Drink"]);
  }

  List<DropdownMenuItem<String>> sortList;
  String sorting = "";

  List<DropdownMenuItem<String>> dietList;
  String diet = "";

  List<DropdownMenuItem<String>> typeList;
  String type = "";

  String test = "test";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Align(alignment: Alignment.center,
                child: Text('Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20,),)),
            SizedBox(height: 30,),

            Text("Sorting",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height:10),
            getDropDown(sortList, sorting, (value) {
              setState(() {
                sorting = value;
              });
            }),

            SizedBox(height: 30,),

            Text("Type",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height:10),
            getDropDown(typeList, type, (value) {
              setState(() {
                type = value;
              });
            }),

            SizedBox(height: 30,),

            Text("Diet",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height:10),
            getDropDown(dietList, diet, (value) {
              setState(() {
                diet = value;
              });
            }),

            SizedBox(height: 30),
            Text("Intolerances",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            getCheckboxGrid(intolerances),



            SizedBox(height: 15),

          ],
        ),
      ),
    );
  }

  Widget textStyle(String item) {
    return Text(
      item,
      style: TextStyle(color: Colors.white),
    );
  }

  Widget getCheckboxGrid(Map<String, bool> checkBoxMap) {
    return GridView.count(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      childAspectRatio: 2.5,
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 0,
      children: checkBoxMap.entries.map((e) => CheckboxListTile(
        contentPadding: EdgeInsets.only(top:0, left:0, bottom: 0, right:3),
        dense: true,
        title: textStyle(e.key),
        value: e.value,
        activeColor: Theme.of(context).primaryColorDark,
        onChanged: (value) {
          setState(() {
            checkBoxMap[e.key] = value;
          });
        },
      ),
      ).toList(),
    );
  }

  List<DropdownMenuItem<String>> createDropdownList(List<String> strings) {
    List<DropdownMenuItem<String>> list = [];
    list.add(DropdownMenuItem<String>(value: "", child: Text("<nothing>", style: TextStyle(color: Colors.black45, fontSize: 13),)));

    for(String item in strings) {
      list.add(DropdownMenuItem<String>(value: item.toLowerCase(), child: Text(item, style: TextStyle(color: Colors.black, fontSize: 13),)));
    }
    return list;
  }

  Widget getDropDown(List<DropdownMenuItem<String>> list, String selection, Function setValue) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            iconEnabledColor: Colors.black,
            value: selection,
            onChanged: setValue,
            items: list,
          ),
        ),
      ),
    );
  }
}
