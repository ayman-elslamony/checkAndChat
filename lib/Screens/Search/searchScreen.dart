import 'dart:io';

import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/Providers/resturants.dart';
import 'package:checkandchat/Screens/Search/searchWidgets/item_details/item_details.dart';
import 'package:checkandchat/chats/widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Providers/change_index_page.dart';
import '../../models/http_exception.dart';
import 'searchWidgets/filters_content.dart';
import 'searchWidgets/map.dart';
import '../../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';



class Search extends StatefulWidget {
  static const routeName = '/Search';

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Map<String, bool> _isClicked = {
    'Offers Takeout': false,
    'Open Now': false,
    'Good for Dinner': false,
    'Yelp TakeOut': false,
    'Cash Back': false,
  };

  bool _showItems = false;
  bool _isSearchSelected = true;
  bool _showItemsOnMap = false;
  String type;
  TextEditingController _searchTextEditingController = TextEditingController();
  TextEditingController _searchTextEditingController1 = TextEditingController();

  List<String> _allItems = [
//    LocaleKeys.restaurants.tr(),
//    // "Restaurants",
//    "Coffee Shop",
//    "Accounting",
//    "Shopping",
//    "Hospital",
//    "Pharmacy",
//    "Gas Station",
    LocaleKeys.restaurants.tr(),
    LocaleKeys.coffeeShops.tr(),
    LocaleKeys.accounting.tr(),
    LocaleKeys.shopping.tr(),
    LocaleKeys.hospital.tr(),
    LocaleKeys.pharmacy.tr(),
    LocaleKeys.gas.tr(),
  ];
  final List<String> imgList = [
    'https://i.shgcdn.com/090926b8-3cdf-4326-a80d-0ba0db8d6cba/-/format/auto/-/preview/3000x3000/-/quality/lighter/',
    'https://www.flavcity.com/wp-content/uploads/2018/05/healthy-meal-prep-recipes.jpg',
    'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/quick-easy-dinner-recipes-1570475391.jpg?crop=0.668xw:1.00xh;0.171xw,0&resize=640:*',
    'https://images.immediate.co.uk/production/volatile/sites/2/2016/02/20501.jpg?quality=90&resize=600%2C400',
    'https://si.wsj.net/public/resources/images/BN-WG554_MEALS_P_20171121164707.jpg',
    'https://i2.wp.com/lisagcooks.com/wp-content/uploads/2017/01/Instant-Pot-Hot-Beef.jpg'
  ];
  List<String> _suggestionList = List<String>();
  Future<List<NetworkImage>> listOFNetwork;
  Auth _auth;
  LatLng _currentPosition;
  String errorMessage = '';
  String _typeOfNavigate;

  _autoSuggestion(String val) {
    if (_searchTextEditingController1.text.isEmpty) {
      _suggestionList.clear();
    } else {
      for (int i = 0; i < _allItems.length; i++) {
        if (_allItems[i].toLowerCase().startsWith(val.toLowerCase())) {
          if (!_suggestionList.contains(_allItems[i])) {
            setState(() {
              _suggestionList.add(_allItems[i]);
            });
          }
        }
      }
    }
    print(_suggestionList);
  }

  _buttonIsClicked({String buttonName}) {
    setState(() {
      _isClicked[buttonName] = !_isClicked[buttonName];
    });
  }

  _convetURlImgToNetworkImage() {
    List<NetworkImage> _listImg = List<NetworkImage>();
    for (int i = 0; i < imgList.length; i++) {
      _listImg.add(NetworkImage(imgList[i]));
    }
    return _listImg;
  }

