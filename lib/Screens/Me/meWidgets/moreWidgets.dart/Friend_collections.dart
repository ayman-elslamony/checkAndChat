import 'package:checkandchat/Providers/resturants.dart';
import 'package:checkandchat/Screens/Collections/content_of_each_collection/content_of_each_collection.dart';
import 'package:checkandchat/models/collection_for_friends.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FriendsCollections extends StatefulWidget {
  String friendId;
  String userName;

  FriendsCollections({this.friendId, this.userName});

  @override
  _FriendsCollectionsState createState() => _FriendsCollectionsState();
}

class _FriendsCollectionsState extends State<FriendsCollections> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    Widget _createCollectionCard(
        {String collectionId,Widget image, String name, Function function, int count,String friendId,String imgUrlForCollection,
        bool isMeFollowing,
         String lastUpdate}) {
      return InkWell(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(_width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: image,
                    ),
                    Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          color: Colors.black54,
                          child: ListTile(
                            isThreeLine: false,
                            title: Text(
                              '${toBeginningOfSentenceCase(name)}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            leading: Text(
                              '+ ${count.toString()}',
                              style: TextStyle(
                                  color: Color(0xffc62828), fontSize: 16),
                            ),
                            trailing: RaisedButton(
                              onPressed: () async{
                                if(isMeFollowing){
                                  await Provider.of<Categorys>(context,listen: false).deleteFromFollowingCollections(
                                    collectionId: collectionId,
                                  );
                                }else{
                                 await Provider.of<Categorys>(context,listen: false).addToFollowingCollections(
                                    friendId: friendId,
                                    collectionId: collectionId,
                                  );
                                }

                              },
                              color: Colors.white30,
                              child: Text(
                                isMeFollowing?'UnFollow':'Follow',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.only(bottom: _width * 0.02),
//                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Text(
//                              name,
//                              style: TextStyle(
//                                  color: Colors.grey[850],
//                                  fontSize: _width * 0.045),
//                            ),
//                          ],
//                        ),
//                      ),
////                      Padding(
////                        padding: EdgeInsets.only(bottom: _width * 0.02),
////                        child: Text(
////                          'there are the most rated places to eat in 2020',
////                          style: TextStyle(
////                              color: Colors.grey[600], fontSize: _width * 0.03),
////                        ),
////                      ),
//                    ],
//                  ),
//                )
              ],
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

    Future<List<CollectionForFriend>> _refreshToGetAllCollections() async {
      return Provider.of<Categorys>(context, listen: false)
          .getAllCollectionsForFriend(userId: widget.friendId);
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              Text(
                '${widget.userName}\'s Collections',
                style: TextStyle(color: Colors.white, fontSize: _width * 0.045),
              ),
            ],
          ),
          backgroundColor: Color(0xffc62828),
        ),
        body: RefreshIndicator(
          color: Colors.red,
          backgroundColor: Colors.white,
          onRefresh: _refreshToGetAllCollections,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: _height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 20, top: 20),
                child: Text(
                  '${widget.userName}\'s Collections',
                  style: TextStyle(
                      fontSize: _width * 0.05, color: Colors.grey[700]),
                ),
              ),
              FutureBuilder(
                  future: _refreshToGetAllCollections(),
                  builder: (context, dataSnapshot) {
                    if (dataSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                          height: _height,
                          width: _width,
                          child: Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          )));
                    } else {
                      if (dataSnapshot.error != null) {
                        return Center(
                          child: Text('An error occurred!'),
                        );
                      } else {
                        if (dataSnapshot.data.length == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey[300]),
                              child: SizedBox(
                                height: _height * 0.35,
                                width: _width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'There is no collections yet',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[600]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: _height * 0.35,
                            width: _width,
                            child: ListView.builder(
                              itemBuilder: (context, index){
                                return _createCollectionCard(
                                  function: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ContentOfCollection(
                                          isMeFollowing: dataSnapshot
                                              .data[index].isMeFollowing,
                                          collectionName: dataSnapshot
                                              .data[index].collectionName,
                                          friendId: dataSnapshot
                                              .data[index].friendId,
                                          collectionId: dataSnapshot
                                              .data[index].collectionId,
                                          imgUrlForCollection: dataSnapshot.data[index]
                                              .imgUrlForCollection ,
                                          isPublic: dataSnapshot.data[index]
                                              .isPublic,
                                          lastUpdate: dataSnapshot.data[index]
                                              .lastUpdate,
                                          countOfCategory: dataSnapshot
                                              .data[index].countOfCategory,
                                        )));
                                  },
                                  collectionId: dataSnapshot
                                      .data[index].collectionId,
                                  friendId: dataSnapshot
                                      .data[index].friendId,
                                  name: dataSnapshot
                                      .data[index].collectionName,
                                  lastUpdate:  dataSnapshot.data[index]
                                      .lastUpdate,
                                  imgUrlForCollection: dataSnapshot.data[index]
                                  .imgUrlForCollection,
                                  count: dataSnapshot
                                      .data[index].countOfCategory,
                                  isMeFollowing: dataSnapshot
                                      .data[index].isMeFollowing,
                                  image: FadeInImage.assetNetwork(
                                    placeholder: 'images/meal.jpg',
                                    image: dataSnapshot.data[index]
                                        .imgUrlForCollection ==
                                        null
                                        ? 'https://devblog.axway.com/wp-content/uploads/blog-572x320-image-device.png'
                                        : dataSnapshot.data[index]
                                        .imgUrlForCollection,
                                    fit: BoxFit.fill,
                                    height: _height * 0.3,
                                    width: _width * 0.7,
                                  ),
                                );
                              },
                              itemCount: dataSnapshot.data.length,
                            ),
                          );
                        }
                      }
                    }
                  }),
            ],
          ),
        ));
  }
}