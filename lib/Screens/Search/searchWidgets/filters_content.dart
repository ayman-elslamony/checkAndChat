import 'package:checkandchat/Providers/resturants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'container_of_dollars.dart';

class FiltersContent extends StatefulWidget {
  @override
  _FiltersContentState createState() => _FiltersContentState();
}

class _FiltersContentState extends State<FiltersContent> {
  bool _isTakeOut = false;
  static Map<String,dynamic> _filters={
    'openNow':false,
    'distance':'Default',
    'SortBy':'Default',
  };
//  Map<String, dynamic> _switchVal = {
//    'price':[],
//    'Popular': {
//      'Hot and New': false,
//      'Open Now': false,
//      'Distance': 'Default',
//      'Sort By ': 'Recommended'
//    },
//    'Meal': {
//      'Good For Breakfast': false,
//      'Good For Brunch': false,
//      'Good For Launch': false,
//      'Good For Dinner': false,
//      'Good For Dessert': false,
//      'Good For Late Night': false,
//    },
//    'Good For': {
//      'Good For Kids': false,
//      'Good For Groups': false,
//      'Good For Happy Hour': false,
//    },
//    'Amentities & Ambiance': {
//      'WheelChair Accessible': false,
//      'Takes Reservations': false,
//      'Free Wi-Fi': false,
//      'Offers Takeout': false,
//      'Outboor Seating': false,
//      'Full Bar': false,
//
//    },
//    'Payment': {
//      'Accepts Credit Cards': false,
//      'Offering a Deal': false,
//      'Offers Military Discount': false,
//    },
//    'General':{
//      'Open to All':false,
//  }
//  };

 static List<String> _dolarsCount = ['Free','Inexpensive','Moderate','Expensive','Very Expensive'];
 static List<bool> _changeContainerColor = List.generate(5, (index)=>false);
 static List<String> _priceLevel = List<String>();
 static double dist=0.0;
 static double rating=0.0 ;
  static const _sortedby = <String>[
    'Default',
    'Rating',
    //'Most Reviewed'
   ];
  _resetFilters(){
    _changeContainerColor = List.generate(5, (index)=>false);
    _priceLevel.clear();
    dist=0.0;
    rating=0.0 ;
    _filters['openNow']= false;
    _filters['distance']= 'Default';
    _filters['SortBy']= 'Default';
    setState(() {
    });
  }
  static const _distance = <String>[
    'Default',
    '0.5 km',
    '1 km',
    '1.5 km',
    '2 km',
    '2.5 km',
    '3 km',
    '3.5 km',
  ];
  List<DropdownMenuItem<String>> _dropdownMenuItem({List<String> list}) {
    return list
        .map((String val) =>
        DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        ))
        .toList();
  }

  Divider _divider() {
    return Divider(
      color: Colors.grey,
      thickness: 1.0,
      height: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme
        .of(context)
        .textTheme
        .title;
    double _height = MediaQuery
        .of(context)
        .size
        .height;
    double _width = MediaQuery
        .of(context)
        .size
        .width;

//    Widget _switchedButton({String title,String path}) {
//      return
//      Column(
//        children: <Widget>[
//          ListTile(
//              title: Text(
//              title,
//              style: _textStyle.copyWith(fontSize: 15),
//          ),
//              trailing: Switch(
//                  activeTrackColor: Colors.redAccent,
//                  activeColor: Colors.red,
//                  value: _switchVal[path][title],
//                  onChanged: (val) {
//                    setState(() {
//                      _switchVal[path][title] = val;
//                    });
//                    print(_switchVal[path][title]);
//                  })),
//          _divider()
//        ],
//      );
//    }

    Padding _createTitle({String title}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(title),
      );
    }

    return SizedBox(
      height: 200,
      width: _width * 0.85,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        title: Text(
          'Filters',
          textAlign: TextAlign.center,
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 15,),Text('Price',style:  _textStyle.copyWith(fontSize: 15),),
                    ],
                  ),
                ),
                Divider(color: Colors.grey,height: 1,),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: _width,
                 height: 140,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 3.5,mainAxisSpacing: 3,crossAxisSpacing: 3),
                    itemBuilder: (ctx,index){
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              _changeContainerColor[index] = !_changeContainerColor[index];
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)
                              ,color: _changeContainerColor[index] == false ?Colors.white : Color(0xffc62828),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(child: Text(_dolarsCount[index],style: TextStyle(
                                color: _changeContainerColor[index] == false ?Colors.black : Colors.white
                            ),)),
                          ),
                        ),
                      );
                    },
                    itemCount: 5,),
                ),
                SizedBox(
                  height: 10,
                ),
                _divider(),
                //_createTitle(title: 'Popular'),
               // _switchedButton(title: 'Hot and New',path: 'Popular'),
            ListTile(
                title: Text(
                  'Open Now',
                  style: _textStyle.copyWith(fontSize: 15),
                ),
                trailing: Switch(
                    activeTrackColor: Colors.redAccent,
                    activeColor: Color(0xffc62828),
                    value: _filters['openNow'],
                    onChanged: (val) {
                      setState(() {
                        _filters['openNow'] = val;
                      });
                      print(_filters['openNow']);
                    })),
            _divider(),
             //   _switchedButton(title: 'Open Now',path: 'Popular'),
                ListTile(
                  title: Text('Distance'),
                  trailing: DropdownButton<String>(
                      items: _dropdownMenuItem(list: _distance),
                      value: _filters['distance'],
                      onChanged: (String val) {
                        setState(() {
                          _filters['distance'] = val;
                        });
                      }),
                ),
                ListTile(
                  title: Text('Sort by'),
                  trailing: DropdownButton<String>(
                      items: _dropdownMenuItem(list: _sortedby),
                      value: _filters['SortBy'],
                      onChanged: (String val) {
                        print(val);
                       setState(() {
                          _filters['SortBy'] = val;
                        });
                      }),
                ),
