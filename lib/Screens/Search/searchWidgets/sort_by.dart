import 'package:flutter/material.dart';

class SortBy extends StatefulWidget {
  @override
  _SortByState createState() => _SortByState();
}

class _SortByState extends State<SortBy> {
  String _sortBy = 'Recommended(default)';
  int _radioValue = 0;
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          _sortBy = 'Recommended(default)';
          break;
        case 1:
          _sortBy = 'Distance';
          break;
        case 2:
          _sortBy = 'Rating';
          break;
        case 3:
          _sortBy = 'Most Reviewed';
          break;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title.copyWith(fontSize: 15);
    return Container(
      height: 290,
      padding: EdgeInsets.all(10.0),
      child: Column(children: [
        Text(
          'Sort By',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.red),
        ),
        SizedBox(
          height: 15.0,
        ),
                ListTile(
                  title: Text('Recommended(default)',style: _textStyle,),
                  trailing:Radio(value: 0, groupValue: _radioValue, onChanged: _handleRadioValueChange,activeColor: Colors.red,hoverColor: Colors.grey,),
                ),
        Divider(height: 2,color: Colors.grey,),
        ListTile(
          title: Text('Distance',style: _textStyle,),
          trailing: Radio(value: 1, groupValue: _radioValue, onChanged: _handleRadioValueChange,activeColor: Colors.red,hoverColor: Colors.grey,),
        ),
        Divider(height: 2,color: Colors.grey,),
        ListTile(
          title: Text('Rating',style: _textStyle,),
          trailing: Radio(value: 2, groupValue: _radioValue, onChanged: _handleRadioValueChange,activeColor: Colors.red,hoverColor: Colors.grey,),
        ),
        Divider(height: 2,color: Colors.grey,),
        ListTile(
          title: Text('Moast Reviewed',style: _textStyle,),
          trailing: Radio(value: 3, groupValue: _radioValue, onChanged: _handleRadioValueChange,activeColor: Colors.red,hoverColor: Colors.grey,),
        ),
      ]),
    );
  }
}
