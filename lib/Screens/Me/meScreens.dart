import 'dart:io';

import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/Providers/resturants.dart';
import 'package:checkandchat/Providers/user_data.dart';
import 'package:checkandchat/Screens/Me/meWidgets/addShop.dart';
import 'package:checkandchat/Screens/Search/searchWidgets/item_details/item_details.dart';
import 'package:checkandchat/Screens/sign_up/sign_up.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../Screens/Activities/activitiesScreens.dart';
import '../../Screens/Collections/collections.dart';
import '../../Screens/Me/meWidgets/friends.dart';
import '../../Screens/Me/meWidgets/more.dart';
import '../../Screens/Me/meWidgets/notifications.dart';
import '../../Screens/Me/meWidgets/preferences.dart';
import '../../chat/chat_screen.dart';
import 'meWidgets/findFriends.dart';
import 'package:path/path.dart' as path;

import 'meWidgets/friendRequests.dart';
import 'meWidgets/moreWidgets.dart/lang_view.dart';
import '../../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class MeScreens extends StatefulWidget {
  @override
  _MeScreensState createState() => _MeScreensState();
}

class _MeScreensState extends State<MeScreens> {
  String _myAddress;
  File _imageFile;

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _myAddress = Provider.of<Auth>(context, listen: false).myAddress;
    if (UserData().name == null && UserData().imgUrl == null) {
      _refreshToGetUserData();
    }
  }

  Future<void> _refreshToGetUserData() async {
    await Provider.of<UserData>(context, listen: false).getData();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    Divider _divider() {
      return Divider(
        color: Colors.grey[300],
        thickness: 1.0,
        height: 1,
      );
    }

    Future<void> _alert(BuildContext context) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              LocaleKeys.myShopAlert,
              style: TextStyle(fontFamily: 'Cairo'),
            ).tr(context: context),
            actions: <Widget>[
              FlatButton(
                child: Text(LocaleKeys.cancel.tr(),style: TextStyle(fontFamily: 'Cairo'),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> uploadPic() async {
      try {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child('profiles/${path.basename(_imageFile.path)}');
        StorageUploadTask uploadTask = storageReference.putFile(_imageFile);
        await uploadTask.onComplete;
        await storageReference.getDownloadURL().then((fileURL) async {
          await Provider.of<UserData>(context, listen: false)
              .changePicture(imgUrl: fileURL);
        });
        Toast.show(LocaleKeys.success.tr(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } catch (e) {
        Toast.show(LocaleKeys.failed.tr(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }

    Future<void> _getImage(ImageSource source) async {
      await ImagePicker.pickImage(source: source, maxWidth: 400.0)
          .then((File image) {
        _imageFile = image;
        Navigator.pop(context);
      });
      uploadPic();
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
                  LocaleKeys.pickImage,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.red),
                ).tr(context: context),
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
                        LocaleKeys.camera,
                        style: TextStyle(color: Colors.white,fontFamily: 'Cairo'),
                      ).tr(context: context),
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
                        LocaleKeys.gallery,
                        style: TextStyle(color: Colors.white,fontFamily: 'Cairo'),
                      ).tr(context: context),
                      onPressed: () {
                        _getImage(ImageSource.gallery);
                        // Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ]),
            );
          });
    }

    Widget _createListButton(
        {Widget icon1,
        IconData icon2,
        Text text,
        Function function,
        Widget route,
        bool active}) {
      return InkWell(
          onTap: () {
            if (active == true) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => route));
            } else {
              _alert(context);
            }
          },
          child: ListTile(
            dense: true,
            title: Row(
              children: <Widget>[
                icon1,
                Padding(
                  padding: EdgeInsets.only(right: _width * 0.03),
                ),
                text,
                Spacer(),
                Icon(icon2, color: Colors.black12)
              ],
            ),
          ));
    }

    //  Container(
    //   decoration: BoxDecoration(
    //     border: Border(top: BorderSide(color: Colors.grey[300]),),
    //     color: Colors.white
    //   ),
    //   height: _height*0.07,
    //   width: _width*2,
    //         child:Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Row(
    //             children: <Widget>[
    //               icon1,
    //               Padding(padding: EdgeInsets.only(right:10),),
    //               text,
    //               Spacer(),
    //               Icon(icon2,color: Colors.black12)
    //             ],
    //           ),
    //         ),
    // ),

    Widget _userCard(
        {Widget image,
        String name,
        String address,
        int friends,
        int reviews,
        int photos}) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(_width * 0.02),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(_width * 0.02),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: image,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: _width * 0.02),
                      child: Text(
                        '$name',
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontSize: _width * 0.045,
                            fontFamily: 'Cairo'),
                      ),
                    ),
                    _myAddress == null
                        ? SizedBox()
                        : Padding(
                            padding: EdgeInsets.only(bottom: _width * 0.02),
                            child: SizedBox(
                              width: _width * 0.4,
                              child: Text(
                                '$address',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: _width * 0.03,
                                    fontFamily: 'Cairo'),
                                maxLines: 2,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ImageIcon(
                            AssetImage('images/meScreenIcons/friends.png'),
                            size: _width * 0.05,
                            color: Color(0xffc62828),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text('$friends',
                              style: TextStyle(
                                  fontSize: _width * 0.025,
                                  color: Colors.grey[700],
                                  fontFamily: 'Cairo')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ImageIcon(
                            AssetImage('images/meScreenIcons/addReview.png'),
                            size: _width * 0.05,
                            color: Color(0xffc62828),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text('$reviews',
                              style: TextStyle(
                                  fontSize: _width * 0.025,
                                  color: Colors.grey[700],
                                  fontFamily: 'Cairo')),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ImageIcon(
                            AssetImage('images/meScreenIcons/photo.png'),
                            size: _width * 0.05,
                            color: Color(0xffc62828),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            '$photos',
                            style: TextStyle(
                                fontSize: _width * 0.025,
                                color: Colors.grey[700],
                                fontFamily: 'Cairo'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
        body: RefreshIndicator(
            onRefresh: _refreshToGetUserData,
            backgroundColor: Colors.white,
            color: Colors.red,
            child: Consumer<UserData>(builder: (ctx, userData, child) {
              return userData.name == null && userData.imgUrl == null
                  ? Container(
                      height: _height,
                      width: _width,
                      child: Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      )))
                  : Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        titleSpacing: 0.0,
                        title: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(userData.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _width * 0.045,
                                  fontFamily: 'Cairo')),
                        ),
                        actions: <Widget>[
                          PopupMenuButton<int>(
                            onSelected: (x) {
                              _textEditingController.text = userData.name;
                              if (x == 1) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0))),
                                          contentPadding:
                                              EdgeInsets.only(top: 10.0),
                                          title: Text(LocaleKeys.changeName,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18,
                                                  fontFamily: 'Cairo')).tr(context: context),
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              autofocus: true,
                                              controller:
                                                  _textEditingController,
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType: TextInputType.text,
                                              cursorColor: Colors.red,
                                              decoration: InputDecoration(
                                                labelStyle: TextStyle(fontFamily: 'Cairo'),
                                                labelText: LocaleKeys.changeName.tr(),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.red),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.red),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.red),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                              ),
                                              onFieldSubmitted: (_) async {
                                                print(_textEditingController
                                                    .text);
                                                if (_textEditingController
                                                        .text.isEmpty ||
                                                    _textEditingController
                                                            .text.length <
                                                        2) {
                                                  Toast.show(
                                                      "Invalid Name", context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                } else {
                                                  bool x = await Provider.of<
                                                              UserData>(context,
                                                          listen: false)
                                                      .changeName(
                                                          name:
                                                              _textEditingController
                                                                  .text);
                                                  if (x == true) {
                                                    Toast.show(
                                                        "Successfully Changed",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_LONG,
                                                        gravity: Toast.BOTTOM);
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    Toast.show(
                                                        "please try again",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM);
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(LocaleKeys.ok.tr(),
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Cairo')),
                                              onPressed: () async {
                                                print(_textEditingController
                                                    .text);
                                                if (_textEditingController
                                                        .text.isEmpty ||
                                                    _textEditingController
                                                            .text.length <
                                                        2) {
                                                  Toast.show(
                                                      "Invalid Name", context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                } else {
                                                  bool x = await Provider.of<
                                                              UserData>(context,
                                                          listen: false)
                                                      .changeName(
                                                          name:
                                                              _textEditingController
                                                                  .text);
                                                  if (x == true) {
                                                    Toast.show(
                                                        LocaleKeys.success.tr(),
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_LONG,
                                                        gravity: Toast.BOTTOM);
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    Toast.show(
                                                        LocaleKeys.tryAgain.tr(),
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_SHORT,
                                                        gravity: Toast.BOTTOM);
                                                  }
                                                }
                                              },
                                            ),
                                            FlatButton(
                                              child: Text(LocaleKeys.cancel.tr(),
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Cairo')),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ));
                              } else {
                                _openImagePicker();
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text(LocaleKeys.changeName,
                                    style: TextStyle(fontFamily: 'Cairo')).tr(context: context),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(LocaleKeys.changePhoto,
                                    style: TextStyle(fontFamily: 'Cairo')).tr(context: context),
                              ),
                            ],
                          )
                        ],
                        backgroundColor: Color(0xffc62828),
                      ),
                      body: ListView(
                        children: <Widget>[
                          _userCard(
                            image: FadeInImage.assetNetwork(
                              placeholder:
                                  'images/meScreenIcons/userPlaceholder.png',
                              image: userData.imgUrl,
                              fit: BoxFit.fill,
                              height: 120,
                              width: 120,
                            ),
                            address: _myAddress,
                            name: userData.name,
                            friends: userData.friendsCount,
                            photos: userData.imageCount,
                            reviews: userData.reviewsCount,
                          ),

                          _divider(),
                          ListTile(
                              title: Text(
                            LocaleKeys.addShopDescription,
                            style: TextStyle(
                                fontSize: _width * 0.05, fontFamily: 'Cairo'),
                          ).tr(context: context)),
                          InkWell(
                            onTap: () async {
                              bool x = await Provider.of<UserData>(context,
                                      listen: false)
                                  .isHaveShop();
                              if (x == true) {
                                Toast.show("Already have shop", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddShop()));
                              }
                            },
                            child: ListTile(
                                leading: Image.asset(
                                  'images/meScreenIcons/addShopp.png',
                                ),
                                title: Text(
                                    LocaleKeys.youCanAddShop,
                                    style: TextStyle(
                                        fontSize: _width * 0.035,
                                        fontFamily: 'Cairo')).tr(context: context)),
                          ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.center,

                          //   children: <Widget>[
                          //     Stack(
                          //       children: <Widget>[
                          //         ClipRRect(
                          //           borderRadius: BorderRadius.circular(5),
                          //           child: SizedBox(
                          //             child: FittedBox(
                          //               child: Image.asset('images/meals.jpg'),
                          //               fit: BoxFit.cover,),
                          //             height: _height * 0.14,
                          //             width: _width * 0.3,
                          //           ),
                          //         ),
                          //         ClipRRect(
                          //           borderRadius: BorderRadius.circular(5),
                          //           child: SizedBox(
                          //             child: Container(color: Colors.black54,),
                          //             height: _height * 0.14,
                          //             width: _width * 0.3,

                          //           ),),
                          //         Positioned(
                          //           child: Text(
                          //             'Photos',
                          //             style: TextStyle(color: Colors.white,
                          //                 fontSize: _width * 0.04),),
                          //           bottom: _height * 0.06,
                          //           right: _width * 0.08,
                          //         )
                          //       ],
                          //     ),
                          //     SizedBox(width: 10,),
                          //     Stack(
                          //       children: <Widget>[
                          //         ClipRRect(
                          //           borderRadius: BorderRadius.circular(5),
                          //           child: SizedBox(
                          //             child: FittedBox(
                          //               child: Image.asset('images/meal2.jpg'),
                          //               fit: BoxFit.cover,),
                          //             height: _height * 0.14,
                          //             width: _width * 0.3,
                          //           ),
                          //         ),
                          //         ClipRRect(
                          //           borderRadius: BorderRadius.circular(5),
                          //           child: SizedBox(
                          //             child: Container(color: Colors.black54,),
                          //             height: _height * 0.14,
                          //             width: _width * 0.3,

                          //           ),),
                          //         Positioned(
                          //           bottom: _height * 0.06,
                          //           right: _width * 0.075,
                          //           child: Text(
                          //             'Reviews',
                          //             style: TextStyle(color: Colors.white,
                          //                 fontSize: _width * 0.04),),
                          //         )
                          //       ],
                          //     ),
                          //     SizedBox(height: 20, width: 10,),
                          //     Stack(
                          //       children: <Widget>[
                          //         ClipRRect(
                          //           borderRadius: BorderRadius.circular(5),
                          //           child: SizedBox(
                          //             child: FittedBox(
                          //               child: Image.asset('images/meal2.jpg'),
                          //               fit: BoxFit.cover,),
                          //             height: _height * 0.14,
                          //             width: _width * 0.3,
                          //           ),
                          //         ),
                          //         ClipRRect(
                          //           borderRadius: BorderRadius.circular(5),
                          //           child: SizedBox(
                          //             child: Container(color: Colors.black54,),
                          //             height: _height * 0.14,
                          //             width: _width * 0.3,

                          //           ),),
                          //         Positioned(
                          //           bottom: _height * 0.06,
                          //           right: _width * 0.075,
                          //           child: Text(
                          //             'Check in',
                          //             style: TextStyle(color: Colors.white,
                          //                 fontSize: _width * 0.04),
                          //           ),
                          //         )
                          //       ],
                          //     ),

                          //   ],
                          //   ),
                          SizedBox(
                            height: 30,
                          ),

                          _divider(),
                          InkWell(
                              onTap: () async {
                                Category category = await Provider.of<UserData>(
                                        context,
                                        listen: false)
                                    .getMyShop();
                                if (category == null) {
                                  _alert(context);
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ItemDetails(
                                            isCommingFromCollection: true,
                                            category: category,
                                          )));
                                }
                              },
                              child: ListTile(
                                dense: true,
                                title: Row(
                                  children: <Widget>[
                                    ImageIcon(
                                        AssetImage(
                                            'images/meScreenIcons/myShopp.png'),
                                        color: Colors.grey[600]),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: _width * 0.03),
                                    ),
                                    Text(LocaleKeys.myShop,
                                        style: TextStyle(
                                            color: Colors.grey[850],
                                            fontSize: _width * 0.035,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Cairo')).tr(context: context),
                                    Spacer(),
                                    Icon(Icons.arrow_forward_ios,
                                        color: Colors.black12)
                                  ],
                                ),
                              )),
//                  _divider(),
//                  _createListButton(
//                      active: true,
//                      route: Notifications(),
//                      icon1: ImageIcon(
//                          AssetImage(
//                              'images/meScreenIcons/bell.png'),
//                          color: Colors.grey[600]),
//                      icon2: Icons.arrow_forward_ios,
//                      text: Text('Notifications',
//                          style: TextStyle(
//                              color: Colors.grey[850],
//                              fontSize: _width * 0.035,
//                              fontWeight: FontWeight.w700,fontFamily: 'Cairo'))),
                          _divider(),

                          _createListButton(
                              active: true,
                              route: Friends(),
                              icon1: ImageIcon(
                                  AssetImage(
                                      'images/meScreenIcons/friends.png'),
                                  color: Colors.grey[600]),
                              icon2: Icons.arrow_forward_ios,
                              text: Text(LocaleKeys.friends,
                                  style: TextStyle(
                                      color: Colors.grey[850],
                                      fontSize: _width * 0.035,
                                      fontWeight: FontWeight.w700,fontFamily: 'cairo')).tr(context: context)),
                          _divider(),

                          _createListButton(
                              active: true,
                              route: FriendRequests(),
                              icon1: ImageIcon(
                                  AssetImage(
                                      'images/meScreenIcons/friendRequest.png'),
                                  color: Colors.grey[700]),
                              icon2: Icons.arrow_forward_ios,
                              text: Text(LocaleKeys.friendRequests,
                                  style: TextStyle(
                                      color: Colors.grey[850],
                                      fontSize: _width * 0.035,
                                      fontWeight: FontWeight.w700,fontFamily: 'cairo')).tr(context: context)),
                          _divider(),
                          _createListButton(
                              active: true,
                              route: FindFriends(),
                              icon1: ImageIcon(
                                  AssetImage(
                                      'images/meScreenIcons/findFriends.png'),
                                  color: Colors.grey[600]),
                              icon2: Icons.arrow_forward_ios,
                              text: Text(LocaleKeys.findF,
                                  style: TextStyle(
                                      color: Colors.grey[850],
                                      fontSize: _width * 0.035,
                                      fontWeight: FontWeight.w700,fontFamily: 'cairo')).tr(context: context)),
                          _divider(),
                          _createListButton(
                              active: true,
                              route: Collections(),
                              icon1: ImageIcon(
                                  AssetImage('images/NavBar/bookmark.png'),
                                  color: Colors.grey[600]),
                              icon2: Icons.arrow_forward_ios,
                              text: Text(LocaleKeys.collections,
                                  style: TextStyle(
                                      color: Colors.grey[850],
                                      fontSize: _width * 0.035,
                                      fontWeight: FontWeight.w700,fontFamily: 'cairo')).tr(context: context)),
                          _divider(),
                          _createListButton(
                              active: true,
                              route: ChatHomeScreen(),
                              icon1: ImageIcon(
                                  AssetImage(
                                      'images/meScreenIcons/messages.png'),
                                  color: Colors.grey[600]),
                              icon2: Icons.arrow_forward_ios,
                              text: Text(LocaleKeys.messages,
                                  style: TextStyle(
                                      color: Colors.grey[850],
                                      fontSize: _width * 0.035,
                                      fontWeight: FontWeight.w700,fontFamily: 'cairo')).tr(context: context)),
                          _divider(),
                          _createListButton(
                              active: true,
                              route: ActivitiesScreen(),
                              icon1: ImageIcon(
                                  AssetImage('images/NavBar/activity.png'),
                                  color: Colors.grey[600]),
                              icon2: Icons.arrow_forward_ios,
                              text: Text(LocaleKeys.activities,
                                  style: TextStyle(
                                      color: Colors.grey[850],
                                      fontSize: _width * 0.035,
                                      fontWeight: FontWeight.w700,fontFamily: 'cairo')).tr(context: context)),
                          _divider(),
                          _createListButton(
                              active: true,
                              route: More(),
                              icon1: ImageIcon(
                                  AssetImage('images/meScreenIcons/more.png'),
                                  color: Colors.grey[600]),
                              icon2: Icons.arrow_forward_ios,
                              text: Text(LocaleKeys.more,
                                  style: TextStyle(
                                      color: Colors.grey[850],
                                      fontSize: _width * 0.035,
                                      fontWeight: FontWeight.w700,fontFamily: 'cairo')).tr(context: context)),
                          _divider(),
                          _createListButton(
                              active: true,
                              route: LanguageView(),
                              icon1: Icon(
                                Icons.language,
                                color: Colors.grey[600],
                              ),
                              icon2: Icons.arrow_forward_ios,
                              text: Text(LocaleKeys.language,
                                  style: TextStyle(
                                      color: Colors.grey[850],
                                      fontSize: _width * 0.035,
                                      fontWeight: FontWeight.w700,fontFamily: 'cairo')).tr(context: context),
                              function: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => LanguageView()));
                              }),
                          _divider(),
                          InkWell(
                              onTap: () {
                                Provider.of<Auth>(context, listen: false)
                                    .logout()
                                    .then((x) {
                                  if (x) {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()));
                                  }
                                });
                              },
                              child: ListTile(
                                dense: true,
                                title: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.exit_to_app,
                                      color: Colors.grey[600],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: _width * 0.03),
                                    ),
                                    Text(LocaleKeys.logout,
                                        style: TextStyle(
                                            color: Colors.grey[850],
                                            fontSize: _width * 0.035,
                                            fontWeight: FontWeight.w700,fontFamily: 'cairo')).tr(context: context),
                                    Spacer(),
                                    Icon(Icons.arrow_forward_ios,
                                        color: Colors.black12)
                                  ],
                                ),
                              )),
                          _divider(),
                          // ListTile(
                          //   leading: Icon(Icons.exit_to_app),
                          //   title: Text('Logout'),
                          //   dense: true,
                          //   trailing: Icon(
                          //     Icons.arrow_forward_ios, color: Colors.grey,),
                          //   onTap: () {
                          //     // Navigator.of(context)
                          //     //     .pushReplacementNamed(UserProductsScreen.routeName);
                          //     Provider.of<Auth>(context, listen: false)
                          //         .logout()
                          //         .then((x) {
                          //       if (x) {
                          //         Navigator.of(context).pushReplacement(
                          //             MaterialPageRoute(
                          //                 builder: (context) => SignUp()));
                          //       }
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                    );
            })));
  }
}