//                _divider(),
//                _createTitle(title: 'Meal'),
//                _switchedButton(
//                    title:'Good For Breakfast',
//                  path: 'Meal'
//                ),
//                _switchedButton(
//                    title:'Good For Brunch',
//                    path: 'Meal'
//                ),
//                _switchedButton(
//                    title:'Good For Launch',
//                    path: 'Meal'
//                ),
//                _switchedButton(
//                    title: 'Good For Dinner',
//                    path: 'Meal'
//                ),
//                _switchedButton(
//                    title: 'Good For Dessert',
//                    path: 'Meal'
//                ),_switchedButton(
//                    title: 'Good For Late Night',
//                    path: 'Meal'
//                ),
//                _createTitle(title: 'Good For'),
//                _switchedButton(
//                    title: 'Good For Kids' ,
//                  path: 'Good For'
//                ),
//                _switchedButton(
//                    title:  'Good For Groups',
//                    path: 'Good For'
//                ),
//                _switchedButton(
//                    title: 'Good For Happy Hour' ,
//                    path: 'Good For'
//                ),
//                _createTitle(title: 'Amenities & Ambiance'),
//                _isTakeOut?_switchedButton(
//                    title: 'WheelChair Accessible' ,path: 'Amentities & Ambiance'
//                ):SizedBox(),
//                _switchedButton(
//                    title: 'Takes Reservations',path: 'Amentities & Ambiance'
//                ),
//                _isTakeOut?_switchedButton(
//                    title: 'Free Wi-Fi',path: 'Amentities & Ambiance'
//                ):SizedBox(),
//                _switchedButton(
//                    title: 'Offers Takeout',path: 'Amentities & Ambiance'
//                ),
//                _switchedButton(
//                    title: 'Outboor Seating',path: 'Amentities & Ambiance'
//                ),_switchedButton(
//                    title: 'Full Bar',path: 'Amentities & Ambiance'
//                ),
//                _createTitle(title: 'Payment'),
//                _switchedButton(
//                    title: 'Accepts Credit Cards',path: 'Payment'
//                ),
//                _switchedButton(
//                    title: 'Offering a Deal',path: 'Payment'
//                ),
//                _isTakeOut?_switchedButton(
//                    title: 'Offers Military Discount',path: 'Payment'
//                ):SizedBox(),
//                _createTitle(title: 'General'),
//    _switchedButton(title: 'Open to All',path: 'General'),
                //Spacer()
              ],
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel',style: TextStyle(fontSize: 18,color: Colors.grey),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              'Search',
              style: TextStyle(fontSize: 18,color: Color(0xffc62828)),
              
            ),
            onPressed: () {
              _priceLevel.clear();
              _changeContainerColor.length;
              print(_changeContainerColor);
              for(int i = 0; i<_changeContainerColor.length; i++){
                if(_changeContainerColor[i] == true && i ==0){
                  _priceLevel.add('PriceLevel.free');
                }
                if(_changeContainerColor[i] == true && i ==1){
                  _priceLevel.add('PriceLevel.inexpensive');
                }
                if(_changeContainerColor[i] == true && i ==2){
                  _priceLevel.add('PriceLevel.moderate');
                }
                if(_changeContainerColor[i] == true && i ==3){
                  _priceLevel.add('PriceLevel.expensive');
                }
                if(_changeContainerColor[i] == true && i ==4){
                  _priceLevel.add('PriceLevel.veryExpensive');
                }
              }
              if(_filters['distance'] =='Default'){
                    dist = 0.0;
              }
              if(_filters['distance'] =='0.5 km'){
                dist = 0.5;
              }
              if(_filters['distance'] =='1 km'){
                dist = 1.0;
              }
              if(_filters['distance'] =='1.5 km'){
                dist = 1.5;
              }
              if(_filters['distance'] =='2 km'){
                dist = 2.0;
              }
              if(_filters['distance'] =='2.5 km'){
                dist = 2.5;
              }
              if(_filters['distance'] =='3 km'){
                dist = 3.0;
              }
              if(_filters['distance'] =='3.5 km'){
                dist = 3.5;
              }
              if(_filters['SortBy'] =='Default'){
                rating =0.0;
              }
              print(_filters['SortBy']);
              if(_filters['SortBy'] =='Rating'){
                rating =1.0;
              }
              if(_filters['openNow'] != false || rating !=0.0 ||_priceLevel.length >0 || dist!=0.0){
                Provider.of<Categorys>(context,listen: false).filterPlaces(
                  distance: dist,
                  openNow: _filters['openNow'].toString(),
                  rating: rating,
                  price: _priceLevel,
                );
                Navigator.of(context).pop();
              }else{
                Toast.show('Please select something', context);
              }
              },
          ),
          dist!=0.0 ||rating!=0.0|| _changeContainerColor.contains(true)||_priceLevel.length>0||_filters['openNow']==true?FlatButton(
            child: Text('Reset',style: TextStyle(fontSize: 18,color: Colors.grey),),
            onPressed: () {
              _resetFilters();

            },
          ):SizedBox(),
        ],
      ),
    );
  }
}
