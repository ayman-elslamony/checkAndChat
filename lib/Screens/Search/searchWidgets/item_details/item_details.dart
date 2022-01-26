import 'dart:io';

import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/Providers/resturants.dart';
import 'package:checkandchat/Screens/Me/meWidgets/moreWidgets.dart/FriendPage.dart';
import 'package:checkandchat/Screens/Search/searchWidgets/item_details/show_place_location_and_directions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_pro/carousel_pro.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Providers/change_index_page.dart';
import 'package:share/share.dart';
import '../../../../Screens/Me/meWidgets/checkIn.dart';
import '../../../../Screens/Search/searchWidgets/item_details/full_menu.dart';
import '../../../../Screens/Search/searchWidgets/item_details/widgets/new_collection.dart';
import '../../../../Screens/Search/searchWidgets/item_details/widgets/show_Item_photos.dart';

import 'widgets/start_a_review.dart';
import 'widgets/zoom_in_and_out_to_image.dart';
import '../../../../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ItemDetails extends StatefulWidget {
  String id;
  bool isCommingFromCollection;
  Category category;
  bool isCommingFromNearBy;

  ItemDetails({this.id, this.isCommingFromCollection = false, this.category,this.isCommingFromNearBy=false});

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  bool _isloadingPhoto = false;
  Future<int> _getReview;
  ScrollController _scrollController;
  bool _showTitle = false;
  String userId;
  bool isUserMakeReaction=false;
  String descText =
      "Description Line 1Description Line 2Description Line 3Description LinDescription Line 1Description Line 2Description Line 3Description Line 4Description Line 5Description Line 6Description Line 7Description Line 8";
  bool descTextShowFlag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  Map<String, bool> _mapOfBottomNavigationbar = {
    'NearBy': false,
    'Search': false,
    'Me': false,
    'Activities': false,
    'Collections': false,
  };
  bool result = false;
  String _priceLevel = '';
  Category loadedProduct;
  String type = '';

  Future<void> _onRefresh() async {
    setState(() {
      result = true;
    });
  }

  _userId() async {
    if(Auth.userId==''){
      userId = await Provider.of<Auth>(context, listen: false).getUserId;
    }else{
      userId = Auth.userId;
    }
    print(userId);
  }

  @override
  void initState() {
    super.initState();
    _userId();
    if (widget.isCommingFromCollection) {
      loadedProduct = widget.category;
    } else {
      loadedProduct =
          Provider.of<Categorys>(context, listen: false).findById(id: widget.id,isCommingFromNearBy: widget.isCommingFromNearBy);
    }
    if (loadedProduct.priceLevel != '') {
      if (loadedProduct.priceLevel == 'PriceLevel.free') {
        _priceLevel = 'free';
      }
      if (loadedProduct.priceLevel == 'PriceLevel.inexpensive') {
        _priceLevel = 'inexpensive';
      }
      if (loadedProduct.priceLevel == 'PriceLevel.moderate') {
        _priceLevel = 'moderate';
      }
      if (loadedProduct.priceLevel == 'PriceLevel.expensive') {
        _priceLevel = 'expensive';
      }
      if (loadedProduct.priceLevel == 'PriceLevel.veryExpensive') {
        _priceLevel = 'veryExpensive';
      }
    }
    _getReview = Provider.of<Categorys>(context, listen: false)
        .getAllReviews(category: loadedProduct);
//    if(loadedProduct.types != null){
//      String types = loadedProduct.types[0];
//      loadedProduct.types.forEach((t) {
//        if (t != loadedProduct.types[0] &&
//            t != 'point_of_interest' &&
//            t != 'establishment') {
//          types = types + ',$t';
//        }
//      });
//      type = types;
//    }
//    _reviews = Provider.of<Categorys>(context, listen: false)
//        .getAllReviews(category: loadedProduct);
    _scrollController = ScrollController()
      ..addListener(() {
        _isAppBarExpanded
            ? setState(() {
                _showTitle = true;
              })
            : setState(() {
                _showTitle = false;
              });
      });
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > (300 - kToolbarHeight);
  }

  Divider _divider() {
    return Divider(
      color: Colors.grey,
      thickness: 1.0,
      height: 1,
    );
  }

  Widget _iconWithTitle({String title, Widget icon}) {
    return Row(
      children: <Widget>[
        icon,
        Padding(
          padding: const EdgeInsets.only(left: 3.5, right: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
        )
      ],
    );
  }

  Widget _iconWithTitleAndNumbers(
      {String title,
      int number,
      Widget icon,
      Function function,
      bool isColorChange}) {
    return InkWell(
      onTap: function,
      onLongPress: (){},
      onDoubleTap: (){},
      child: Row(
        children: <Widget>[
          icon,
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 14,
                  color:number !=0 ?Colors.red : Colors.black54),
            ),
          ),
          number ==0 ?SizedBox():Text(
            number.toString(),
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _listTile(
      {String title, String subtitle = '', IconData icon, Function function}) {
    return ListTile(
      title: Text(title),
      trailing: Icon(
        icon,
        color: Color(0xffc62828),
      ),
      subtitle: subtitle == ''
          ? null
          : Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
      onTap: function,
    );
  }

//  getDistance({double lat, double long}) async {
//    if (_auth.myLocation != null) {
//      double dis = await Geolocator().distanceBetween(
//          _auth.myLocation.latitude, _auth.myLocation.longitude, lat, long);
//      distance = dis * 0.001;
//    }
//  }



//  Widget _bottomNavigationbar({
//    String imgUrl,
//    String name,
//  }) {
//    double _width = MediaQuery.of(context).size.width;
//    return Consumer<ChangeIndex>(
//        builder: (context, changeIndex, _) => InkWell(
//              onTap: () {
//                setState(() {
//                  _mapOfBottomNavigationbar[name] =
//                      !_mapOfBottomNavigationbar[name];
//                });
//                if (name == 'NearBy') {
//                  changeIndex.changeIndexFunction(0);
//                }
//                if (name == 'Me') {
//                  changeIndex.changeIndexFunction(2);
//                }
//                if (name == 'Activities') {
//                  changeIndex.changeIndexFunction(3);
//                }
//                if (name == 'Collections') {
//                  changeIndex.changeIndexFunction(4);
//                }
//                Navigator.pushReplacementNamed(context, 'NearBy');
//              },
//              child: Column(
//                children: <Widget>[
//                  ImageIcon(
//                    AssetImage(imgUrl),
//                    size: _width * 0.055,
//                    color: _mapOfBottomNavigationbar[name]
//                        ? Colors.red
//                        : Colors.grey,
//                  ),
//                  Text(
//                    name,
//                    style: TextStyle(
//                      fontSize: _width * 0.03,
//                      color: _mapOfBottomNavigationbar[name]
//                          ? Colors.red
//                          : Colors.grey,
//                    ),
//                  ),
//                ],
//              ),
//            ));
//  }

  Widget _popularDishes({int index}) {
    int listLength = imgList.length;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final _textStyle = Theme.of(context).textTheme.title;
    return listLength != index
        ? InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => FullMenu()));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ShowImage(
                                  imgUrl: imgList[index],
                                )));
                      },
                      child: ClipRRect(
                        child: Image.network(
                          imgList[index],
                          width: _width * 0.44,
                          height: _height * 0.20,
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    Positioned(
                        child: Text(
                          '\$15.75',
                          style: _textStyle.copyWith(
                              color: Colors.white, fontSize: 18),
                        ),
                        bottom: 15.0,
                        left: 10.0,
                        right: 0.0)
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  'Cole Valley Crepe',
                  style: _textStyle.copyWith(color: Colors.black),
                ),
//          SizedBox(
//            height: 3.0,
//          ),
//          Text(
//            '10 Photos . 77 Reviews',
//            style: _textStyle.copyWith(
//                color: Colors.grey,
//                fontSize: 14),
//          ),
              ],
            ),
          )
        : InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => FullMenu()));
            },
            child: Container(
              width: _width * 0.24,
              height: _height * 0.20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.restaurant_menu,
                    color: Colors.red,
                  ),
                  Text(
                    'Full Menu',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )
                ],
              ),
            ),
          );
  }

  Widget _createIconWithText({Widget icon, String title, Function function}) {
    double _height = MediaQuery.of(context).size.height;
    final _textStyle = Theme.of(context).textTheme.title;
    return InkWell(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            icon,
            SizedBox(
              height: 5.0,
            ),
            Text(title,
                style: _textStyle.copyWith(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  void _addToCollection() {
    showDialog(
      context: _scaffoldKey.currentContext,
      builder: (context) => SingleChildScrollView(
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          title: Text(
            'Add To Collection',
            textAlign: TextAlign.center,
          ),
          content: FutureBuilder(
              future: Provider.of<Categorys>(context, listen: false)
                  .getAllCollections(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      height: 70,
                      width: 70,
                      child: Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Color(0xffc62828),
                      )));
                } else {
                  if (snapshot.error != null) {
                    return SizedBox(
                      height: 70,
                      child: Center(
                        child: Text('An error occurred!'),
                      ),
                    );
                  } else {
                    if (snapshot.data.length == 0) {
                      return Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              'There is no Collection',
                              style: TextStyle(color: Color(0xffc62828)),
                            ),
                          ));
                    } else {
                      return Container(
                        height: 70.0 * snapshot.data.length,
                        width: 350,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => ListTile(
                            onTap: () async {
                              String x = await Provider.of<Categorys>(context,
                                      listen: false)
                                  .addToCollection(
                                      resturant: loadedProduct,
                                      collectionName: snapshot.data[index]
                                          ['nameOfCollection']);
                              if (x == 'true') {
                                Toast.show("Successfully added", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                                Navigator.of(context).pop();
                              } else if (x == 'false') {
                                Toast.show(
                                    "failed to added please try again", context,
                                    duration: Toast.LENGTH_SHORT,
                                    gravity: Toast.BOTTOM);
                              } else if (x == 'already exits') {
                                Toast.show("Already Added", context,
                                    duration: Toast.LENGTH_SHORT,
                                    gravity: Toast.BOTTOM);
                                Navigator.of(context).pop();
                              } else {
                                Toast.show("please try again", context,
                                    duration: Toast.LENGTH_SHORT,
                                    gravity: Toast.BOTTOM);
                              }
                            },
                            title: Text(
                              snapshot.data[index]['nameOfCollection'] == null
                                  ? ''
                                  : snapshot.data[index]['nameOfCollection'],
                              style:
                                  TextStyle(color: Colors.black54, fontSize: 16),
                            ),
                            subtitle: Text(
                              snapshot.data[index]['countOfCategory'] == null
                                  ? '1'
                                  : snapshot.data[index]['countOfCategory']
                                      .toString(),
                              style:
                                  TextStyle(color: Colors.black54, fontSize: 14),
                            ),
                            leading: FadeInImage.assetNetwork(
                                placeholder: 'images/placeholder.png',
                                image: snapshot.data[index]['categoryImage'] ==
                                        null
                                    ? 'https://devblog.axway.com/wp-content/uploads/blog-572x320-image-device.png'
                                    : snapshot.data[index]['categoryImage'],
                                width: 70,
                                height: 80,
                                fit: BoxFit.fill),
                            trailing: InkWell(
                              child: Text(
                                'Remove',
                                style: TextStyle(fontSize: 15, color: Colors.red),
                              ),
                              onTap: () async {
                                bool x = await Provider.of<Categorys>(context,
                                        listen: false)
                                    .removeCollection(
                                        collectionName: snapshot.data[index]
                                            ['nameOfCollection']);
                                if (x == true) {
                                  Toast.show("Successfully removed", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                  Navigator.of(context).pop();
                                } else {
                                  Toast.show("please try again", context,
                                      duration: Toast.LENGTH_SHORT,
                                      gravity: Toast.BOTTOM);
                                }
                              },
                            ),
                            isThreeLine: false,
                          ),
                        ),
                      );
                    }
                  }
                }
              }),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'New Collection',
                style: TextStyle(color: Color(0xffc62828), fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (context) => NewCollection(
                          category: loadedProduct,
                        ));
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final _textStyle = Theme.of(context).textTheme.title;


    Divider _divider() {
      return Divider(
        color: Colors.grey[400],
        thickness: 1.0,
        height: 1,
      );
    }

  Widget createComment({Review review, int index}) {
    return Padding(
      padding: const EdgeInsets.only(bottom:10),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            if(review.userId == userId){
              Provider.of<ChangeIndex>(context,listen: false).changeIndexFunction(4);
              Navigator.of(context).pop();
            }else{
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FriendPage(friendId: review.userId,)));
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(left: 4.0, bottom: 1.0),
                leading: CircleAvatar(

                    radius: 25.0,
                    child: ClipOval(
                        child: review.userImgUrl == null
                            ? Image.asset(
                                'images/user.png',
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              )
                            : FadeInImage.assetNetwork(
                                placeholder: 'images/meScreenIcons/userPlaceholder.png',
                                image: review.userImgUrl,
                                    //                fit: BoxFit.fill,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                                fadeInCurve: Curves.bounceIn,
                              ))),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      child: Text(
                        review.userName == null ? '' : review.userName,
                        style: TextStyle(color: Colors.black, fontSize: _width*0.03,fontWeight: FontWeight.w600),
                      ),
                      width: _width*0.3,
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            child: Text(
                        DateFormat('dd/MM/yyyy hh:mm')
                              .format(DateTime.parse(review.date)),
                        style: TextStyle(
                            fontSize: _width*0.02,
                            color: Colors.grey,
                        )
                        ),
                            width: _width*0.1,
                          ),
                    review.userId == userId
                        ? PopupMenuButton<String>(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey,
                              size: 18,
                            ),
                            itemBuilder: (context) => ['Edit', 'Delete']
                                .map((String val) => PopupMenuItem<String>(
                                      child: Text(val),
                                      value: val,
                                    ))
                                .toList(),
                            onSelected: (String val) {
                              if (val == 'Edit') {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => StartReview(
                                              category: loadedProduct,
                                              review: review,
                                            )))
                                    .then((x) {
                                  x == null || x == false
                                      ? result = false
                                      : result = true;
                                });
                              }
                              if (val == 'Delete') {
                                Provider.of<Categorys>(context, listen: false)
                                    .deleteAReview(
                                  resturant: loadedProduct,
                                  review: review,
                                )
                                    .then((x) {
                                  if (x == 'true') {
                                    Toast.show("successfully deleted!", context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                    _onRefresh();
                                  } else if (x == 'false') {
                                    Toast.show("failed to delete!", context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  }
                                });
                              }
                            }
                            )
                        : SizedBox(),
                        ],
                      )
                    )
                                //            SizedBox(
                                //              width: 6,
                                //            ),
                                //            Container(
                                //              color: Colors.red,
                                //              padding: EdgeInsets.all(3.0),
                                //              child: Text(
                                //                'Elite \'29',
                                //                style: TextStyle(
                                //                    fontSize: 12,
                                //                    color: Colors.white),
                                //              ),
                                //            )
                  ],
                ),
                subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            _iconWithTitle(
                                icon: ImageIcon(
                                    AssetImage('images/meScreenIcons/friends.png'),
                                    size: 18),
                                title: review.friendsCount),
                            _iconWithTitle(
                                icon: ImageIcon(
                                    AssetImage(
                                        'images/meScreenIcons/addReview.png'),
                                    color: Colors.grey[700],
                                    size: 18),
                                title: review.userRating),
                            _iconWithTitle(
                                icon: ImageIcon(
                                  AssetImage('images/meScreenIcons/photo.png'),
                                  color: Colors.grey[700],
                                  size: 18,
                                ),
                                title: review.userPhoto),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            review.rating == 0.0
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.25,
                                  )
                                : RatingBar(
                                    initialRating: review.rating,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 1.0),
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
                                    itemSize: 20,
                                    ignoreGestures: true,
                                    onRatingUpdate: (double value) {},
                                  ),
                          ],
                        ),
                      ],
                    )),
              ),
              // Row(
              //   // mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     review.rating == 0.0?SizedBox(width: MediaQuery.of(context).size.width*0.25,):RatingBar(
              //       initialRating: review.rating,
              //       direction: Axis.horizontal,
              //       allowHalfRating: true,
              //       itemCount: 5,
              //       itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
              //       itemBuilder: (context, _) => Icon(
              //         Icons.stars,
              //         color: Color(0xffc62828),
              //       ),
              //       unratedColor: Colors.grey,
              //       itemSize: 22,
              //       ignoreGestures: true,
              //       onRatingUpdate: (double value) {},
              //     ),

              //   ],
              // ),
              SizedBox(
                height: 5,
              ),
              review.imgUrlForReview.isEmpty
                  ? SizedBox()
                  : FadeInImage.assetNetwork(
                      placeholder: 'images/placeholder.png',
                      image: review.imgUrlForReview,
                       //                 fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                      fadeInCurve: Curves.bounceIn,
                    ),
              review.comment == 'null' || review.comment.isEmpty
                  ? SizedBox()
                  : Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(review.comment,
                                maxLines: descTextShowFlag ? 8 : 2,
                                textAlign: TextAlign.start,
                                style:
                                    TextStyle(color: Colors.black54, fontSize: 15)),
                            review.comment.length > 80
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        descTextShowFlag = !descTextShowFlag;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        descTextShowFlag
                                            ? Text(
                                                "Show Less",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16),
                                              )
                                            : Text("Show More",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16))
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _iconWithTitleAndNumbers(
                        icon: ImageIcon(
                            AssetImage('images/meScreenIcons/useful.png'),
                            color: review.isUseful ? Colors.red : Colors.black54,
                            size: 19),
                        title: 'Useful',
                        number: review.useful,
                        function: () async{
                          await Provider.of<Categorys>(context, listen: false)
                              .updateTransactionsForCategory(
                                  review: review,
                                  type: 'useful',
                                  category: loadedProduct);
                        },
                        isColorChange: review.isUseful),
                    _iconWithTitleAndNumbers(
                        icon: ImageIcon(
                            AssetImage('images/meScreenIcons/happy.png'),
                            color: review.isFunny ? Colors.red : Colors.black54,
                            size: 20),
                        title: 'Funny',
                        number: review.funny,
                        function: () async{
                          await Provider.of<Categorys>(context, listen: false)
                              .updateTransactionsForCategory(
                                  review: review,
                                  type: 'funny',
                                  category: loadedProduct);
                        },
                        isColorChange: review.isFunny),
                    _iconWithTitleAndNumbers(
                        icon: ImageIcon(AssetImage('images/meScreenIcons/cool.png'),
                            color: review.isColl ? Colors.red : Colors.black54,
                            size: 20),
                        title: 'Cool',
                        number: review.cool,
                        function: () async{
                          await Provider.of<Categorys>(context, listen: false)
                              .updateTransactionsForCategory(
                                  review: review,
                                  type: 'cool',
                                  category: loadedProduct);
                        },
                        isColorChange: review.isColl),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top:15,bottom:15,right:8,left:8),
              //   child: _divider(),
              // )
            ],
          ),
        ),
      ),
    );
  }    
    if (result) {
      _getReview = Provider.of<Categorys>(context, listen: false)
          .getAllReviews(category: loadedProduct);
      result = false;
    }
    Future<void> _getImage(ImageSource source) async {
      File imageFile;
      await ImagePicker.pickImage(source: source, maxWidth: 400.0)
          .then((File image) {
        imageFile = image;
        Navigator.pop(context);
      });
      if(imageFile != null){
        if(loadedProduct.ownerId!=null &&loadedProduct.ownerId == userId){
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              title: Text(
                'Add image as',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color:  Color(0xffc62828)
                ),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      color: Color(0xffc62828),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text('Owner',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: () async{
                        setState(() {
                          _isloadingPhoto = true;
                          Navigator.of(context).pop();
                        });
                        try{
                          await Provider.of<Categorys>(context, listen: false)
                              .addPhoto(type: 'owner',resturant: loadedProduct, imageFile: imageFile);
                          Toast.show( "Successfully added",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                        }catch(e){
                          Toast.show( "Failed Please try again",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                        }
                        setState(() {
                          _isloadingPhoto = false;
                        });
                      },
                    ),
                    FlatButton(
                      color: Color(0xffc62828),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),

                      child: Text(
                        'User',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async{
                        setState(() {
                          _isloadingPhoto = true;
                        });
                        try{
                          await Provider.of<Categorys>(context, listen: false)
                              .addPhoto(resturant: loadedProduct, imageFile: imageFile);
                          Toast.show( "Successfully added",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                        }catch(e){
                          Toast.show( "Failed Please try again",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                        }
                        Navigator.of(context).pop();
                        setState(() {
                          _isloadingPhoto = false;
                        });
                      },
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xffc62828), fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        }else{
          setState(() {
            _isloadingPhoto = true;
          });
          try{
            await Provider.of<Categorys>(context, listen: false)
                .addPhoto(resturant: loadedProduct, imageFile: imageFile);
            Toast.show( "Successfully added",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          }catch(e){
            Toast.show( "Failed Please try again",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          }
          setState(() {
            _isloadingPhoto = false;
          });
        }
      }
    }

    void _openImagePicker() {
      showModalBottomSheet(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 120.0,
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
                Text(
                  'Pick an Image',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.red),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton.icon(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.blue,
                      textColor: Theme.of(context).primaryColor,
                      label: Text(
                        'Use Camera',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _getImage(ImageSource.camera);
                        // Navigator.of(context).pop();
                      },
                    ),
                    FlatButton.icon(
                      icon: Icon(
                        Icons.camera,
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.blue,
                      textColor: Theme.of(context).primaryColor,
                      label: Text(
                        'Use Gallery',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _getImage(ImageSource.gallery);
                        // Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                
              ]),
            );
          });
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          RefreshIndicator(
            onRefresh: _onRefresh,
            color: Colors.red,
            backgroundColor: Colors.white,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  title: _showTitle
                      ? Text(
                          loadedProduct.name,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      : null,
                  pinned: true,
                  leading: BackButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.white, // Here
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Share.share(
                            'check out ${loadedProduct.name} on Check And Chat App');
                      },
                    ),
                    PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      itemBuilder: (context) =>
                          ['Call', 'Add To Collection', 'Add photo', 'Check In']
                              .map((String val) => PopupMenuItem<String>(
                                    child: Text(val),
                                    value: val,
                                  ))
                              .toList(),
                      onSelected: (String val) {
                        if (val == 'Call') {
                          if (loadedProduct.phone.isNotEmpty) {
                            launch("tel:${loadedProduct.phone}");
                          } else {
                            Toast.show("Sorry mobile not avilable", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM);
                          }
                        }
                        if (val == 'Add To Collection') {
                          _addToCollection();
                        }
                        if (val == 'Add photo') {
                          _openImagePicker();
                        }
                        if (val == 'Check In') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CheckIn(
                                    resturant: loadedProduct,
                                  )));
                        }
                      },
                    )
                  ],
                  expandedHeight: 300.0,
                  backgroundColor: Color(0xffc62828),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(fit: StackFit.expand, children: <Widget>[
                      loadedProduct.imgUrl.isEmpty
                          ? Container(
                              color: Colors.black45,
                            )
                          : Carousel(
                              images: [NetworkImage(loadedProduct.imgUrl[0])],
                              onImageTap: (int imgIndex) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ShowItemPhotos(
                                          category: loadedProduct,
                                      userId: userId,
                                        )));
                              },
                              autoplay: true,
                              boxFit: BoxFit.fill,
                              showIndicator: false,
                            ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: _width * 0.70,
                                child: Text(
                                  loadedProduct.name,
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 2,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  RatingBar(
                                    initialRating: loadedProduct.rating,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 1.0),
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
                                              //                                Text(
                                              //                                  ' 14',
                                              //                                  style: _textStyle.copyWith(
                                              //                                    fontSize: 16,
                                              //                                    color: Colors.white,
                                              //                                  ),
                                              //                                ),
                                  Spacer(),
                                  RaisedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShowItemPhotos(
                                                    category: loadedProduct,
                                                    userId: userId,
                                                  )));
                                    },
                                    color: Colors.white,
                                    child: Text(
                                      'See All',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 18.0),
                        child: InkWell(
                          onTap: () {
                            if (loadedProduct.phone.isNotEmpty) {
                              launch("tel:${loadedProduct.phone}");
                            } else {
                              Toast.show("Sorry mobile not avilable", context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.BOTTOM);
                            }
                          },
                          child: Material(
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                          //                                    Text(
                                          //                                      'Today is a holiday',
                                          //                                      style: _textStyle.copyWith(
                                          //                                          fontSize: 19, color: Colors.black),
                                          //                                    ),
                                      Text(
                                        'Tap here to call',
                                        style:
                                            _textStyle.copyWith(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.call,
                                        color: Color(0xffc62828),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            type: MaterialType.card,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Material(
                          type: MaterialType.card,
                          color: Colors.grey[200],
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () async {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                                  //                          loadedProduct.id
                                        builder: (context) => StartReview(
                                              category: loadedProduct,

                                            )))
                                    .then((x) {
                                  x == null || x == false
                                      ? result = false
                                      : result = true;
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Start a review...',
                                        style: _textStyle.copyWith(
                                            color: Colors.black),
                                      ),
                                      RatingBar(
                                        initialRating: 3,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 1.0),
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
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: _divider(),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      _isloadingPhoto
                                          ? CircularProgressIndicator(
                                              backgroundColor: Color(0xffc62828),
                                            )
                                          : _createIconWithText(
                                              icon: ImageIcon(
                                                  AssetImage(
                                                      'images/meScreenIcons/addPhoto.png'),
                                                  color: Colors.grey[600]),
                                              title: 'Add photo',
                                              function: () {
                                                _openImagePicker();
                                              }),
                                      _createIconWithText(
                                          icon: ImageIcon(AssetImage(
                                              'images/meScreenIcons/checkin.png')),
                                          title: 'Check In',
                                          function: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CheckIn(
                                                          resturant:
                                                              loadedProduct,
                                                        )));
                                          }),
                                      _createIconWithText(
                                          icon: ImageIcon(
                                            AssetImage(
                                                'images/NavBar/bookmark-filled.png'),
                                            color: Colors.grey[600],
                                          ),
                                          title: 'Save',
                                          function: _addToCollection),
                                    ],
                                  ),
                                      //                                Padding(
                                      //                                  padding: const EdgeInsets.all(8.0),
                                      //                                  child: SizedBox(
                                      //                                    height: 40,
                                      //                                    width: _width,
                                      //                                    child: ListView.builder(
                                      //                                        scrollDirection: Axis.horizontal,
                                      //                                        itemCount: _listOfReviewType.length,
                                      //                                        itemBuilder: (context, index) =>
                                      //                                            InkWell(
                                      //                                              onTap: () =>
                                      //                                                  _isReviewTypeIsClicked(
                                      //                                                      index: index),
                                      //                                              child: Container(
                                      //                                                child: Center(
                                      //                                                  child: Text(
                                      //                                                    _listOfReviewType[index],
                                      //                                                    style: TextStyle(
                                      //                                                        color:
                                      //                                                            _reviewTypeIsClicked[
                                      //                                                                    index]
                                      //                                                                ? Colors.blue
                                      //                                                                : Colors.grey,
                                      //                                                        fontSize: 16),
                                      //                                                  ),
                                      //                                                ),
                                      //                                                decoration: BoxDecoration(
                                      //                                                    borderRadius:
                                      //                                                        BorderRadius.all(
                                      //                                                            Radius.circular(
                                      //                                                                10.0)),
                                      //                                                    border: Border.all(
                                      //                                                        color:
                                      //                                                            _reviewTypeIsClicked[
                                      //                                                                    index]
                                      //                                                                ? Colors.blue
                                      //                                                                : Colors.grey)),
                                      //                                                margin:
                                      //                                                    EdgeInsets.only(right: 10),
                                      //                                                padding: EdgeInsets.all(5.0),
                                      //                                              ),
                                      //                                            )),
                                      //                                  ),
                                      //                                )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                                          //                    Padding(
                                          //                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          //                      child: Material(
                                          //                        type: MaterialType.card,
                                          //                        color: Colors.grey[200],
                                          //                        borderOnForeground: true,
                                          //                        shape: RoundedRectangleBorder(
                                          //                            borderRadius:
                                          //                                BorderRadius.all(Radius.circular(4.0))),
                                          //                        child: Padding(
                                          //                          padding: const EdgeInsets.all(8.0),
                                          //                          child: Column(
                                          //                            crossAxisAlignment: CrossAxisAlignment.start,
                                          //                            mainAxisAlignment: MainAxisAlignment.start,
                                          //                            children: <Widget>[
                                          //                              Padding(
                                          //                                padding: const EdgeInsets.symmetric(
                                          //                                    vertical: 8.0, horizontal: 8.0),
                                          //                                child: Text(
                                          //                                  'Popular Dishes',
                                          //                                  style: _textStyle.copyWith(
                                          //                                      color: Colors.black, fontSize: 20),
                                          //                                ),
                                          //                              ),
                                          //                              SizedBox(
                                          //                                width: _width,
                                          //                                height: _height * 0.30,
                                          //                                child: ListView.builder(
                                          //                                    itemCount: imgList.length + 1,
                                          //                                    scrollDirection: Axis.horizontal,
                                          //                                    itemBuilder: (context, index) => Padding(
                                          //                                          padding: const EdgeInsets.all(8.0),
                                          //                                          child: _popularDishes(index: index),
                                          //                                        )),
                                          //                              ),
                                          //                            ],
                                          //                          ),
                                          //                        ),
                                          //                      ),
                                          //                    ),
                                          //                    Padding(
                                          //                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                          //                      child: Column(
                                          //                        crossAxisAlignment: CrossAxisAlignment.start,
                                          //                        mainAxisAlignment: MainAxisAlignment.start,
                                          //                        children: <Widget>[
                                          //                          SizedBox(
                                          //                            width: _width,
                                          //                            height: _height * 0.30,
                                          //                            child: Image.network(
                                          //                              imgList[0],
                                          //                              fit: BoxFit.fill,
                                          //                            ),
                                          //                          ),
                                          ////                          Padding(
                                          ////                            padding: const EdgeInsets.symmetric(
                                          ////                                vertical: 15.0, horizontal: 8.0),
                                          ////                            child: Row(
                                          ////                              crossAxisAlignment: CrossAxisAlignment.start,
                                          ////                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          ////                              children: <Widget>[
                                          ////                                Text(
                                          ////                                  'Get Directions',
                                          ////                                  style: _textStyle.copyWith(
                                          ////                                      color: Colors.black, fontSize: 18),
                                          ////                                ),
                                          ////                                Icon(
                                          ////                                  Icons.directions,
                                          ////                                )
                                          ////                              ],
                                          ////                            ),
                                          ////                          ),
                                          //                        ],
                                          //                      ),
                                          //                    ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Material(
                          type: MaterialType.card,
                          color: Colors.grey[200],
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  child: Text(
                                    'Business Info',
                                    style: _textStyle.copyWith(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                                loadedProduct.openNow == 'none'
                                    ? SizedBox()
                                    : _listTile(
                                        icon: Icons.info,
                                        title: loadedProduct.openNow == 'true'
                                            ? 'Open Now'
                                            : 'Closed Now',
                                        function: () {}),
                                type == ''
                                    ? SizedBox()
                                    : _listTile(
                                        title: 'Type of Service',
                                        subtitle: type,
                                        icon: Icons.room_service,
                                        function: () {},
                                      ),
                                _priceLevel == ''
                                    ? SizedBox()
                                    : _listTile(
                                        title: 'Price level',
                                        subtitle: _priceLevel,
                                        icon: Icons.monetization_on,
                                        function: () {},
                                      ),
                                _listTile(
                                  subtitle: loadedProduct.phone,
                                  title:
                                      'Call ${loadedProduct.phone.isNotEmpty ? loadedProduct.phone : ''}',
                                  icon: Icons.call,
                                  function: () {
                                    if (loadedProduct.phone.isNotEmpty) {
                                      launch("tel:${loadedProduct.phone}");
                                    } else {
                                      Toast.show(
                                          "Sorry mobile not avilable", context,
                                          duration: Toast.LENGTH_SHORT,
                                          gravity: Toast.BOTTOM);
                                    }
                                  },
                                ),
                                _listTile(
                                    title: 'Location',
                                    subtitle: loadedProduct.vicinity,
                                    icon: Icons.location_on,
                                    function: () {
                                      print('vbcb');
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => ShowSpecificPlaceOnMap(category: loadedProduct,)));
                                    }),
                                loadedProduct.distance == 0.0
                                    ? SizedBox()
                                    : _listTile(
                                        title: 'Distance Between you',
                                        subtitle:
                                            '${loadedProduct.distance.toStringAsFixed(4)} km',
                                        icon: Icons.directions),
                                // _listTile(
                                //     title: 'Explore the Menu',
                                //     subtitle: 'Basil Crepe,Cole Valley Crepe',
                                //     icon: Icons.restaurant,
                                //     function: () {
                                //       Navigator.of(context).push(
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   ShowItemPhotos(tabIndex: 4)));
                                //     }),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: RaisedButton(
                                //     onPressed: () {
                                //       Navigator.of(context).push(
                                //           MaterialPageRoute(
                                //               builder: (context) => MoreInfo()));
                                //     },
                                //     child: Center(
                                //       child: Text(
                                //         'More info',
                                //         style: TextStyle(
                                //             color: Colors.white, fontSize: 18),
                                //       ),
                                //     ),
                                //     shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(8.0))),
                                //     color: Colors.red,
                                //     padding: EdgeInsets.all(10.0),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                                          //                    Padding(
                                          //                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          //                      child: Material(
                                          //                        type: MaterialType.card,
                                          //                        color: Colors.grey[200],
                                          //                        borderOnForeground: true,
                                          //                        shape: RoundedRectangleBorder(
                                          //                            borderRadius:
                                          //                                BorderRadius.all(Radius.circular(10.0))),
                                          //                        child: Padding(
                                          //                          padding: const EdgeInsets.all(8.0),
                                          //                          child: Column(
                                          //                            crossAxisAlignment: CrossAxisAlignment.start,
                                          //                            mainAxisAlignment: MainAxisAlignment.start,
                                          //                            children: <Widget>[
                                          //                              Padding(
                                          //                                padding: const EdgeInsets.symmetric(
                                          //                                    vertical: 8.0, horizontal: 8.0),
                                          //                                child: Text(
                                          //                                  'Photos and Videos',
                                          //                                  style: _textStyle.copyWith(
                                          //                                      color: Colors.black, fontSize: 20),
                                          //                                ),
                                          //                              ),
                                          //                              SizedBox(
                                          //                                width: _width,
                                          //                                height: _height * 0.30,
                                          //                                child: ListView.builder(
                                          //                                    itemCount: imgList.length,
                                          //                                    scrollDirection: Axis.horizontal,
                                          //                                    itemBuilder: (context, index) => InkWell(
                                          //                                          onTap: () {
                                          //                                            Navigator.of(context).push(
                                          //                                                MaterialPageRoute(
                                          //                                                    builder: (context) =>
                                          //                                                        ShowItemPhotos(
                                          //                                                            tabIndex: 1)));
                                          //                                          },
                                          //                                          child: Padding(
                                          //                                            padding: const EdgeInsets.all(8.0),
                                          //                                            child: Stack(
                                          //                                              children: <Widget>[
                                          //                                                ClipRRect(
                                          //                                                  child: Image.network(
                                          //                                                    imgList[index],
                                          //                                                    width: _width * 0.44,
                                          //                                                    height: _height * 0.20,
                                          //                                                    fit: BoxFit.fill,
                                          //                                                  ),
                                          //                                                  borderRadius:
                                          //                                                      BorderRadius.all(
                                          //                                                          Radius.circular(5.0)),
                                          //                                                ),
                                          //                                                Positioned(
                                          //                                                    child: Column(
                                          //                                                      mainAxisAlignment:
                                          //                                                          MainAxisAlignment
                                          //                                                              .start,
                                          //                                                      crossAxisAlignment:
                                          //                                                          CrossAxisAlignment
                                          //                                                              .start,
                                          //                                                      children: <Widget>[
                                          //                                                        Text(
                                          //                                                          'Food',
                                          //                                                          style: _textStyle
                                          //                                                              .copyWith(
                                          //                                                                  color: Colors
                                          //                                                                      .white,
                                          //                                                                  fontSize: 18),
                                          //                                                        ),
                                          //                                                        Text(
                                          //                                                          '228 Photos',
                                          //                                                          style: _textStyle
                                          //                                                              .copyWith(
                                          //                                                                  color: Colors
                                          //                                                                      .white,
                                          //                                                                  fontSize: 12),
                                          //                                                        ),
                                          //                                                      ],
                                          //                                                    ),
                                          //                                                    bottom: 10.0,
                                          //                                                    left: 10.0,
                                          //                                                    right: 0.0)
                                          //                                              ],
                                          //                                            ),
                                          //                                          ),
                                          //                                        )),
                                          //                              ),
                                          //                            ],
                                          //                          ),
                                          //                        ),
                                          //                      ),
                                          //                    ),
                      FutureBuilder(
                          future: _getReview,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.65,
                                  width: 70,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    backgroundColor: Color(0xffc62828),
                                  )));
                            } else {
                              if (snapshot.error != null) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.65,
                                  child: Center(
                                    child: Text('An error occurred!'),
                                  ),
                                );
                              } else {
                                if (snapshot.data == 0) {
                                  return SizedBox();
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8.0),
                                    child: Material(
                                      type: MaterialType.card,
                                      color: Colors.transparent,
                                      borderOnForeground: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            Consumer<Categorys>(
                                              builder: (ctx, reviewData, _) =>
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: reviewData
                                                          .allReviews.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return createComment(
                                                            index: index,
                                                            review: reviewData
                                                                    .allReviews[
                                                                index]);
                                                      }),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          }),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
