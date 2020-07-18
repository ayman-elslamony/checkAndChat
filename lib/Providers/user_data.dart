import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:checkandchat/Providers/resturants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'Auth.dart';
import 'package:checkandchat/models/message_model.dart';

class UserData with ChangeNotifier {
  final String id;
  String name;
  String email;
  String imgUrl;
  int friendsCount;
  int reviewsCount;
  int imageCount;
  String address;
  String isFriendAdded;
  List<UserData> _allFriends = [];
  List<UserData> _friends = [];
  List<UserData> _allFriendsForSearch = [];
  List<Message> _messages = [];
  bool isMessageLiked = false;
  UserData _userData;
  UserData get friendUserData {
    return _userData;
  }

  UserData(
      {this.name,
      this.email,
      this.imgUrl,
      this.friendsCount = 0,
      this.imageCount = 0,
      this.isFriendAdded,
      this.reviewsCount = 0,
      this.address,
      this.id});

  var firebaseAuth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance;
  List<UserData> get allFriends {
    return _allFriends;
  }

  Future<void> createRecord({String userId, UserData userData}) async {
    var users = databaseReference.collection("users");
    DocumentSnapshot doc = await users.document(userId).get();
    if (!doc.exists) {
      await users.document(userId).setData({
        'name': userData.name,
        'email': userData.email,
        'imgUrl': userData.imgUrl,
        'friendsCount': userData.friendsCount,
        'reviewsCount': userData.reviewsCount,
        'imageCount': userData.imageCount,
      });
    }
  }

  Future<void> changeHeart({String friendId = '', Message mm}) async {
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }

