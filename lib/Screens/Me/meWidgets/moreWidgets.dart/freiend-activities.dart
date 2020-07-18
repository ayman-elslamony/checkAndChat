import 'package:checkandchat/Providers/resturants.dart';
import 'package:checkandchat/Screens/Search/searchWidgets/item_details/item_details.dart';
import 'package:checkandchat/models/activities_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FriendActivitiesScreen extends StatefulWidget {
  String friendId;

  FriendActivitiesScreen({this.friendId});

  @override
  _FriendActivitiesScreenState createState() => _FriendActivitiesScreenState();
}

class _FriendActivitiesScreenState extends State<FriendActivitiesScreen> {

  Future<void> _allActivities;
  bool refresh = true;
  _refreshToGetUserData() {
    if (refresh) {
      _allActivities =
          Provider.of<Categorys>(context, listen: false).getAllActivities(id: widget.friendId);
      refresh = false;
    }
  }
  @override
  void initState() {
    _refreshToGetUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

//  Widget _createImage() {
//    return Padding(
//      padding: const EdgeInsets.only(right: 6.0),
//      child: ClipRRect(
//        clipBehavior: Clip.antiAlias,
//        borderRadius: BorderRadius.circular(6),
//        child: Image.network(
//          'https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimg1.southernliving.timeinc.net%2Fsites%2Fdefault%2Ffiles%2Fstyles%2Fmedium_2x%2Fpublic%2Fimage%2F2018%2F03%2Fmain%2F2565101_qfs5w152.jpg%3Fitok%3DtrTAesv9',
//          width: 90,
//          height: 85,
//          fit: BoxFit.fill,
//        ),
//      ),
//    );
//  }
//
//
//
//  Widget _createResultCard() {
//    return InkWell(
//      onTap: (){
//          Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemDetails()));
//        },
//              child: Padding(
//          padding: const EdgeInsets.only(top: 14.0),
//          child: Container(
//            decoration: BoxDecoration(
//              borderRadius: BorderRadius.circular(15),
//              color:Colors.grey[200],
//            ),
//            width: _width,
//            child: Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Row(
//                    children: <Widget>[
//                      Text(
//                        '1. Panera Bread',
//                        style: _textStyle.copyWith(fontSize:  _width*0.05,color: Colors.black87),
//                      ),
//                      Spacer(),
//                      Text(
//                        '1.9 mi',
//                        style: _textStyle.copyWith(fontSize:  _width*0.04),
//                      )
//                    ],
//                  ),
//                  Padding(padding: EdgeInsets.all(2)),
//                  Row(
//                    children: <Widget>[
//                      RatingBar(
//                        initialRating: 3,
//                        direction: Axis.horizontal,
//                        allowHalfRating: true,
//                        itemCount: 5,
//                        itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
//                        itemBuilder: (context, _) => Icon(
//                          Icons.stars,
//                          color: Colors.red,
//                        ),
//                        unratedColor: Colors.grey,
//                        itemSize: 22,
//                        ignoreGestures: true, onRatingUpdate: (double value) {},
//                      ),
//                      Padding(
//                        padding: EdgeInsets.all(8),
//                      ),
//                      Text(
//                        '14 Reviews',
//                        style: _textStyle.copyWith(fontSize:  _width*0.035,fontWeight: FontWeight.w500),
//                      )
//                    ],
//                  ),
//
//                  SingleChildScrollView(
//                    scrollDirection: Axis.horizontal,
//                    child: Padding(
//                      padding: const EdgeInsets.symmetric(vertical: 10.0),
//                      child: Row(
//                        children: <Widget>[
//                          _createImage(),
//                          Padding(
//                            padding: const EdgeInsets.only(right: 6.0),
//                            child: ClipRRect(
//                              clipBehavior: Clip.antiAlias,
//                              borderRadius: BorderRadius.circular(6),
//                              child: Image.asset(
//                                'images/meals.jpg',
//                                width: 90,
//                                height: 85,
//                                fit: BoxFit.cover,
//                              ),
//                            ),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.only(right: 6.0),
//                            child: ClipRRect(
//                              clipBehavior: Clip.antiAlias,
//                              borderRadius: BorderRadius.circular(6),
//                              child: Image.asset(
//                                'images/meal.jpg',
//                                width: 90,
//                                height: 85,
//                                fit: BoxFit.cover,
//                              ),
//                            ),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.only(right: 6.0),
//                            child: ClipRRect(
//                              clipBehavior: Clip.antiAlias,
//                              borderRadius: BorderRadius.circular(6),
//                              child: Image.asset(
//                                'images/meal2.jpg',
//                                width: 90,
//                                height: 85,
//                                fit: BoxFit.cover,
//                              ),
//                            ),
//                          ),
//                          _createImage(),
//                        ],
//                      ),
//                    ),
//                  ),
//
//                  SizedBox(height: 10,)
//                ],
//              ),
//            ),
//          ),
//        ),
//      );
//    }
//
//  Divider _divider() {
//    return Divider(
//      color: Colors.grey,
//      thickness: 1.0,
//      height: 1,
//    );
//  }
//  Widget _addActivity(){
//    return Container(
//      height: 300,
//      width: _width,
//      child: Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Column(
//          children: <Widget>[
//            Text('Your Friend Ahmed Magdy added a review to this..',style: TextStyle(color:Colors.grey[700],fontSize: _width*0.045),),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: _createResultCard(),
//            ),
//            _divider()
//          ],
//
//        ),
//      ),
//    );
//
//
//  }
    Widget myActivite({Activities activites}) {
      return ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetails(
                    isCommingFromCollection: true,
                    category: activites.category,
                  )));
        },
        title: Text(
          '${activites.userName} added ${activites.type} in ${activites.category.name}',
          style: TextStyle(color: Colors.grey[700], fontSize: _width * 0.04),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
              DateFormat('dd/MM/yyyy hh:mm')
                  .format(DateTime.parse(activites.dateForReview)),
              style: TextStyle(
                fontSize: _width * 0.032,
                color: Colors.grey,
              )),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.of(context).canPop()?BackButton(
          color: Colors.white,
          onPressed: (){Navigator.of(context).pop();},
        ):null,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Activites',
                style: TextStyle(color: Colors.white, fontSize: _width * 0.045),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xffc62828),
      ),
      body: ListView(
        children: <Widget>[
          RefreshIndicator(
            backgroundColor: Colors.white,
            color: Color(0xffc62828),
            onRefresh: () async {
              setState(() {
                refresh = true;
              });
              _refreshToGetUserData();
            },
            child: FutureBuilder(
                future:  _allActivities,
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        height: _height,
                        width: _width,
                        child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Color(0xffc62828),
                            )));
                  } else {
                    if (dataSnapshot.error != null) {
                      return Center(
                        child: Text('An error occurred!'),
                      );
                    } else {
                      return Consumer<Categorys>(
                        builder: (context, dataSnapshot, _) {
                          return Column(
                            children: <Widget>[
                              SizedBox(
                                height: _height,
                                child: dataSnapshot.allActivities.length == 0
                                    ? Center(
                                    child: Text(
                                      'there no any Activities yet',
                                      style: TextStyle(
                                          color: Color(0xffc62828),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ))
                                    : ListView.builder(
                                  itemCount:
                                  dataSnapshot.allActivities.length,
                                  itemBuilder: (context, index) =>
                                      myActivite(
                                          activites: dataSnapshot
                                              .allActivities[index]),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }
}