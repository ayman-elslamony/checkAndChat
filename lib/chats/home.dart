import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/Providers/user_data.dart';
import 'package:checkandchat/chats/chat.dart';
import 'package:checkandchat/chats/widgets/const.dart';
import 'package:checkandchat/chats/widgets/loading.dart';
import 'package:checkandchat/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:checkandchat/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class FriendData{
  UserData user;
  String lastMessage;
  String id;

  FriendData({this.user, this.lastMessage,this.id});

}
class HomeChatScreen extends StatefulWidget {


  @override
  State createState() => HomeChatScreenState();
}

class HomeChatScreenState extends State<HomeChatScreen> {


  String currentUserId;
  String currentUserToken;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //final GoogleSignIn googleSignIn = GoogleSignIn();

  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];
  Auth _auth;
  UserData _friendData;
  List<FriendData> _AllfriendsData=[];
  Future getRecentChat()async{
   var x = await Firestore.instance.collection('users').document(
        currentUserId).collection('chat').getDocuments();
   for(int i=0; i<x.documents.length ; i++){
     UserData user =await
  _friendData.getUserData(id:  x.documents[i].documentID);
     _AllfriendsData.add(FriendData(user: user,lastMessage:  x.documents[i].data[''],id:x.documents[i].documentID ));
   }
  }
  getdata() async {
    if (Auth.userId == '') {
      setState(() {
        isLoading = true;
      });
      currentUserId = await Auth().getUserId;
      setState(() {
        isLoading = false;
      });
    } else {
      currentUserId = Auth.userId;
    }
    currentUserToken = _auth.getToken();
  }

  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Auth>(context, listen: false);
    _friendData = Provider.of<UserData>(context, listen: false);
    getdata();
//     registerNotification();
//    configLocalNotification();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance.collection('users').document(currentUserId).updateData(
          {'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings(
        'app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

//  void onItemMenuPress(Choice choice) {
//    if (choice.title == 'Log out') {
//      handleSignOut();
//    } else {
//      Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
//    }
//  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.dfa.flutterchatdemo'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
    new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(
        0, message['title'].toString(), message['body'].toString(),
        platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
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

//  Future<Null> handleSignOut() async {
//    this.setState(() {
//      isLoading = true;
//    });
//
//    await FirebaseAuth.instance.signOut();
//    await googleSignIn.disconnect();
//    await googleSignIn.signOut();
//
//    this.setState(() {
//      isLoading = false;
//    });
//
//    Navigator.of(context)
//        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
//  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffc62828),
        title: Text(
          LocaleKeys.chat.tr(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
//        actions: <Widget>[
//          PopupMenuButton<Choice>(
//            onSelected: onItemMenuPress,
//            itemBuilder: (BuildContext context) {
//              return choices.map((Choice choice) {
//                return PopupMenuItem<Choice>(
//                    value: choice,
//                    child: Row(
//                      children: <Widget>[
//                        Icon(
//                          choice.icon,
//                          color: primaryColor,
//                        ),
//                        Container(
//                          width: 10.0,
//                        ),
//                        Text(
//                          choice.title,
//                          style: TextStyle(color: primaryColor),
//                        ),
//                      ],
//                    ));
//              }).toList();
//            },
//          ),
//        ],
      ),
      body: isLoading == true
          ? Expanded(child: Container(child: Center(
          child: CircularProgressIndicator(backgroundColor: Colors.red,))))
          : WillPopScope(
        child: Stack(
          children: <Widget>[
            // List
            Container(
              child: FutureBuilder(
                future: getRecentChat() ,
                builder: (context,snap){
                  if(snap.connectionState == ConnectionState.done){
                    return  ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(context,_AllfriendsData[index]),
                      itemCount: _AllfriendsData.length,
                    );
                  }else{
                    return   Center(
                      child: CircularProgressIndicator(backgroundColor: Colors.red,)
                    );
                  }
                },
              )
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            )
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildItem(BuildContext context,FriendData friendData ) {
//     document.documentID
//  UserData user;
//  _friendData.getUserData(id:  document.documentID).then((value){
//    user=value;
//  });
    if (friendData.id == currentUserId) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: friendData.user.imgUrl != null
                    ? CachedNetworkImage(
                  placeholder: (context, url) =>
                      Container(
                        child: CircularProgressIndicator(backgroundColor: Colors.red,strokeWidth: 1,),
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(15.0),
                      ),
                  imageUrl:  friendData.user.imgUrl,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                )
                    : Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: greyColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          friendData.user.name,
                          style: TextStyle(color: Colors.blueGrey,fontSize: 16),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(
                            10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          ' ${friendData.lastMessage??""}',
                          style: TextStyle(color: Colors.blueGrey,fontSize: 12),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(
                            10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Chat(
                          peerId: friendData.id,
                          peerAvatar:  friendData.user.imgUrl,
                          friendName: friendData.user.name
                          ,
                        )));
          },
          color: Color(0xFFFFE4E1),
          padding: EdgeInsets.fromLTRB(25.0, 12.0, 25.0, 12.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