//          Positioned(
//            child: Container(
//              color: Colors.white,
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  children: <Widget>[
//                    _bottomNavigationbar(
//                        name: 'NearBy', imgUrl: 'images/NavBar/nearby.png'),
//                    Consumer<ChangeIndex>(
//                        builder: (context, changeIndex, _) => InkWell(
//                              onTap: () {
//                                setState(() {
//                                  _mapOfBottomNavigationbar['Search'] =
//                                      !_mapOfBottomNavigationbar['Search'];
//                                });
//                                changeIndex.changeIndexFunction(1);
//                                Navigator.pushReplacementNamed(
//                                    context, 'NearBy');
//                              },
//                              child: Column(
//                                children: <Widget>[
//                                  Icon(
//                                    Icons.search,
//                                    size: _width * 0.06,
//                                    color: _mapOfBottomNavigationbar['Search']
//                                        ? Colors.red
//                                        : Colors.grey,
//                                  ),
//                                  Text('Search',
//                                      style: TextStyle(
//                                        fontSize: _width * 0.03,
//                                        color:
//                                            _mapOfBottomNavigationbar['Search']
//                                                ? Colors.red
//                                                : Colors.grey,
//                                      )),
//                                ],
//                              ),
//                            )),
//                    _bottomNavigationbar(
//                        name: 'Me', imgUrl: 'images/NavBar/me.png'),
//                    _bottomNavigationbar(
//                        name: 'Activities',
//                        imgUrl: 'images/NavBar/activity.png'),
//                    _bottomNavigationbar(
//                        name: 'Collections',
//                        imgUrl: 'images/NavBar/bookmark.png'),
//                  ],
//                ),
//              ),
//            ),
//            bottom: 0.0,
//            left: 0.0,
//            right: 0.0,
//          )
        ],
      ),
    );
  }
}