import 'dart:io';

import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/Providers/change_index_page.dart';
import 'package:checkandchat/Providers/resturants.dart';
import 'package:checkandchat/Screens/Me/meWidgets/moreWidgets.dart/FriendPage.dart';
import 'package:checkandchat/Screens/Search/searchWidgets/item_details/item_details.dart';
import 'package:checkandchat/Screens/Search/searchWidgets/item_details/widgets/start_a_review.dart';
import 'package:checkandchat/chats/widgets/const.dart';
import 'package:checkandchat/models/activities_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  String userId;
  bool editResult = false;
  bool descTextShowFlag = false;
  Future<void> _allActivities;
  bool refresh = true;
  bool isLoading=true;
 Future<void> _refreshToGetUserData() async{
    //if (refresh) {
    //  _allActivities =
         await Provider.of<Categorys>(context, listen: false).getAllActivities();
     // refresh = false;
   // }
    setState(() {
      isLoading=false;
    });
  }

  _userId() async {
    if(Auth.userId ==''){
      userId = await Auth().getUserId;
    }else{
      userId = Auth.userId;
    }
  }

  @override
  void initState() {
   if(Provider.of<Categorys>(context, listen: false).allActivities.length ==0){
     _refreshToGetUserData();
   }else{
     isLoading=false;
   }

    super.initState();
    _userId();
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

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;


    Widget myActivite({Activities activites,int index}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical:6),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10)
          ),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemDetails(
                            isCommingFromCollection: true,
                            category: activites.category,
                          )));
            },
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${LocaleKeys.youAdded.tr()} ${activites.type} in ${activites.category.name}',
                style: TextStyle(color: Colors.grey[700], fontSize: _width * 0.04,fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    DateFormat('dd/MM/yyyy hh:mm')
                        .format(DateTime.parse(activites.dateForReview)),
                    style: TextStyle(
                      fontSize: _width * 0.032,
                      color: Colors.grey,
                    )),
              ),
            ),
            trailing: activites.type == 'Review'?PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                itemBuilder: (context) => [LocaleKeys.edit.tr(), LocaleKeys.delete.tr()]
                    .map((String val) => PopupMenuItem<String>(
                          child: Text(val),
                          value: val,
                        ))
                    .toList(),
                onSelected: (String val) {
                  print('E D');
                  if (val == 'Edit'|| val =='تعديل') {
                    print('E');
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => StartReview(
                                  category: activites.category,
                                  review: activites.review,
                                )));
                  }
                  if (val == 'Delete'|| val =='حذف') {
                    print('D');
                    Provider.of<Categorys>(context, listen: false)
                        .deleteAReview(
                      resturant: activites.category,
                      review: activites.review,
                    )
                        .then((x) {
                      if (x == 'true') {
                        Toast.show("successfully deleted!", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                        setState(() {
                          refresh = true;
                        });
                        _refreshToGetUserData();
                      } else if (x == 'false') {
                        Toast.show("failed to delete!", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      }
                    });
                  }
                }):PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                itemBuilder: (context) => ['Delete']
                    .map((String val) => PopupMenuItem<String>(
                          child: Text(val),
                          value: val,
                        ))
                    .toList(),
                onSelected: (String val) {
                  print('DD');
                  if (val == 'Delete') {
                    if(activites.type == 'Photo'){
                      print('DP');
                      UserPhotoForSpecificCategory userPhotoForSpecificCategory =UserPhotoForSpecificCategory(
                        userId: activites.userId,
                        date: activites.dateForReview,
                        type: activites.userId == activites.category.ownerId?'owner':'users',
                        userName: activites.userName,
                        userImage: activites.userImgUrl,
                        categoryImage: activites.review.imgUrlForReview,
                      );
                      Provider.of<Categorys>(context, listen: false)
                          .deletePhoto(
                        resturant: activites.category,
                        photosForSpecificCategory: userPhotoForSpecificCategory
                        ,indexForActivites: index 
                      )
                          .then((x) {
                        if (x == 'true') {
                          Toast.show("successfully deleted!", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                          setState(() {
                            refresh = true;
                          });
                          _refreshToGetUserData();
                        } else if (x == 'false') {
                          Toast.show("failed to delete!", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                      });
                    }else{
                      print('D C');
                      Provider.of<Categorys>(context, listen: false)
                          .deleteCheckIn(
                        resturant: activites.category,
                        review: activites.review,
                      )
                          .then((x) {
                        if (x == 'true') {
                          Toast.show("successfully deleted!", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                          setState(() {
                            refresh = true;
                          });
                          _refreshToGetUserData();
                        } else if (x == 'false') {
                          Toast.show("failed to delete!", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
                        }
                      });
                    }
                  }
                }),
          ),
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
                LocaleKeys.activities,
                style: TextStyle(color: Colors.white, fontSize: _width * 0.045),
              ).tr(context: context),
            ),
          ],
        ),
        backgroundColor: Color(0xffc62828),
      ),
      body: WillPopScope(
        child: ListView(
          children: <Widget>[
            RefreshIndicator(
              backgroundColor: Colors.white,
              color: Color(0xffc62828),
              onRefresh: _refreshToGetUserData,
              child: isLoading?Container(
                  height: _height,
                  width: _width,
                  child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ))):Consumer<Categorys>(
                builder: (context, dataSnapshot, _) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: _height*0.84,
                        child: dataSnapshot.allActivities.length == 0
                            ? Center(
                            child: Text(
                                LocaleKeys.noActivities,
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ).tr(context: context))
                            : ListView.builder(
                          itemCount:
                          dataSnapshot.allActivities.length,
                          itemBuilder: (context, index) =>
                              myActivite(
                                  activites: dataSnapshot
                                      .allActivities[index],index: index),
                        ),
                      ),

                    ],
                  );
                },
              ),
            ),
          ],
        ),
        onWillPop: onBackPress ,
      ),
    );
  }
}