    //    _friends.clear();
    //    _allFriends.clear();
    CollectionReference mainCollection = databaseReference.collection('users');
    bool x = !mm.isLiked;
    try {
      await mainCollection
          .document(userId)
          .collection('chat')
          .document(friendId)
          .collection('messages')
          .document(mm.id)
          .updateData({
        'isLiked': x,
      });
      mm.isLiked = !mm.isLiked;
    } catch (e) {}
    notifyListeners();
  }

  Future<bool> sendMessage({String friendId = '', Message message}) async {
    String userId;
    DateTime timeNow = DateTime.now();
    String formattedtimeNow = DateFormat("yyyy-MM-dd HH:mm").format(timeNow);    
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    CollectionReference mainCollection = databaseReference.collection('users');
    // CollectionReference  users = databaseReference.collection("users");
    // // DocumentSnapshot friend= await  users.document(userId).collection('chat').document(friendId).get();

    // // if(friend.exists ){
    // //   //not register
    // //    mainCollection.document(userId).collection('chat').document(friendId);
    // // }
    await mainCollection
        .document(userId)
        .collection('chat')
        .document(friendId)
        .setData({
      'text': message.text,
      'time': formattedtimeNow,
      'unread': true
    });
await mainCollection
        .document(friendId)
        .collection('chat')
        .document(userId)
        .setData({
      'text': message.text,
      'time': formattedtimeNow,
      'unread': true
    });
  await   mainCollection
        .document(userId)
        .collection('chat')
        .document(friendId)
        .collection('messages')
        .document()
        .setData({
      'userId': userId,
      'text': message.text,
      'time': formattedtimeNow,
      'isLiked': false,
      'unread': true
    });
   await   mainCollection
        .document(friendId)
        .collection('chat')
        .document(userId)
        .collection('messages')
        .document()
        .setData({
      'userId': userId,
      'text': message.text,
      'time': formattedtimeNow,
      'isLiked': false,
      'unread': true
    });
    return true;
  }

  Future<List<Message>> getMessage({String friendId = ''}) async {
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }

    CollectionReference mainCollection = databaseReference.collection('users');

    QuerySnapshot x = await mainCollection
        .document(userId)
        .collection('chat')
        .document(friendId)
        .collection('messages')
        .getDocuments();
    List<Message> _mess = [];

    if (x.documents.length > 0) {
      for (int i = 0; i < x.documents.length; i++) {
        _mess.add(Message(
          id: x.documents[i].documentID,
          text: x.documents[i].data['text'],
          isLiked: x.documents[i].data['isLiked'],
          time:x.documents[i].data['time'].toString(),
          unread: x.documents[i].data['unread'],
          friendId: x.documents[i].data['userId']
        ));
      }
    }
    return _mess;
  }

  Future<List<Recentchat>> getAllFriendsForChatSreen() async {
    String userId;

    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    List<Recentchat> recentchat = [];
    CollectionReference mainCollection = databaseReference.collection('users');
    QuerySnapshot friendsInChat =
        await mainCollection.document(userId).collection('chat').getDocuments();

    if (friendsInChat.documents.length > 0) {
      for (int i = 0; i < friendsInChat.documents.length; i++) {
        UserData userData =
            await getFriensUserData(id: friendsInChat.documents[i].documentID);
        Recentchat _chat = Recentchat(
          userdata: userData,
          time: friendsInChat.documents[i].data['time'],
          text: friendsInChat.documents[i].data['text'],
          unread: friendsInChat.documents[i].data['unread']
        );
        recentchat.add(_chat);
      }
    }
    return recentchat;
  }

  Future<void> getAllFriendsWithOutNotifer({String id = ''}) async {
    String userId;
    if (id == '') {
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }
    } else {
      userId = id;
    }
    _friends.clear();
    CollectionReference mainCollection = Firestore.instance.collection('users');
    QuerySnapshot friends = await mainCollection
        .document(userId)
        .collection('friends')
        .getDocuments();
    if (friends.documents.length > 0) {
      for (int i = 0; i < friends.documents.length; i++) {
        UserData userData =
            await getFriensUserData(id: friends.documents[i].documentID);
        _friends.add(userData);
      }
    }
  }

  Future<String> registerShop({
    String countryName = '',
    String businessName,
    String businessAddress,
    String businessCategory = '',
    String businessPhone = '',
    String businessWebsite = '',
    String startTime = '',
    String endTime = '',
    File imgFile,
    String priceLevel = '',
    String lat = '',
    String lng = '',
    String typeOfServices = '',
  }) async {
    String type = 'caterory';
    if (businessCategory != '') {
      if (businessCategory == 'Resturant') {
        type = 'restaurant';
      } else if (businessCategory == 'Caffe') {
        type = 'cafe';
      } else if (businessCategory == 'Accounting') {
        type = 'accounting';
      } else if (businessCategory == 'shopping') {
        type = 'shopping_mall';
      } else if (businessCategory == 'Car Gas') {
        type = 'gas_station';
      } else if (businessCategory == 'Hospital') {
        type = 'hospital';
      } else if (businessCategory == 'Pharmacy') {
        type = 'pharmacy';
      }
    }
    String _priceLevel = '';
    if (priceLevel != '') {
      if (priceLevel == 'Free') {
        _priceLevel = 'PriceLevel.free';
      }
      if (priceLevel == 'Inexpensive') {
        _priceLevel = 'PriceLevel.inexpensive';
      }
      if (priceLevel == 'Moderate') {
        _priceLevel = 'PriceLevel.moderate';
      }
      if (priceLevel == 'Expensive') {
        _priceLevel = 'PriceLevel.expensive';
      }
      if (priceLevel == 'Very Expensive') {
        _priceLevel = 'PriceLevel.veryExpensive';
      }
    }

    try {
      String urlImage = '';
      String userId;
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }
      if (imgFile != null) {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child('shops/${path.basename(imgFile.path)}');
        StorageUploadTask uploadTask = storageReference.putFile(imgFile);
        await uploadTask.onComplete;
        await storageReference.getDownloadURL().then((fileURL) {
          urlImage = fileURL;
        });
      }
      DocumentSnapshot id = await Firestore.instance
          .document('users/$userId')
          .collection('shop')
          .document(businessName)
          .get();

      if (id == null || !id.exists) {
        await Firestore.instance
            .document('users/$userId')
            .collection('shop')
            .document(businessName)
            .setData({
          'userId': userId,
          'id': businessName,
          'countryName': countryName,
          'businessName': businessName,
          'businessAddress': businessAddress,
          'bussinessCategory': type,
          'businessPhone': businessPhone,
          'businessWebsite': businessWebsite,
          'startTime': startTime,
          'typeOfServices': typeOfServices,
          'endTime': endTime,
          'imgUrl': urlImage,
          'priceLevel': _priceLevel,
          'lat': lat,
          'lng': lng
        });
        await databaseReference.collection('places').document(businessName).setData({
          'userId': userId,
          'placeId': businessName,
        });
        return 'true';
      } else {
        return 'Already Exists';
      }
    } catch (e) {
      return 'false';
    }
  }
