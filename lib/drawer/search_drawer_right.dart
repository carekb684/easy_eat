import 'package:flutter/material.dart';

class DrawerSearchMenu extends StatelessWidget {
  final Function(String) onItemClick;

  const DrawerSearchMenu({Key key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme
          .of(context)
          .primaryColor,
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          Text(
            'Filters',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'BalsamiqSans'),
          ),
          SizedBox(height: 20,),

          Text(
            'easyEat',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'BalsamiqSans'),
          ),
          SizedBox(height: 20,),

          //sliderItem('Settings', Icons.settings),
        ],
      ),
    );
  }

}