  Widget _createButton({Widget widgetOne, Widget widgetTwo,Function function,String name = ''}) {
    return InkWell(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          padding: EdgeInsets.all(4.0),
          // height: 18,
          //width: 110,
          decoration: BoxDecoration(
            color: name == ''
                ? Colors.grey.shade200
                : _isClicked[name] == false
                    ? Colors.grey.shade200
                    : Colors.blue,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: Colors.black12),
          ),
          child: Center(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: widgetOne,
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: widgetTwo,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Divider _divider() {
    return Divider(
      color: Colors.grey,
      thickness: 1.0,
      height: 1,
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Enable Now'),
            onPressed: () {
              getLocation();
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              _showErrorDialog('App will Appear more error');
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  getLocation() async{
    try {
      await Provider.of<Auth>(context, listen: false).getLocation().then((x) {
        if (x) {
          setState(() {
            _currentPosition =
                Provider.of<Auth>(context, listen: false).myLatLng;
          });
        }
      });
    } on HttpException catch (error) {
      switch (error.toString()) {
        case "PERMISSION_DENIED":
          errorMessage = "Please enable Your Location";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not get your location. Please try again.';
      _showErrorDialog(errorMessage);
    }
  }

  Widget _createImage({String imgUrl}) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(6),
        child: FadeInImage.assetNetwork(placeholder: 'images/placeholder.png', image: imgUrl,
          height: 85,
          width: 90,
          fit: BoxFit.cover,
          fadeInCurve: Curves.bounceIn,
        )
      ),
    );
  }

  @override
  void initState() {
    _auth = Provider.of<Auth>(context, listen: false);
    _currentPosition =
       _auth.myLatLng;
    var x =
        Provider.of<Categorys>(context, listen: false).navigateFromOtherPage;
    if (x) {
      _showItems = x;
      _typeOfNavigate =
          Provider.of<Categorys>(context, listen: false).typeOfCategory;
      type = _typeOfNavigate;
      _searchTextEditingController.text = toBeginningOfSentenceCase(_typeOfNavigate);
      Provider.of<Categorys>(context, listen: false).changeNavigate(typeOfCategory:'',isNavigate: false);
    }
    super.initState();
  }
  Future<void> _refreshList({String title}) async {
    if (title == 'Restaurants' || title == 'مطاعم') {
      type = 'restaurant';
    } else if (title == 'Coffee Shop') {
      type = 'cafe';
    } else if (title == 'Accounting') {
      type = 'accounting';
    } else if (title == 'Shopping') {
      type = 'shopping_mall';
    } else if (title == 'Gas Station') {
      type = 'gas_station';
    } else if (title == 'Hospital') {
      type = 'hospital';
    } else if (title == 'Pharmacy') {
      type = 'pharmacy';
    }
    Provider.of<Categorys>(context, listen: false).getNearbyPlaces(
        type: type.trim(), currentLocation: _currentPosition,radius: 3500);
    setState(() {
      _typeOfNavigate = '';
      _showItems = true;
      _isSearchSelected = true;
      _searchTextEditingController.text = title;
      _suggestionList.clear();
    });
  }
  Widget _searchContent({String imgUrl, String title}) {
    return InkWell(
      onTap: () => _refreshList(title: title),
      child: ListTile(
        leading: Image.asset(
          imgUrl,
          height: 30,
          width: 30,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
  Widget _allSuggestionItems() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            _searchContent(
                imgUrl: 'images/nearByIcons/meal.png', title: LocaleKeys.restaurants.tr()),
            _searchContent(
                imgUrl: 'images/nearByIcons/tea.png', title: LocaleKeys.coffeeShops.tr()),
            _searchContent(
                imgUrl: 'images/nearByIcons/accounting.png', title: LocaleKeys.accounting.tr()),
            _searchContent(
                imgUrl: 'images/nearByIcons/shopping.png', title: LocaleKeys.shopping.tr()),
            _searchContent(
                imgUrl: 'images/nearByIcons/gas.png', title: LocaleKeys.gas.tr()),
            _searchContent(
                imgUrl: 'images/nearByIcons/hospital.png', title: LocaleKeys.hospital.tr()),
            _searchContent(
                imgUrl: 'images/nearByIcons/pharmacy.png', title: LocaleKeys.pharmacy.tr()),
          ],
        ),
      ),
    );
  }
  _alertDialog() {
    showDialog(
      context: context,
      builder: (ctx) => FiltersContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;


        Widget _createResultCard({Category result}) {
      String _priceLevel = '';
      if (result.priceLevel == 'PriceLevel.free') {
        _priceLevel = 'free';
      }
      if (result.priceLevel == 'PriceLevel.inexpensive') {
        _priceLevel = 'inexpensive';
      }
      if (result.priceLevel == 'PriceLevel.moderate') {
        _priceLevel = 'moderate';
      }
      if (result.priceLevel == 'PriceLevel.expensive') {
        _priceLevel = 'expensive';
      }
      if (result.priceLevel == 'PriceLevel.veryExpensive') {
        _priceLevel = 'veryExpensive';
      }
      String type = result.types[0];
      result.types.forEach((t) {
        if (t != result.types[0] &&
            t != 'point_of_interest' &&
            t != 'establishment') {
          type = type + ',$t';
        }
      });
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetails(id: result.id,)));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 14.0,right: 20,left: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200],
            ),
            width: _width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          result.name,
                          style: _textStyle.copyWith(
                              fontSize: _width * 0.04, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(2)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RatingBar(
                        initialRating: result.rating,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                        ratingWidget: RatingWidget(full: Icon(
                          Icons.stars,
                          color: Color(0xffc62828),
                        ), half: Icon(
                          Icons.stars,
                          color: Color(0xffc62828),
                        ), empty: Icon(
                          Icons.stars,
                          color: Colors.grey,
                        )),
                        unratedColor: Colors.grey,
                        itemSize: 22,
                        ignoreGestures: true,
                        onRatingUpdate: (double value) {},
                      ),
                      Text('${result.distance.toStringAsFixed(4)} km',style: TextStyle(
                          fontSize: _width * 0.03,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500
                      ),)
                            //                      Padding(
                            //                        padding: EdgeInsets.all(8),
                            //                      ),
                            //                      Text(
                            //                        '14 Reviews',
                            //                        style: _textStyle.copyWith(
                            //                            fontSize: _width * 0.035,
                            //                            fontWeight: FontWeight.w500),
                            //                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(2)),
                  Text(
                    type,
                    style: _textStyle.copyWith(
                        fontSize: _width * 0.04,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                  ),
                  result.openNow == 'none'
                      ? SizedBox()
                      : Text(
                          result.openNow == 'true' ? 'Open Now' : 'Closed Now',
                          style: _textStyle.copyWith(
                              fontSize: _width * 0.04,
                              color: Colors.green,
                              fontWeight: FontWeight.w500),
                        ),
                  Padding(padding: EdgeInsets.all(2)),
                  Text(
                    result.vicinity,
                    style: _textStyle.copyWith(
                        fontSize: _width * 0.032,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(padding: EdgeInsets.all(2)),
                  result.priceLevel == ''
                      ? SizedBox()
                      : Row(
                          children: <Widget>[
                            Icon(
                              Icons.bookmark,
                              color: Colors.green,
                              size: _width * 0.045,
                            ),
                            Text(
                              ' price level ',
                              style: _textStyle.copyWith(
                                fontSize: _width * 0.033,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              _priceLevel,
                              style: _textStyle.copyWith(
                                fontSize: _width * 0.033,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                  result.imgUrl.isEmpty
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: <Widget>[
                              result.imgUrl.length == 1
                                  ? Expanded(
                                      child: FadeInImage.assetNetwork(placeholder: 'images/placeholder.png', image: result.imgUrl[0],
                                        height: _height * 0.25,
                                        fit: BoxFit.cover,
                                      fadeInCurve: Curves.bounceIn,
                                      ))
                                  : SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) =>
                                            _createImage(
                                                imgUrl: result.imgUrl[index]),
                                        itemCount: result.imgUrl.length,
                                      ))
                            ],
                          ),
                        ),
                  Center(
                    child: InkWell(
                      onTap: result.phone == '' ? null : () {},
                      child: Container(
                        width: _width * 0.9,
                        height: 38.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.grey)),
                        child: Center(
                          child: Text(
                            'Call',
                            style: _textStyle.copyWith(
                                color: result.phone == ''
                                    ? Colors.grey
                                    : Colors.blue,
                                fontSize: _width * 0.05),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
//    Widget _createMenuList({Widget image, String title, Function function}) {
//      return InkWell(
//        onTap: function,
//        child: Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: Column(
//            children: <Widget>[
//              SizedBox(
//                height: 34,
//                child: image,
//                // size: 45,
//                // color: Colors.black54,
//              ),
//              SizedBox(
//                height: 5.0,
//              ),
//              Text(title,
//                  style: _textStyle.copyWith(
//                      fontSize: 12,
//                      color: Colors.black54,
//                      fontWeight: FontWeight.w500))
//            ],
//          ),
//        ),
//      );
//    }


    Future<Null> openDialog() async {
      switch (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              contentPadding: EdgeInsets.only(
                  left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  margin: EdgeInsets.all(10.0),
                  height: 120.0,
                  child: Column(
                    children: <Widget>[

                      Text(
                        'Are you sure to exit app?',
                        style: TextStyle(color: primaryColor, fontSize: 16.0),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, 0);
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(
                                    Icons.cancel,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                  margin: EdgeInsets.only(right: 10.0),
                                ),
                                Text(
                                  'CANCEL',
                                  style: TextStyle(
                                      color: primaryColor, fontWeight: FontWeight.bold,fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, 1);
                            },
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(
                                    Icons.check_circle,
                                    color: primaryColor,
                                    size: 18,
                                  ),
                                  margin: EdgeInsets.only(right: 10.0),
                                ),
                                Text(
                                  'YES',
                                  style: TextStyle(
                                      color: primaryColor, fontWeight: FontWeight.bold,fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            );
          })) {
        case 0:
          break;
        case 1:
          exit(0);
          break;
      }
    }

    Future<bool> onBackPress() {
      openDialog();
      return Future.value(false);
    }

    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  bottom: PreferredSize(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Consumer<ChangeIndex>(
                              builder: (context, index, _) => InkWell(
                                onTap: () {
                                  setState(() {
                                    _isSearchSelected = false;
                                  });
                                },
                                child: TextFormField(
                                  enabled: false,
                                  controller: _searchTextEditingController,
                                  decoration: InputDecoration(
                                    hintText:
                                        LocaleKeys.searchTitle.tr(),
                                    hintStyle: TextStyle(fontSize: _width * 0.035,fontFamily: 'Cairo'),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: !_showItemsOnMap
                                  ? ImageIcon(
                                      AssetImage(
                                          'images/searchScreenIcons/map.png'),
                                      size: 35,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                              onPressed: () {
                                setState(() {
                                  _showItemsOnMap = !_showItemsOnMap;
                                });
                              })
                        ],
                      ),
                    ),
                    preferredSize: Size(_width, _height * 0.028),
                  ),
                  backgroundColor: Color(0xffc62828),
                ),
                body: Column(
                  children: <Widget>[
                              //                  SizedBox(
                              //                    width: _width,
                              //                    height: 50,
                              //                    child: ListView(
                              //                      scrollDirection: Axis.horizontal,
                              //                      children: <Widget>[
                              //                        _createButton(
                              //                            widgetOne: ImageIcon(
                              //                              AssetImage('images/searchScreenIcons/filter.png'),
                              //                              color: Colors.black54,
                              //                            ),
                              //                            widgetTwo: Text(
                              //                              'Filters',
                              //                              style: _textStyle.copyWith(fontSize: 16),
                              //                            ),
                              //                            function: _alertDialog),
                              ////                        _createButton(
                              ////                            widgetOne: ImageIcon(
                              ////                              AssetImage('images/searchScreenIcons/filter.png'),
                              ////                              color: Colors.black54,
                              ////                            ),
                              ////                            widgetTwo: Text(
                              ////                              'Sort',
                              ////                              style: _textStyle.copyWith(fontSize: 16),
                              ////                            ),
                              ////                            function: () {
                              ////                              showModalBottomSheet(
                              ////                                  backgroundColor: Colors.white,
                              ////                                  shape: RoundedRectangleBorder(
                              ////                                      borderRadius: BorderRadius.only(
                              ////                                          topRight: Radius.circular(10),
                              ////                                          topLeft: Radius.circular(10))),
                              ////                                  context: context,
                              ////                                  builder: (BuildContext context) {
                              ////                                    return SortBy();
                              ////                                  });
                              ////                            }),
                              ////                        _createButton(
                              ////                            widgetOne: Text(
                              ////                              'Offers Takeout',
                              ////                              style: _textStyle.copyWith(fontSize: 16),
                              ////                            ),
                              ////                            widgetTwo: SizedBox(
                              ////                              width: 0.0,
                              ////                            ),
                              ////                            name: 'Offers Takeout',
                              ////                            function: () {
                              ////                              _buttonIsClicked(buttonName: 'Offers Takeout');
                              ////                            }),
                              ////                        _createButton(
                              ////                            widgetOne: Text(
                              ////                              'Open Now',
                              ////                              style: _textStyle.copyWith(fontSize: 16),
                              ////                            ),
                              ////                            widgetTwo: SizedBox(
                              ////                              width: 0.0,
                              ////                            ),
                              ////                            name: 'Open Now',
                              ////                            function: () {
                              ////                              _buttonIsClicked(buttonName: 'Open Now');
                              ////                            }),
                              ////                        _createButton(
                              ////                            widgetOne: Text(
                              ////                              'Yelp TakeOut',
                              ////                              style: _textStyle.copyWith(fontSize: 16),
                              ////                            ),
                              ////                            widgetTwo: SizedBox(
                              ////                              width: 0.0,
                              ////                            ),
                              ////                            name: 'Yelp TakeOut',
                              ////                            function: () {
                              ////                              _buttonIsClicked(buttonName: 'Yelp TakeOut');
                              ////                            }),
                              ////                        _createButton(
                              ////                            widgetOne: Text(
                              ////                              'Price',
                              ////                              style: _textStyle.copyWith(fontSize: 16),
                              ////                            ),
                              ////                            widgetTwo: ImageIcon(
                              ////                              AssetImage('images/searchScreenIcons/filter.png'),
                              ////                              color: Colors.black54,
                              ////                            ),
                              ////                            function: () {
                              ////                              showDialog(
                              ////                                context: context,
                              ////                                builder: (BuildContext context) {
                              ////                                  return AlertDialog(
                              ////                                    titleTextStyle:
                              ////                                        _textStyle.copyWith(color: Colors.red),
                              ////                                    shape: RoundedRectangleBorder(
                              ////                                        borderRadius: BorderRadius.all(
                              ////                                            Radius.circular(25.0))),
                              ////                                    title: Text(
                              ////                                      "Select Price",
                              ////                                      textAlign: TextAlign.center,
                              ////                                    ),
                              ////                                    content: Padding(
                              ////                                      padding: const EdgeInsets.only(top: 8.0),
                              ////                                      child: ContainerDollars(),
                              ////                                    ),
                              ////                                    actions: <Widget>[
                              ////                                      FlatButton(
                              ////                                        child: Text(
                              ////                                          "Ok",
                              ////                                          style: TextStyle(color: Colors.red),
                              ////                                        ),
                              ////                                        onPressed: () {
                              ////                                          Navigator.of(context).pop();
                              ////                                        },
                              ////                                      ),
                              ////                                      FlatButton(
                              ////                                        child: Text(
                              ////                                          "Close",
                              ////                                          style: TextStyle(color: Colors.red),
                              ////                                        ),
                              ////                                        onPressed: () {
                              ////                                          Navigator.of(context).pop();
                              ////                                        },
                              ////                                      ),
                              ////                                    ],
                              ////                                  );
                              ////                                },
                              ////                              );
                              ////                            }),
                              ////                        _createButton(
                              ////                            widgetOne: Text(
                              ////                              'Cash Back',
                              ////                              style: _textStyle.copyWith(fontSize: 16),
                              ////                            ),
                              ////                            widgetTwo: SizedBox(
                              ////                              width: 0.0,
                              ////                            ),
                              ////                            name: 'Cash Back',
                              ////                            function: () {
                              ////                              _buttonIsClicked(buttonName: 'Cash Back');
                              ////                            }),
                              ////                        _createButton(
                              ////                            widgetOne: Text(
                              ////                              'All Filters',
                              ////                              style: _textStyle.copyWith(fontSize: 16),
                              ////                            ),
                              ////                            widgetTwo: SizedBox(
                              ////                              width: 0.0,
                              ////                            ),
                              ////                            function: () {}),
                              //                      ],
                              //                    ),
                              //                  ),
                      SizedBox(
                        height: 8.0,
                      ),
                      _showItemsOnMap
                          ? Expanded(
                              //height: _height * 0.65,
                              child: ShowItemsOnMap(
                                type: type,
                              ))
                          : SizedBox(),

                                                    //                  Column(
                                                    //                          children: <Widget>[
                                                    //                            _divider(),
                                                    //                     SizedBox(
                                                    //                       width: _width,
                                                    //                       height: 85,
                                                    //                       child: Padding(
                                                    //                         padding: const EdgeInsets.all(5.0),
                                                    //                         child: ListView(
                                                    //                           scrollDirection: Axis.horizontal,
                                                    //                           children: <Widget>[
                                                    //                             _createMenuList(
                                                    //                                 image: Image.asset(
                                                    //                                     'images/searchScreenIcons/breakfast.png'),
                                                    //                                 title: 'Breakfast',
                                                    //                                 function: () {}),
                                                    //                             _createMenuList(
                                                    //                                 image: Image.asset(
                                                    //                                     'images/searchScreenIcons/pizza.png'),
                                                    //                                 title: 'Pizza',
                                                    //                                 function: () {}),
                                                    //                             _createMenuList(
                                                    //                                 image: Image.asset(
                                                    //                                     'images/searchScreenIcons/chilli.png'),
                                                    //                                 title: 'Mexican',
                                                    //                                 function: () {}),
                                                    //                             _createMenuList(
                                                    //                                 image: Image.asset(
                                                    //                                     'images/searchScreenIcons/noodles.png'),
                                                    //                                 title: 'Chinese',
                                                    //                                 function: () {}),
                                                    //                             _createMenuList(
                                                    //                                 image: Image.asset(
                                                    //                                     'images/searchScreenIcons/burger.png'),
                                                    //                                 title: 'Burgers',
                                                    //                                 function: () {}),
                                                    //                             _createMenuList(
                                                    //                                 image: Image.asset(
                                                    //                                     'images/searchScreenIcons/thailand.png'),
                                                    //                                 title: 'thai',
                                                    //                                 function: () {}),
                                                    //                             _createMenuList(
                                                    //                                 image: Image.asset(
                                                    //                                     'images/searchScreenIcons/sandwich.png'),
                                                    //                                 title: 'Sandawiches',
                                                    //                                 function: () {}),
                                                    //                             _createMenuList(
                                                    //                                 image: Image.asset(
                                                    //                                     'images/searchScreenIcons/crab.png'),
                                                    //                                 title: 'Seafood',
                                                    //                                 function: () {}),
                                                                                // _createMenuList(
                                                                                //     image: Image.asset('images/searchScreenIcons/breakfast.png'), title: 'Italian', function: () {}),
                                                                                // _createMenuList(
                                                                                //     image: Image.asset('images/searchScreenIcons/breakfast.png'),
                                                                                //     title: 'Steakhouses',
                                                                                //     function: () {}),
                                                                                // _createMenuList(
                                                                                //     image: Image.asset('images/searchScreenIcons/breakfast.png'), title: 'Korean', function: () {}),
                                                                                // _createMenuList(
                                                                                //     image: Image.asset('images/searchScreenIcons/breakfast.png'), title: 'Japanese', function: () {}),
                                                                                // _createMenuList(
                                                                                //     image: Image.asset('images/searchScreenIcons/breakfast.png'), title: 'Vietnamese', function: () {}),
                                                                                // _createMenuList(
                                                                                //     image: Image.asset('images/searchScreenIcons/breakfast.png'), title: 'Vegetarian', function: () {}),
                                                    //                             _createMenuList(
                                                    //                                 image: Image.asset(
                                                    //                                     'images/searchScreenIcons/sushi.png'),
                                                    //                                 title: 'Sushi Bars',
                                                    //                                 function: () {}),
                                                    //                             _createMenuList(
                                                    //                                 image: Image.asset(
                                                    //                                     'images/searchScreenIcons/ketchup.png'),
                                                    //                                 title: 'American',
                                                    //                                 function: () {}),
                                                    //                           ],
                                                    //                         ),
                                                    //                       ),
                                                    //                     ),
                                                    //                     SizedBox(
                                                    //                       height: 8.0,
                                                    //                     ),
                                                    //                     _divider(),

                                                    //                          ],
                                                    //                        )
                                                                    //TODO:Make what you need
                                                    //                  _showItems
                                                    //                      ? SizedBox()
                                                    //                      : SizedBox(
                                                    //                    height: _height*50,
                                                    //                        width: _width,
                                                    //                        child: Carousel(
                                                    //                            animationDuration: Duration(seconds: 3),
                                                    //                            borderRadius: true,
                                                    //                            images: _convetURlImgToNetworkImage(),
                                                    //                            autoplay: true,
                                                    //                            boxFit: BoxFit.fill,
                                                    //                            showIndicator: false,
                                                    //                        ),
                                                    //                      ),
                    _showItems && _showItemsOnMap == false
                        ?Expanded(
                          child: FutureBuilder(
                          future: _typeOfNavigate == ''
                              ? Provider.of<Categorys>(context, listen: false).getNearbyPlaces(
                              type: type.trim(), currentLocation: _currentPosition)
                              : Provider.of<Categorys>(context,
                              listen: false)
                              .getNearbyPlaces(
                              type: _typeOfNavigate,
                              radius: 3500,
                              currentLocation:
                              _auth.myLatLng),
                          builder: (ctx, dataSnapshot) {
                            if(dataSnapshot.connectionState == ConnectionState.done && dataSnapshot.data != []){
                             return RefreshIndicator(
                               color: Colors.red,
                               backgroundColor: Colors.white,
                               onRefresh: () => _typeOfNavigate ==
                                   ''
                                   ? _refreshList(
                                   title: type)
                                   : Provider.of<Categorys>(
                                   context,
                                   listen: false)
                                   .getNearbyPlaces(
                                 radius: 3500,
                                   type:
                                   _typeOfNavigate,
                                   currentLocation:
                                   _auth
                                       .myLatLng),
                               child: Consumer<Categorys>(
                                   builder:
                                       (ctx, resturantsData,
                                       _){
                                    //  print('bfdbfd');
                                     if(resturantsData.resturants.length == 0){
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[

                                            Center(
                                              child: Text(
                                                  'There is no ${_typeOfNavigate == '' ? type : _typeOfNavigate} in this area',
                                                  style: TextStyle(fontSize: 18,color: Colors.grey[700]),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                     }else{
                                       return  ListView
                                           .builder(
                                         itemBuilder:
                                             (context, index) =>
                                             _createResultCard(result: resturantsData.resturants[index]),
                                         itemCount: resturantsData
                                             .resturants
                                             .length,
                                       );
                                     }
                                   }
                               ),
                             );
                            }else
                              return Center(
                                  child:
                                  CircularProgressIndicator(
                                    backgroundColor: Colors.red,
                                  ));
                            }),
                        )
                        : SizedBox(
                      height: 0.1,
                    ),
                    SizedBox(height: 60,)
                  ],

                ),
              ),
              _showItems? _showItemsOnMap?
              Positioned(
               child:  RaisedButton(
               onPressed: _alertDialog,
                child:
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('images/searchScreenIcons/filter.png'),
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          LocaleKeys.filter.tr(),
                          style: _textStyle.copyWith(fontSize: _width*0.04,color: Colors.white,fontFamily: 'Cairo'),
                        ),

                      ],),
                  ),
               color: Color(0xffc62828),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
             ),
             right: 18.0,bottom: 8.0,left: 18.0,
             ):
             Positioned(
               child:  RaisedButton(
               onPressed: _alertDialog,
                child:
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ImageIcon(
                          AssetImage('images/searchScreenIcons/filter.png'),
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          '  Filters',
                          style: _textStyle.copyWith(fontSize: _width*0.04,color: Colors.white),
                        ),

                      ],),
                  ),
               color: Color(0xffc62828),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
             ),
             right: 18.0,bottom: 8.0,left: 18.0,)
                  :SizedBox(),
              _isSearchSelected
                  ? SizedBox(
                      height: 0.1,
                    )
                  : Positioned(
                      top: 0.1,
                      left: 0.1,
                      right: 0.1,
                      child: Container(
                        height: _height * 0.60,
                        width: _width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40)),
                          color: Color(0xffFFFAFA),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 2),
                                        right: BorderSide(color: Colors.grey))),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey),
                                                    right: BorderSide(
                                                        color: Colors.grey))),
                                            child: TextFormField(
                                              controller:
                                                  _searchTextEditingController1,
                                              decoration: InputDecoration(
                                                hintText:
                                                    LocaleKeys.searchTitle.tr(),
                                                hintStyle: TextStyle(fontFamily: 'Cairo'),
                                                border: InputBorder.none,
                                                prefixIcon: Icon(
                                                  Icons.search,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              onChanged: (val) {
                                                setState(() {
                                                  _autoSuggestion(val);
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                              right:
                                                  BorderSide(color: Colors.grey),
                                            )),
                                            child: ListTile(
                                              leading: Icon(
                                                Icons.location_on,
                                                color: Color(0xffc62828),
                                              ),
                                              title: Text(
                                                LocaleKeys.currentLocation,
                                                style: TextStyle(
                                                    color: Color(0xffc62828),
                                                    fontSize: 18,fontFamily: 'Cairo'),
                                              ).tr(context: context),
                                              onTap: getLocation,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xffc62828),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(8.0))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 4.0),
                                                child: Icon(
                                                  Icons.search,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {},
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              _suggestionList.length == 0
                                  ? _allSuggestionItems()
                                  : Expanded(
                                      child: ListView.builder(
                                        itemBuilder: (ctx, index) => InkWell(
                                            onTap: () {
                                              _refreshList(
                                                  title: _suggestionList
                                                      .elementAt(index));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                              child: ListTile(
                                                title: Text(
                                                    '${_suggestionList[index]}',style: TextStyle(fontFamily: 'Cairo'),),
                                              ),
                                            )),
                                        itemCount: _suggestionList.length,
                                      ),
                                    ),
                              Row(
                                children: <Widget>[
                                  Spacer(),
                                  FlatButton(
                                    child: Text(
                                      LocaleKeys.cancel,
                                      style: _textStyle.copyWith(
                                          color: Colors.red, fontSize: 16),
                                    ).tr(context: context),
                                    onPressed: () {
                                      setState(() {
                                        _isSearchSelected = true;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 8.0)
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          onWillPop: onBackPress,
        ),
      ),
    );
  }
}