Future<bool> isHaveShop()async{
  String userId;
  if (Auth.userId == '') {
    userId = await Auth().getUserId;
  } else {
    userId = Auth.userId;
  }
  QuerySnapshot doc = await Firestore.instance
      .document('users/$userId')
      .collection('shop')
      .getDocuments();
  if(doc.documents.length !=0){
    return true;
  }else{
    return false;
  }
}
  Future<Category> getMyShop() async {
    Category myCategory;
    try {
      String userId;
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }
      QuerySnapshot doc = await Firestore.instance
          .document('users/$userId')
          .collection('shop')
          .getDocuments();
      if (doc.documents.length != 0) {
        QuerySnapshot doc = await Firestore.instance
            .document('users/$userId')
            .collection('shop')
            .getDocuments();

        List<String> start = doc.documents[0].data['startTime'].split(':');
        List<String> end = doc.documents[0].data['endTime'].split(':');
        var timeNow = DateTime.now();
        timeNow = timeNow.toLocal();
        bool isOpen=false;
        if (timeNow.hour >= int.parse(start[0]) &&
            timeNow.hour <= int.parse(end[0])) {
          isOpen =true;
        }
        print(doc.documents[0].data['businessName']);
        myCategory = Category(
          ownerId: doc.documents[0].data['userId'],
          name: doc.documents[0].data['businessName'],
          underCategory: doc.documents[0].data['bussinessCategory'],
          openNow: isOpen.toString(),
          types: [doc.documents[0].data['typeOfServices']],
          priceLevel: doc.documents[0].data['priceLevel'] == null
              ? ''
              : doc.documents[0].data['priceLevel'],
          phone: doc.documents[0].data['businessPhone'],
          lat: double.parse(doc.documents[0].data['lat']),
          long: double.parse(doc.documents[0].data['lng']),
          distance: 0.0,
          rating: 0.0,
          id: doc.documents[0].data['businessName'],
          vicinity: doc.documents[0].data['businessAddress'],
          imgUrl: doc.documents[0].data['imgUrl'] == null
              ? []
              : [doc.documents[0].data['imgUrl']],
        );
        return myCategory;
      } else {
        return null;
      }
    } catch (e) {
      print(e.message);
    }
  }


  Future<bool> changeName({String name}) async {
    try {
      String userId;
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }
      await Firestore.instance.document('users/$userId').updateData({
        'name': name,
      });
      this.name = name;
      notifyListeners();
      return true;
    } catch (e) {
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePicture({String imgUrl}) async {
    try {
      String userId;
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }
      await Firestore.instance.document('users/$userId').updateData({
        'imgUrl': imgUrl,
      });
      this.imgUrl = imgUrl;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> getData() async {
    String id;
    if (Auth.userId == '') {
      id = await Auth().getUserId;
    } else {
      id = Auth.userId;
    }
    if (id != null) {
      DocumentSnapshot document =
          await Firestore.instance.document('users/$id').get();
      name = document.data['name'];
      imgUrl = document.data['imgUrl'];
      email = document.data['email'];
      friendsCount = document.data['friendsCount'] == null
          ? 0
          : document.data['friendsCount'];
      imageCount =
          document.data['imageCount'] == null ? 0 : document.data['imageCount'];
      reviewsCount = document.data['reviewsCount'] == null
          ? 0
          : document.data['reviewsCount'];
    }
    notifyListeners();
  }

  Future<UserData> getUserData({String id}) async {
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    UserData user;
    String friendStatus;
    if (id != null) {
      DocumentSnapshot document =
          await databaseReference.document('users/$id').get();
      CollectionReference mainCollection =
          databaseReference.collection('users');
      DocumentSnapshot friendData = await mainCollection
          .document(userId)
          .collection('friendsRequest')
          .document(id)
          .get();
      DocumentSnapshot isFriends = await mainCollection
          .document(userId)
          .collection('friends')
          .document(id)
          .get();
      if (friendData != null && friendData.exists) {
        if (friendData['isMeSendRequest']) {
          friendStatus = 'isMeSendRequest';
        } else {
          friendStatus = 'notMeSendRequest';
        }
      } else if (isFriends.exists && isFriends != null) {
        friendStatus = 'alreadyFriends';
      } else {
        friendStatus = 'false';
      }
      user = UserData(
          id: id,
          isFriendAdded: friendStatus,
          imgUrl: document.data['imgUrl'],
          name: document.data['name'] ?? '',
          friendsCount: document.data['friendsCount'] == null
              ? 0
              : document.data['friendsCount'],
          email: document.data['email'],
          imageCount: document.data['imageCount'] == null
              ? 0
              : document.data['imageCount'],
          reviewsCount: document.data['reviewsCount'] == null
              ? 0
              : document.data['reviewsCount'],
          address:
              document.data['address'] == null ? '' : document.data['address']);
    }
    _userData = user;
    notifyListeners();
    return _userData;
  }

  Future<UserData> getFriensUserData({String id}) async {
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    UserData user;
    String friendStatus;
    if (id != null) {
      DocumentSnapshot document =
          await databaseReference.document('users/$id').get();
      CollectionReference mainCollection =
          databaseReference.collection('users');
      DocumentSnapshot friendData = await mainCollection
          .document(userId)
          .collection('friendsRequest')
          .document(id)
          .get();
      DocumentSnapshot isFriends = await mainCollection
          .document(userId)
          .collection('friends')
          .document(id)
          .get();
      if (friendData != null && friendData.exists) {
        if (friendData['isMeSendRequest']) {
          friendStatus = 'isMeSendRequest';
        } else {
          friendStatus = 'notMeSendRequest';
        }
      } else if (isFriends.exists && isFriends != null) {
        friendStatus = 'alreadyFriends';
      } else {
        friendStatus = 'false';
      }
      user = UserData(
          id: id,
          isFriendAdded: friendStatus,
          imgUrl: document.data['imgUrl'],
          name: document.data['name'] ?? '',
          friendsCount: document.data['friendsCount'] == null
              ? 0
              : document.data['friendsCount'],
          email: document.data['email'],
          imageCount: document.data['imageCount'] == null
              ? 0
              : document.data['imageCount'],
          reviewsCount: document.data['reviewsCount'] == null
              ? 0
              : document.data['reviewsCount'],
          address:
              document.data['address'] == null ? '' : document.data['address']);
    }
    return user;
  }

  Future<List<UserData>> getAllFriendRequest() async {
    List<UserData> allFriendRequest = [];
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    CollectionReference mainCollection = Firestore.instance.collection('users');
    var doc = await mainCollection
        .document(userId)
        .collection('friendsRequest')
        .getDocuments();
    for (int i = 0; i < doc.documents.length; i++) {
      UserData userData =
          await getFriensUserData(id: doc.documents[i].documentID);
      allFriendRequest.add(userData);
    }
    return allFriendRequest;
  }

  addFriend({String friendID, UserData friendDeta}) async {
    String userId;
    String friendStatus;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    CollectionReference mainCollection = Firestore.instance.collection('users');
    //ayman tell ahmed , friendID is id for ahmed
    mainCollection
        .document(friendID)
        .collection('friendsRequest')
        .document(userId)
        .setData({
      'friendID': userId,
      'isMeSendRequest': false,
    });
    //ayman want to rememder is send to ahmed??
    //      to make it save request in your database
    mainCollection
        .document(userId)
        .collection('friendsRequest')
        .document(friendID)
        .setData({
      //'MyId':userId,
      'friendID': friendID,
      'isMeSendRequest': true,
    });
    //    DocumentSnapshot friendData=await mainCollection.document(userId).collection('friendsRequest').document(id).get();
    //    DocumentSnapshot isFriends= await mainCollection.document(userId).collection('friends').document(id).get();
    //    if(friendData != null && friendData.exists){
    //      if(friendData['isMeSendRequest']){
    //        friendStatus= 'isMeSendRequest';
    //      }else{
    //        friendStatus=  'notMeSendRequest';
    //      }
    //    }else if(isFriends.exists && isFriends != null ){
    //      friendStatus=  'alreadyFriends';
    //    }else{
    //      friendStatus=  'false';
    //    }
    //    print(friendStatus);
    //    friendDeta.isFriendAdded=friendStatus;
    //    print(friendDeta.isFriendAdded);
    friendDeta.isFriendAdded = 'isMeSendRequest';
    notifyListeners();
  }

  unFriend({String friendID, UserData friendDeta}) async {
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    CollectionReference mainCollection = Firestore.instance.collection('users');
    DocumentSnapshot x = await mainCollection
        .document(friendID)
        .collection('friendsRequest')
        .document(userId)
        .get();
    if (x.exists && x != null) {
      mainCollection
          .document(friendID)
          .collection('friendsRequest')
          .document(userId)
          .delete();
      mainCollection
          .document(userId)
          .collection('friendsRequest')
          .document(friendID)
          .delete();
    } else {
      DocumentSnapshot documentForFriend =
          await Firestore.instance.document('users/$friendID').get();
      DocumentSnapshot me = await mainCollection
          .document(friendID)
          .collection('friends')
          .document(userId)
          .get();
      DocumentSnapshot you = await mainCollection
          .document(userId)
          .collection('friends')
          .document(friendID)
          .get();
      if (me.exists && you.exists && me != null && you != null) {
        var numOfFriendsForFriend = documentForFriend.data['friendsCount'];
        numOfFriendsForFriend = numOfFriendsForFriend - 1;
        Firestore.instance
            .document('users/$friendID')
            .updateData({'friendsCount': numOfFriendsForFriend});
        DocumentSnapshot documentForMe =
            await Firestore.instance.document('users/$userId').get();
        var numOfFriendsForMe = documentForMe.data['friendsCount'];
        numOfFriendsForMe = numOfFriendsForMe - 1;
        await Firestore.instance
            .document('users/$userId')
            .updateData({'friendsCount': numOfFriendsForMe});
        await mainCollection
            .document(friendID)
            .collection('friends')
            .document(userId)
            .delete();
        await mainCollection
            .document(userId)
            .collection('friends')
            .document(friendID)
            .delete();
      }
    }
    //    DocumentSnapshot friendData=await mainCollection.document(userId).collection('friendsRequest').document(id).get();
    //    DocumentSnapshot isFriends= await mainCollection.document(userId).collection('friends').document(id).get();
    //    if(friendData != null && friendData.exists){
    //      if(friendData['isMeSendRequest']){
    //        _userData.isFriendAdded= 'isMeSendRequest';
    //      }else{
    //        _userData.isFriendAdded=  'notMeSendRequest';
    //      }
    //    }else if(isFriends.exists && isFriends != null ){
    //      _userData.isFriendAdded=  'alreadyFriends';
    //    }else{
    //      _userData.isFriendAdded=  'false';
    //    }
    friendDeta.isFriendAdded = 'false';
    notifyListeners();
  }

  acceptFriend({String friendID, UserData friendDeta}) async {
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    CollectionReference mainCollection = Firestore.instance.collection('users');
    mainCollection
        .document(userId)
        .collection('friendsRequest')
        .document(friendID)
        .delete();
    mainCollection
        .document(friendID)
        .collection('friendsRequest')
        .document(userId)
        .delete();
    mainCollection
        .document(friendID)
        .collection('friends')
        .document(userId)
        .setData({
      'date': DateTime.now().toIso8601String(),
      'friendID': userId,
    });
    DocumentSnapshot documentForFriend =
        await Firestore.instance.document('users/$friendID').get();
    var numOfFriendsForFriend = documentForFriend.data['friendsCount'];
    numOfFriendsForFriend = numOfFriendsForFriend + 1;
    Firestore.instance
        .document('users/$friendID')
        .updateData({'friendsCount': numOfFriendsForFriend});

    DocumentSnapshot documentForMe =
        await Firestore.instance.document('users/$userId').get();
    var numOfFriendsForMe = documentForMe.data['friendsCount'];
    numOfFriendsForMe = numOfFriendsForMe + 1;
    Firestore.instance
        .document('users/$userId')
        .updateData({'friendsCount': numOfFriendsForMe});

    mainCollection
        .document(userId)
        .collection('friends')
        .document(friendID)
        .setData({
      'date': DateTime.now().toIso8601String(),
      'friendID': friendID,
    });
    DocumentSnapshot friendData = await mainCollection
        .document(userId)
        .collection('friendsRequest')
        .document(id)
        .get();
    DocumentSnapshot isFriends = await mainCollection
        .document(userId)
        .collection('friends')
        .document(id)
        .get();
    if (friendData != null && friendData.exists) {
      if (friendData['isMeSendRequest']) {
        friendDeta.isFriendAdded = 'isMeSendRequest';
      } else {
        friendDeta.isFriendAdded = 'notMeSendRequest';
      }
    } else if (isFriends.exists && isFriends != null) {
      friendDeta.isFriendAdded = 'alreadyFriends';
    } else {
      friendDeta.isFriendAdded = 'false';
    }
    notifyListeners();
  }

  Future<void> getAllFriends({String id = ''}) async {
    String userId;
    if (id == '') {
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }
    } else {
      userId = id;
    }
    _friends.clear();
    _allFriends.clear();
    CollectionReference mainCollection = databaseReference.collection('users');
    QuerySnapshot friends = await mainCollection
        .document(userId)
        .collection('friends')
        .getDocuments();
    if (friends.documents.length > 0) {
      for (int i = 0; i < friends.documents.length; i++) {
        UserData userData =
            await getFriensUserData(id: friends.documents[i].documentID);
        _friends.add(userData);
      }
    }
    _allFriends = _friends;
    notifyListeners();
  }

  // Future<void> getAllFriendsWithOutNotifer({String id=''})async{
  //   String userId;
  //   if(id ==''){
  //     if(Auth.userId ==''){
  //       userId = await Auth().getUserId;
  //     }else{
  //       userId = Auth.userId;
  //     }
  //   }else{
  //     userId =id;
  //   }
  //   _friends.clear();
  //   CollectionReference mainCollection =
  //   Firestore.instance.collection('users');
  //   QuerySnapshot friends=await mainCollection.document(userId).collection('friends').getDocuments();
  //   if(friends.documents.length >0){
  //     for(int i =0; i<friends.documents.length; i++){
  //       UserData userData = await getFriensUserData(id: friends.documents[i].documentID);
  //       _friends.add( userData);
  //     }
  //   }
  // }
  Future<void> getAllFriendsInTheAppWithOutNotifer() async {
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    _friends.clear();
    CollectionReference mainCollection = Firestore.instance.collection('users');
    QuerySnapshot friends = await mainCollection.getDocuments();
    if (friends.documents.length > 0) {
      for (int i = 0; i < friends.documents.length; i++) {
        if (friends.documents[i].documentID != userId) {
          UserData userData =
              await getFriensUserData(id: friends.documents[i].documentID);
          _friends.add(userData);
        }
      }
    }
  }

  searchForFriends({String nameForSearch = ''}) async {
    List<UserData> listForSearch = [];
    listForSearch.addAll(_friends.where(
        (x) => x.name.toLowerCase().startsWith(nameForSearch.toLowerCase())));
    _allFriends.clear();
    _allFriends = listForSearch;
    notifyListeners();
  }
}
