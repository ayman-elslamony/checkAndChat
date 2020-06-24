import 'package:flutter/material.dart';
import '../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class CategorySelector extends StatefulWidget {
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;
  static bool isSelected = false;


  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;


    final List<Widget> categories = [
      InkWell(
        onTap: (){
          setState(() {
            isSelected = ! isSelected;
          });
        },
        child: Text(LocaleKeys.messages,
          style: TextStyle(
            color:
            !isSelected?
            Colors.white : Colors.white60,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ).tr(context: context),
      ),
      InkWell(
        onTap: (){
          setState(() {
            isSelected = ! isSelected;
          });
        },
        child: Text(LocaleKeys.groups,
          style: TextStyle(
            color:
            isSelected?
            Colors.white : Colors.white60,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ).tr(context: context),
      ),
    ];
    return Container(
      height: _height*0.05,
      color: Color(0xffc62828),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 5.0,
              ),
              child: Center(
                child: categories[index]


              ),
            ),
          );
        },
      ),
    );
  }
}