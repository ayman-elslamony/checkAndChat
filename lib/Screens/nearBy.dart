import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/Providers/resturants.dart';
import 'package:checkandchat/chats/widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../Providers/change_index_page.dart';
import 'Search/searchWidgets/item_details/item_details.dart';
import '../models/http_exception.dart';
import 'package:url_launcher/url_launcher.dart';
import '../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class NearBy extends StatefulWidget {
  @override
  _NearByState createState() => _NearByState();
}

class _NearByState extends State<NearBy> {
  Divider _divider() {
    return Divider(
      color: Colors.grey,
      thickness: 1.0,
      height: 1,
    );
  }

  Widget _createImage({String imgUrl}) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(6),
          child: FadeInImage.assetNetwork(
            placeholder: 'images/placeholder.png',
            image: imgUrl,
            height: 85,
            width: 90,
            fit: BoxFit.cover,
            fadeInCurve: Curves.bounceIn,
          )),
    );
  }

  bool _isLocationGet = false;
  bool _isPlacesGetting = false;
  Auth _auth;
  List<Category> _resturant = [];
  final List<String> imgList = [
    'https://i.shgcdn.com/090926b8-3cdf-4326-a80d-0ba0db8d6cba/-/format/auto/-/preview/3000x3000/-/quality/lighter/',
    'https://cdn.makegoodfood.ca/images/home/how-it-works/Goodfood_home_how_it_works_visual_4.jpg',
    'https://media-cdn.tripadvisor.com/media/photo-s/0d/6c/0e/d3/999-fried-chicken-breast.jpg',
    'https://images.immediate.co.uk/production/volatile/sites/2/2016/02/20501.jpg?quality=90&resize=600%2C400',
    'https://si.wsj.net/public/resources/images/BN-WG554_MEALS_P_20171121164707.jpg',
    'https://i2.wp.com/lisagcooks.com/wp-content/uploads/2017/01/Instant-Pot-Hot-Beef.jpg'
  ];

  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Auth>(context, listen: false);
    if (Provider.of<Categorys>(context, listen: false).nearByYou.length != 0) {
      _resturant = Provider.of<Categorys>(context, listen: false).nearByYou;
      setState(() {
        _isLocationGet = true;
        _isPlacesGetting = true;
      });
    } else {
      getLocationAndPOlaces();
    }
  }

  List<NetworkImage> _convetURlImgToNetworkImage() {
    List<NetworkImage> _listImg = List<NetworkImage>();
    for (int i = 0; i < imgList.length; i++) {
      _listImg.add(NetworkImage(imgList[i]));
    }
    return _listImg;
  }

  String errorMessage = '';

  void _showErrorDialogLocation(String message) {
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
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  getLocationAndPOlaces() async {
    if (_auth.myLatLng == null) {
      await getLocation();
    }

    if (this.mounted){
      setState(() {
        _isLocationGet = true;
      });
    }

    print(_auth.myLatLng);
    if (Provider.of<Categorys>(context, listen: false).nearByYou.length == 0) {
      _resturant = await Provider.of<Categorys>(context, listen: false)
          .getNearbyPlaces(
              type: 'restaurant',
              currentLocation: _auth.myLatLng,
              isCommingFromNearby: true);
      if(this.mounted){
        setState(() {
          _isPlacesGetting = true;
          _isPlacesGetting = true;
        });
      }

    } else {
      _resturant = Provider.of<Categorys>(context, listen: false).nearByYou;
      setState(() {
        _isPlacesGetting = true;
      });
    }
    print('_resturant.length${_resturant.length}');
  }

  getLocation() async {
    try {
      await Provider.of<Auth>(context, listen: false).getLocation();
    } on HttpException catch (error) {
      switch (error.toString()) {
        case "PERMISSION_DENIED":
          errorMessage = "Please enable Your Location";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      _showErrorDialogLocation(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not get your location. Please try again.';
      _showErrorDialogLocation(errorMessage);
    }
  }

  Future<void> _onRefresh() async {
    _resturant = await Provider.of<Categorys>(context, listen: false)
        .getNearbyPlaces(
            type: 'restaurant',
            currentLocation: _auth.myLatLng,
            isCommingFromNearby: true);
    setState(() {
      _isPlacesGetting = true;
      _isPlacesGetting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final _textStyle = Theme.of(context).textTheme.title;
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
                  builder: (context) => ItemDetails(
                        id: result.id,
                        isCommingFromNearBy: true,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 14.0, right: 20, left: 20),
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
                              fontSize: _width * 0.05, color: Colors.black87),
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
                        itemBuilder: (context, _) => Icon(
                          Icons.stars,
                          color: Color(0xffc62828),
                        ),
                        unratedColor: Colors.grey,
                        itemSize: 22,
                        ignoreGestures: true,
                        onRatingUpdate: (double value) {},
                      ),
                      Text(
                        '${result.distance.toStringAsFixed(4)} km',
                        style: TextStyle(
                            fontSize: _width * 0.03,
                            color: Colors.black45,
                            fontWeight: FontWeight.w500),
                      )
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
                                      child: FadeInImage.assetNetwork(
                                      placeholder: 'images/placeholder.png',
                                      image: result.imgUrl[0],
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
                      onTap: result.phone == ''
                          ? null
                          : () {
                              launch("tel:${result.phone}");
                            },
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

    Widget _fetchResturant() {
      return _resturant.length == 0
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      'There are no Reataurants in this area',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) =>
                  _createResultCard(result: _resturant[index]),
              itemCount: _resturant.length,
            );
    }

    _restaurantNearBy() {
      return FutureBuilder(
          future: Provider.of<Categorys>(context, listen: false)
              .getNearbyPlaces(
                  type: 'restaurant', currentLocation: _auth.myLatLng),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.done &&
                dataSnapshot.data != []) {
              return _fetchResturant();
            } else {
              return Container(
                  height: _height * 0.70,
                  width: _width,
                  child: Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Color(0xffc62828),
                  )));
            }
          });
    }

    Widget _createMenuList({Widget image, Widget title, Function function}) {
      return InkWell(
        onTap: function,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: _width * 0.0750,
                  child: image,
                  // size: 45,
                  // color: Colors.black54,
                ),
                SizedBox(
                  height: 5.0,
                ),
                title
              ],
            ),
          ),
        ),
      );
    }

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

    return Scaffold(
        body: WillPopScope(
          child: RefreshIndicator(
      color: Colors.red,
      backgroundColor: Colors.white,
      onRefresh: _onRefresh,
      child: CustomScrollView(

            //shrinkWrap: true,

            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                pinned: true,
                backgroundColor: Color(0xffc62828),
                expandedHeight: MediaQuery.of(context).size.height * 0.4,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Carousel(
                        images: _convetURlImgToNetworkImage(),
                        autoplay: true,
                        boxFit: BoxFit.fill,
                        showIndicator: false,
                        animationDuration: Duration(milliseconds: 800),
                        autoplayDuration: Duration(seconds: 8),
                      ),
                      Container(
                        color: Colors.black26,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: SizedBox(
                                  width: _width * 0.8,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Padding(
                                        padding: EdgeInsets.only(top: 40),
                                        child: Text(
                                          LocaleKeys.searchTitle,
                                          style: TextStyle(color: Colors.white,fontSize: _width * 0.035),
                                        ).tr(context: context)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: FlatButton(
                                  onPressed: null,
                                  color: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(5.0))),
                                    width: _width * 0.5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(2),
                                          ),
                                          Text(
                                            LocaleKeys.nearRest,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: _width * 0.032,fontFamily: 'Cairo'),
                                          ).tr(context: context)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottom: PreferredSize(
                  child: Consumer<ChangeIndex>(
                    builder: (context, changeIndex, _) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: InkWell(
                        onTap: () {
                          changeIndex.changeIndexFunction(1);
                        },
                        child: TextFormField(
                          autofocus: false,
                          enabled: false,
                          decoration: InputDecoration(
                            hintText:  LocaleKeys.searchTitle.tr(),
                            hintStyle: TextStyle(fontSize: _width * 0.04,fontFamily: 'Cairo'),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            contentPadding:
                                new EdgeInsets.symmetric(vertical: 10.0),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.black54,
                                ),
                                onPressed: () {}),
                          ),
                        ),
                      ),
                    ),
                  ),
                  preferredSize: Size(_width, _height * 0.025),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 5.0,
                  ),
                  Consumer<ChangeIndex>(
                    builder: (context, changeIndex, _) => GridView.count(
                      scrollDirection: Axis.vertical,
                      mainAxisSpacing: 1,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 5,
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      children: <Widget>[
                        _createMenuList(
                            image: Image.asset('images/nearByIcons/meal.png'),
                            title: Text(LocaleKeys.restaurants,
                                    style: _textStyle.copyWith(
                                        fontSize: _width * 0.022,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold))
                                .tr(context: context),
                            function: () {
                              Provider.of<Categorys>(context, listen: false)
                                  .changeNavigate(
                                      isNavigate: true,
                                      typeOfCategory: 'restaurant');
                              changeIndex.changeIndexFunction(1);
                            }),
                        _createMenuList(
                            image: Image.asset('images/nearByIcons/tea.png'),
                            title: Text(LocaleKeys.coffeeShops,
                                    style: _textStyle.copyWith(
                                        fontSize: _width * 0.02,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold))
                                .tr(context: context),
                            function: () {
                              Provider.of<Categorys>(context, listen: false)
                                  .changeNavigate(
                                      isNavigate: true, typeOfCategory: 'cafe');
                              changeIndex.changeIndexFunction(1);
                            }),
                        _createMenuList(
                            image:
                                Image.asset('images/nearByIcons/accounting.png'),
                            title: Text(LocaleKeys.accounting,
                                    style: _textStyle.copyWith(
                                        fontSize: _width * 0.022,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold))
                                .tr(context: context),
                            function: () {
                              Provider.of<Categorys>(context, listen: false)
                                  .changeNavigate(
                                      isNavigate: true,
                                      typeOfCategory: 'accounting');
                              changeIndex.changeIndexFunction(1);
                            }),
                        _createMenuList(
                            image: Image.asset('images/nearByIcons/shopping.png'),
                            title: Text(LocaleKeys.shopping,
                                    style: _textStyle.copyWith(
                                        fontSize: _width * 0.022,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold))
                                .tr(context: context),
                            function: () {
                              Provider.of<Categorys>(context, listen: false)
                                  .changeNavigate(
                                      isNavigate: true,
                                      typeOfCategory: 'shopping_mall');
                              changeIndex.changeIndexFunction(1);
                            }),
                        _createMenuList(
                            image: Image.asset('images/nearByIcons/gas.png'),
                            title: Text(LocaleKeys.gas,
                                    style: _textStyle.copyWith(
                                        fontSize: _width * 0.022,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold))
                                .tr(context: context),
                            function: () {
                              Provider.of<Categorys>(context, listen: false)
                                  .changeNavigate(
                                      isNavigate: true,
                                      typeOfCategory: 'gas_station');
                              changeIndex.changeIndexFunction(1);
                            }),
                        _createMenuList(
                            image: Image.asset('images/nearByIcons/hospital.png'),
                            title: Text(LocaleKeys.hospital,
                                    style: _textStyle.copyWith(
                                        fontSize: _width * 0.022,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold))
                                .tr(context: context),
                            function: () {
                              Provider.of<Categorys>(context, listen: false)
                                  .changeNavigate(
                                      isNavigate: true,
                                      typeOfCategory: 'hospital');
                              changeIndex.changeIndexFunction(1);
                            }),
                        _createMenuList(
                            image: Image.asset('images/nearByIcons/pharmacy.png'),
                            title: Text(LocaleKeys.pharmacy,
                                    style: _textStyle.copyWith(
                                        fontSize: _width * 0.022,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold))
                                .tr(context: context),
                            function: () {
                              Provider.of<Categorys>(context, listen: false)
                                  .changeNavigate(
                                      isNavigate: true,
                                      typeOfCategory: 'pharmacy');
                              changeIndex.changeIndexFunction(1);
                            }),
                        _createMenuList(
                            image: Image.asset('images/nearByIcons/more.png'),
                            title: Text(LocaleKeys.more,
                                    style: _textStyle.copyWith(
                                        fontSize: _width * 0.022,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold))
                                .tr(context: context),
                            function: () {}),
                      ],
                    ),
                  ),
                  _divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 14.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        LocaleKeys.nearRest,
                        style: TextStyle(
                            color: Colors.black54, fontSize: _width * 0.045),
                      ).tr(context: context),
                    ),
                  ),
                  _isLocationGet == false
                      ? Container(
                          height: _height * 0.70,
                          width: _width,
                          child: Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          )))
                      : _isPlacesGetting
                          ? _fetchResturant()
                          : Container(
                              height: _height * 0.70,
                              width: _width,
                              child: Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.red,
                              ))),
//            FutureBuilder(
//                    future: getLocation(),
//                    builder: (ctx, dataSnapshot) {
//                      if (dataSnapshot.connectionState ==
//                          ConnectionState.waiting) {
//                        return Container(
//                            height: _height * 0.70,
//                            width: _width,
//                            child: Center(
//                                child: CircularProgressIndicator(
//                              backgroundColor: Colors.blue,
//                            )));
//                      } else {
//                        if (dataSnapshot.error != null) {
//                          return Center(
//                            child: Text('An error occurred!'),
//                          );
//                        } else {
//                          return _restaurantNearBy();
//                        }
//                      }
//                    })
//                : _restaurantNearBy(),
                  SizedBox(
                    height: 10.0,
                  ),
                ]),
              )
            ]),
    ),
          onWillPop: onBackPress,
        ));
  }
}
