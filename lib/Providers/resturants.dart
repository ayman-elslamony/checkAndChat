import 'dart:io';
import 'dart:math';
import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/models/activities_data.dart';
import 'package:checkandchat/models/collection_for_friends.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:toast/toast.dart';
import 'package:path/path.dart' as path;

class Category {
  String id;
  String name;
  double rating;
  List<String> imgUrl;
  List<String> types;
  String phone;
  String openNow;
  String priceLevel;
  String vicinity;
  double lat;
  double long;
  String underCategory;
  double distance;
  String date;
  String ownerId;

  Category(
      {this.ownerId,
      this.id,
      this.name,
      this.rating,
      this.imgUrl,
      this.phone,
      this.openNow,
      this.vicinity,
      this.priceLevel,
      this.types,
      this.distance,
      this.underCategory,
      this.lat,
      this.date,
      this.long});
}

class Review {
  String id;
  String userId;
  String friendsCount;
  String userPhoto;
  String userRating;
  String userName;
  String date;
  String userImgUrl;
  String comment;
  double rating;
  String imgUrlForReview;
  int useful;
  int funny;
  int cool;
  bool isUseful = false;
  bool isFunny = false;
  bool isColl = false;

  Review(
      {this.id,
      this.userId,
      this.userName,
      this.date,
      this.userImgUrl,
      this.comment,
      this.rating,
      this.imgUrlForReview,
      this.useful,
      this.funny,
      this.cool,
      this.isUseful = false,
      this.isColl = false,
      this.isFunny = false,
      this.friendsCount,
      this.userPhoto,
      this.userRating});
}

class UserPhotoForSpecificCategory {
  String userId;
  String userImage;
  String userName;
  String date;
  String categoryImage;
  String type;

  UserPhotoForSpecificCategory(
      {this.userId,
      this.userImage,
      this.userName,
      this.type,
      this.date,
      this.categoryImage});
}

class Categorys with ChangeNotifier {
//  final String userId;
//  Categorys(this.userId);
  List<Category> _resturants = [];
  List<Category> nearByResturant = [];
  List<Category> _filterCategory = [];
  List<Category> _categorysForFilters = [];
  List<Review> _listOfReviews = [];
  List<Activities> _listOftivities = [];
  bool _isNavigateFromOtherPage = false;
  double distance = 0.0;

  GoogleMapsPlaces _resturantsOnGoogle =
      GoogleMapsPlaces(apiKey: 'AIzaSyCqOxzWfXHCTM_9ri4eevx7VRvVcKOjH8I');
  String _typeOfCategory = '';
  final databaseReference = Firestore.instance;
  Future<FirebaseUser> firebaseAuth = FirebaseAuth.instance.currentUser();

  List<Category> get resturants {
    return _resturants;
  }

  bool get navigateFromOtherPage {
    return _isNavigateFromOtherPage;
  }

  List<Category> get categoryFiltered {
    return _filterCategory;
  }
  List<Category> get nearByYou {
    return nearByResturant;
  }

  String get typeOfCategory {
    return _typeOfCategory;
  }

  changeNavigate({bool isNavigate, String typeOfCategory}) {
    _isNavigateFromOtherPage = isNavigate;
    _typeOfCategory = typeOfCategory;
  }

  Category findById({String id,bool isCommingFromNearBy =false}) {
    if(isCommingFromNearBy){
  return nearByResturant.firstWhere((rest) => rest.id == id);
  }else{
  return _resturants.firstWhere((rest) => rest.id == id);
  }
  }

  List<Review> get allReviews {
    return _listOfReviews;
  }

  List<Activities> get allActivities {
    return _listOftivities;
  }
//
//  final String detailUrl =
//      "https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyDjj_1MEVHmWBJMVGuGklQOJbeO99CXsEI&placeid=";
//  final String url =
//      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=33.889339,35.476214&radius=1500&type=restaurant&key=AIzaSyDjj_1MEVHmWBJMVGuGklQOJbeO99CXsEI";

//  Future<void> getNearbyyPlaces() async {
//    var reponse = await http.get(url, headers: {"Accept": "application/json"});
//
//    List data = json.decode(reponse.body)["results"];
//    data.forEach((f) {
//      print(f['formatted_phone_number']);
//      print(f['name']);
//    });
//  }
  Future<void> addPhoto(
      {String type = 'users',
      Category resturant,
      File imageFile,
      String comment}) async {
    if (imageFile != null) {
      String userId;
      String imgUrlForCategory;
      _listOftivities.clear();
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }
      String underCategory = resturant.underCategory;
      String productId = resturant.id;
      var mainCollection = databaseReference
          .collection(underCategory)
          .document(productId)
          .collection(type);
      CollectionReference userActivity = databaseReference
          .collection('users')
          .document(userId)
          .collection('activities');
      String date =DateTime.now().toIso8601String();

      // var subCollection = mainCollection.document(productId).collection('photos');
      try {
        var storageReference = FirebaseStorage.instance.ref().child(
            '${resturant.underCategory}/${resturant.id}/${path.basename(imageFile.path)}');
        StorageUploadTask uploadTask = storageReference.putFile(imageFile);
        await uploadTask.onComplete;
        await storageReference.getDownloadURL().then((fileURL) async {
          imgUrlForCategory = fileURL;
          await mainCollection.document().setData({
            'userId': userId,
            'type': type,
            'imgUrlForCategory': imgUrlForCategory.toString(),
            'date': date,
          });
        });
        QuerySnapshot addPhotoId = await mainCollection
            .where('date', isEqualTo: date).where('userId',isEqualTo: userId)
            .getDocuments();
        DocumentSnapshot document =
            await databaseReference.document('users/$userId').get();
        var numOfPhotos = document.data['imageCount'];
        numOfPhotos = numOfPhotos + 1;
        databaseReference
            .document('users/$userId')
            .updateData({'imageCount': numOfPhotos});
        userActivity.document(addPhotoId.documents[0].documentID).setData({
          'userId': userId,
          'placeId': resturant.id,
          'placeName': resturant.name,
          'types': resturant.types,
          'imgUrl': resturant.imgUrl[0],
          'ratingCount': resturant.rating.toString(),
          'phone': resturant.phone,
          'openNow': resturant.openNow,
          'priceLevel': resturant.priceLevel,
          'vicinity': resturant.vicinity,
          'lat': resturant.lat,
          'long': resturant.long,
          'reviewId': addPhotoId.documents[0].documentID,
          'underCategory': resturant.underCategory,
          'date': date,
          'type': 'Photo',
          'imgUrlForReview': imgUrlForCategory.toString(),
        });
      } catch (e) {}
    }
  }

  Future<String> deletePhoto(
      {UserPhotoForSpecificCategory photosForSpecificCategory,
      Category resturant,
      int indexForActivites}) async {
    try {
      String userId;
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }

      String underCategory = resturant.underCategory;
      String productId = resturant.id;
      print(underCategory);
      print(productId);
      print(photosForSpecificCategory.type);
      print(userId);
      CollectionReference mainCollection = databaseReference
          .collection(underCategory)
          .document(productId)
          .collection(photosForSpecificCategory.type);
      QuerySnapshot allDocuments = await databaseReference
          .collection(underCategory)
          .document(productId)
          .collection(photosForSpecificCategory.type)
          .where('date',isEqualTo: photosForSpecificCategory.date).where('userId',isEqualTo: userId)
          .getDocuments();
      print(allDocuments.documents.length);
      String id = allDocuments.documents[0].documentID;
print(id);

      CollectionReference userActivity = databaseReference
          .collection('users')
          .document(userId)
          .collection('activities');
      await mainCollection.document(id).delete();
      await userActivity.document(id).delete();
      DocumentSnapshot documentForFriend =
          await databaseReference.document('users/$userId').get();
      var numOfPhotos = documentForFriend.data['imageCount'];
      numOfPhotos = numOfPhotos - 1;
      await databaseReference
          .document('users/$userId')
          .updateData({'imageCount': numOfPhotos});
      if (indexForActivites != null) {
        _listOftivities.removeAt(indexForActivites);
      } else {
        _listOftivities.clear();
      }
      notifyListeners();
      return 'true';
    } catch (e) {
      return 'false';
    }
  }

  Future<String> checkIn(
      {Category resturant,
      File imageFile,
      String comment,
      String checkInNote = '',
      List<String> idForFriendsTaged}) async {
    if (imageFile != null) {
      String userId;
      String userName;
      String imgUrl = '';
      _listOftivities.clear();
      var n = await firebaseAuth;
      if (n.uid != null) {
        userId = n.uid;
        userName = n.displayName;
      }
      String date =DateTime.now().toIso8601String();
//      String underCategory = resturant.underCategory;
      String categoryId = resturant.id;
////      CollectionReference categoryCollection = databaseReference
////          .collection(underCategory)
////          .document(categoryId)
////          .collection('checkIn');
      CollectionReference userCollection = databaseReference
          .collection('users')
          .document(userId)
          .collection('checkIn');
      CollectionReference userActivity = databaseReference
          .collection('users')
          .document(userId)
          .collection('activities');

      // var subCollection = mainCollection.document(productId).collection('photos');
      try {
        if (imageFile != null) {
          var storageReference = FirebaseStorage.instance.ref().child(
              '${resturant.underCategory}/${resturant.id}/${path.basename(imageFile.path)}');
          StorageUploadTask uploadTask = storageReference.putFile(imageFile);
          await uploadTask.onComplete;
          await storageReference.getDownloadURL().then((fileURL) {
            imgUrl = fileURL;
          });
        }
        if (idForFriendsTaged.isEmpty) {
          idForFriendsTaged.add('');
        }
//        categoryCollection.document().setData({
//          'userId': userId,
//          'imgUrl': imgUrl.toString(),
//          'userName': userName.toString(),
//          'checkInNote': checkInNote.toString(),
//          'countOfFriendsTaged': idForFriendsTaged.length.toString(),
//        });

        userCollection.document().setData({
          'categoryId': categoryId,
          'imgUrl': imgUrl.toString(),
          'userName': userName.toString(),
          'checkInNote': checkInNote.toString(),
          'countOfFriendsTaged': idForFriendsTaged.length.toString(),
          'date': date,
        });
        QuerySnapshot getId = await userCollection
            .where('categoryId', isEqualTo: categoryId)
            .where('date',isEqualTo: date)
            .getDocuments();
        userActivity.document(getId.documents[0].documentID).setData({
          'userId': userId,
          'placeId': resturant.id,
          'placeName': resturant.name,
          'types': resturant.types,
          'imgUrl': resturant.imgUrl.toString(),
          'ratingCount': resturant.rating.toString(),
          'phone': resturant.phone,
          'openNow': resturant.openNow,
          'priceLevel': resturant.priceLevel,
          'vicinity': resturant.vicinity,
          'lat': resturant.lat,
          'long': resturant.long,
          'underCategory': resturant.underCategory,
          'type': 'Check In',
          'ownerId': resturant.ownerId,
          'comment': checkInNote.toString(),
          'imgUrlForReview': imgUrl.toString(),
          'date': date,
        });
        notifyListeners();
        return 'true';
      } catch (e) {
        return 'false';
      }
    } else {
      return 'none';
    }
  }

  Future<String> deleteCheckIn(
      {Review review, Category resturant, int indexForActivites}) async {
    try {
      String userId;
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }
      CollectionReference userCollection = databaseReference
          .collection('users')
          .document(userId)
          .collection('checkIn');
      QuerySnapshot getId = await userCollection
          .where('categoryId', isEqualTo: resturant.id)
          .where('date',isEqualTo: review.date)
          .getDocuments();
      await userCollection.document(getId.documents[0].documentID).delete();
      CollectionReference userActivity = databaseReference
          .collection('users')
          .document(userId)
          .collection('activities');
      await userActivity.document(getId.documents[0].documentID).delete();
      if (indexForActivites != null) {
        _listOftivities.removeAt(indexForActivites);
      } else {
        _listOftivities.clear();
      }
      notifyListeners();
      return 'true';
    } catch (e) {
      return 'false';
    }
  }

  Future<String> startAReview(
      {Category resturant,
      String comment,
      String ratingCount,
      File imageFile}) async {

    if (comment != null || ratingCount.trim() != '0.0' || imageFile != null) {
      String imgUrl = '';
      String userId;
      _listOftivities.clear();
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }
      String underCategory = resturant.underCategory;
      String categoryId = resturant.id;
      CollectionReference categoryCollection = databaseReference
          .collection(underCategory)
          .document(categoryId)
          .collection('comments');
      CollectionReference userActivity = databaseReference
          .collection('users')
          .document(userId)
          .collection('activities');
      // var subCollection = mainCollection.document(productId).collection('photos');

      try {
        if (imageFile != null) {
          var storageReference = FirebaseStorage.instance.ref().child(
              '${resturant.underCategory}/${resturant.id}/${path.basename(imageFile.path)}');
          StorageUploadTask uploadTask = storageReference.putFile(imageFile);
          await uploadTask.onComplete;
          await storageReference.getDownloadURL().then((fileURL) {
            imgUrl = fileURL;
          });
        }
        String date = DateTime.now().toIso8601String();
        categoryCollection.document().setData({
          'userId': userId,
          'imgUrl': imgUrl.toString(),
          'ratingCount': ratingCount.trim().toString(),
          'comment': comment.toString(),
          'date': date,
          'useful': 0,
          'funny': 0,
          'cool': 0,
          'isFunny': false,
          'isCool': false,
          'isUseful': false,
        });
        QuerySnapshot c = await categoryCollection
            .where('userId', isEqualTo: userId)
            .where('date',isEqualTo: date)
            .getDocuments();
        userActivity.document(c.documents[0].documentID).setData({
          'userId': userId,
          'type': 'Review',
          'placeId': resturant.id,
          'placeName': resturant.name,
          'types': resturant.types,
          'imgUrl': resturant.imgUrl[0],
          'ratingCount': resturant.rating.toString(),
          'phone': resturant.phone,
          'openNow': resturant.openNow,
          'priceLevel': resturant.priceLevel,
          'vicinity': resturant.vicinity,
          'lat': resturant.lat,
          'long': resturant.long,
          'reviewId': c.documents[0].documentID,
          'comment': comment.toString(),
          'underCategory': resturant.underCategory,
          'date': date,
          'imgUrlForReview': imgUrl.toString(),
          'ratingFormReview': ratingCount.trim().toString(),
        });

        DocumentSnapshot documentForFriend =
            await databaseReference.document('users/$userId').get();
        var numOfReview = documentForFriend.data['reviewsCount'];
        numOfReview = numOfReview + 1;
        databaseReference
            .document('users/$userId')
            .updateData({'reviewsCount': numOfReview});
        return 'true';
      } catch (e) {
        return 'false';
      }
    } else {
      return 'none';
    }
  }

  Future<String> editAReview(
      {Category resturant,
      Review review,
      String comment,
      String ratingCount,
      File imageFile}) async {

    if (comment != null || ratingCount.trim() != '0.0' || imageFile != null) {
      if (comment == review.comment ||
          ratingCount == review.rating.toString()) {}
      String imgUrl = '';
      String underCategory = resturant.underCategory;
      String categoryId = resturant.id;
      CollectionReference categoryCollection = databaseReference
          .collection(underCategory)
          .document(categoryId)
          .collection('comments');
      try {
        if (imageFile != null) {
          var storageReference = FirebaseStorage.instance.ref().child(
              '${resturant.underCategory}/${resturant.id}/${path.basename(imageFile.path)}');
          StorageUploadTask uploadTask = storageReference.putFile(imageFile);
          await uploadTask.onComplete;
          await storageReference.getDownloadURL().then((fileURL) {
            imgUrl = fileURL;
          });
        }
        CollectionReference userActivity = databaseReference
            .collection('users')
            .document(review.userId)
            .collection('activities');
        String date = DateTime.now().toIso8601String();
        categoryCollection.document(review.id).updateData({
          'imgUrl': imgUrl == '' ? review.imgUrlForReview : imgUrl,
          'ratingCount': ratingCount.trim().toString(),
          'comment': comment.toString(),
          'date': date,
        });
        userActivity.document(review.id).updateData({
          'ratingCountFromUser': ratingCount.trim().toString(),
          'imgUrlForReview': imgUrl.toString(),
          'comment': comment.toString(),
          'date': date,
        });
        return 'true';
      } catch (e) {
        return 'false';
      }
    } else {
      return 'none';
    }
  }

  Future<String> deleteAReview(
      {Category resturant, Review review, int indexForActivites}) async {
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    String underCategory = resturant.underCategory;
    String categoryId = resturant.id;
    CollectionReference userActivity = databaseReference
        .collection('users')
        .document(userId)
        .collection('activities');
    CollectionReference categoryCollection = databaseReference
        .collection(underCategory)
        .document(categoryId)
        .collection('comments');
    try {
      await categoryCollection.document(review.id).delete();
      await userActivity.document(review.id).delete();
      DocumentSnapshot documentForFriend =
          await databaseReference.document('users/$userId').get();
      var numOfReview = documentForFriend.data['reviewsCount'];
      numOfReview = numOfReview - 1;
      databaseReference
          .document('users/$userId')
          .updateData({'reviewsCount': numOfReview});
      if (indexForActivites != null) {
        _listOftivities.removeAt(indexForActivites);
      } else {
        _listOftivities.clear();
      }
      notifyListeners();
      return 'true';
    } catch (e) {
      return 'false';
    }
  }

  Future<int> getAllReviews({Category category}) async {
    int length = 0;
    CollectionReference collection = databaseReference.collection('users');
    DocumentSnapshot document;
    try {
      _listOfReviews.clear();
      var id = await databaseReference
          .collection(category.underCategory)
          .document(category.id)
          .get();
      if (id != null || id.exists) {
        QuerySnapshot doc = await databaseReference
            .collection(category.underCategory)
            .document(category.id)
            .collection('comments')
            .getDocuments();

        if (doc.documents.length >= 1) {
          length = doc.documents.length;
          for (int i = 0; i < doc.documents.length; i++) {
            document = await collection
                .document(doc.documents[i].data['userId'])
                .get();
            _listOfReviews.add(Review(
              id: doc.documents[i].documentID,
              userId: doc.documents[i].data['userId'],
              userImgUrl: document.data['imgUrl'] == null
                  ? ''
                  : document.data['imgUrl'],
              date: doc.documents[i].data['date'],
              friendsCount: document.data['friendsCount'].toString(),
              userPhoto: document.data['imageCount'].toString(),
              userRating: document.data['reviewsCount'].toString(),
              comment: doc.documents[i].data['comment'] == null
                  ? ''
                  : doc.documents[i].data['comment'],
              rating: doc.documents[i].data['ratingCount'] == null
                  ? 0.0
                  : double.parse(doc.documents[i].data['ratingCount']),
              userName: document.data['name'],
              imgUrlForReview: doc.documents[i].data['imgUrl'] == null
                  ? ''
                  : doc.documents[i].data['imgUrl'],
              funny: doc.documents[i].data['funny'] == null
                  ? 0
                  : doc.documents[i].data['funny'],
              useful: doc.documents[i].data['useful'] == null
                  ? 0
                  : doc.documents[i].data['useful'],
              cool: doc.documents[i].data['cool'] == null
                  ? 0
                  : doc.documents[i].data['cool'],
              isColl: doc.documents[i].data['isCool'] == null
                  ? false
                  : doc.documents[i].data['isCool'],
              isFunny: doc.documents[i].data['isFunny'] == null
                  ? false
                  : doc.documents[i].data['isFunny'],
              isUseful: doc.documents[i].data['isUseful'] == null
                  ? false
                  : doc.documents[i].data['isUseful'],
            ));
          }
        }
      }
      return length;
    } catch (e) {
      return length;
    }
  }

  Future<void> getAllActivities({String id = ''}) async {
    String userId;
    CollectionReference collection = databaseReference.collection('users');
    DocumentSnapshot document;
    if (id == '') {
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }
    } else {
      userId = id;
    }
    QuerySnapshot doc = await collection
        .document(userId)
        .collection('activities')
        .getDocuments();
    _listOftivities.clear();
    if (doc.documents.length != 0) {
      double distance = 0.0;

      LatLng currentLocation = Auth().myLatLng;
      if (currentLocation == null) {
        await Auth().getLocation();
        currentLocation = Auth().myLatLng;
      }
      List<String> typ = [];
      for (int i = 0; i < doc.documents.length; i++) {
        typ = [];
        doc.documents[i].data['types'].forEach((x) {
          typ.add(x.toString());
        });
        distance = _calculateDistance(
            currentLocation.latitude,
            currentLocation.longitude,
            doc.documents[i].data['lat'],
            doc.documents[i].data['long']);
        document =
            await collection.document(doc.documents[i].data['userId']).get();
        Activities c = Activities(
          category: Category(
            id: doc.documents[i].data['placeId'],
            rating: doc.documents[i].data['ratingCount'] == null
                ? 0.0
                : double.parse(doc.documents[i].data['ratingCount']),
            distance: distance,
            lat: doc.documents[i].data['lat'],
            long: doc.documents[i].data['long'],
            imgUrl: [doc.documents[i].data['imgUrl']],
            name: doc.documents[i].data['placeName'],
            openNow: doc.documents[i].data['openNow'],
            phone: doc.documents[i].data['phone'],
            priceLevel: doc.documents[i].data['priceLevel'],
            types: typ,
            underCategory: doc.documents[i].data['underCategory'],
            vicinity: doc.documents[i].data['vicinity'],
          ),
          review: Review(
              id: doc.documents[i].data['reviewId'],
              rating: doc.documents[i].data['ratingFormReview'] == null
                  ? 0.0
                  : double.parse(doc.documents[i].data['ratingFormReview']),
              date: doc.documents[i].data['date'],
              comment: doc.documents[i].data['comment'] == null
                  ? ''
                  : doc.documents[i].data['comment'],
              imgUrlForReview: doc.documents[i].data['imgUrlForReview'] == null
                  ? ''
                  : doc.documents[i].data['imgUrlForReview']),
          userName: document.data['name'] ?? '',
          type: doc.documents[i].data['type'] ?? 'Review',
          userId: doc.documents[i].data['userId'],
          userImgUrl:
              document.data['imgUrl'] == null ? '' : document.data['imgUrl'],
          dateForReview: doc.documents[i].data['date'],
        );
        _listOftivities.add(c);
      }
    }
    notifyListeners();

  }

  Future<String> createCollection(
      {Category category,
      String nameOfCollection = '',
      bool isPublic = false,
      bool withoutAddCategory = false}) async {
    if (nameOfCollection != '') {
      try {
        String userId;
        if (Auth.userId == '') {
          userId = await Auth().getUserId;
        } else {
          userId = Auth.userId;
        }
        CollectionReference userCollection = databaseReference
            .collection('users')
            .document(userId)
            .collection('collections');

        if (withoutAddCategory == false) {
          String imgUrl = category.imgUrl.isEmpty
              ? 'https://logisticaas.com.mx/wp-content/uploads/2020/05/placeholder-1.png'
              : category.imgUrl[0];
          await userCollection
              .document(nameOfCollection.trim().toString())
              .setData({
            'nameOfCollection': nameOfCollection.toString(),
            'LastUpdate': DateTime.now().toIso8601String(),
            'categoryImage': imgUrl,
            'countOfCategory': 1,
            'isPublic': isPublic,
          });
          await userCollection
              .document(nameOfCollection.toString())
              .collection(nameOfCollection.toString())
              .document(category.id)
              .setData({
            'categoryImage':
                category.imgUrl.isEmpty ? 'noImage' : category.imgUrl[0],
            'categoryName': category.name.toString(),
            'categoryId': category.id.toString(),
            'rating': category.rating,
            'distance': category.distance,
            'lat': category.lat,
            'long': category.long,
            'phone': category.phone,
            'openNow': category.openNow,
            'priceLevel': category.priceLevel,
            'vicinity': category.vicinity,
            'types': category.types,
            'underCategory': category.underCategory,
            'date': DateTime.now().toString(),
          });
          return 'true';
        } else {
          await userCollection
              .document(nameOfCollection.trim().toString())
              .setData({
            'nameOfCollection': nameOfCollection.toString(),
            'LastUpdate': DateTime.now().toIso8601String(),
            'categoryImage':
                'https://devblog.axway.com/wp-content/uploads/blog-572x320-image-device.png',
            'countOfCategory': 0,
            'isPublic': isPublic,
          });
          return 'specific create';
        }
      } catch (e) {
        return 'false';
      }
    } else {
      return 'none';
    }
  }

  Future<String> addToCollection(
      {Category resturant, String collectionName}) async {
    if (collectionName != null) {
      String userId;
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }
      String underCategory = resturant.underCategory;
      String categoryId = resturant.id;
      // CollectionReference categoryCollection = databaseReference.collection(underCategory).document(categoryId).collection('checkIn');
      CollectionReference userCollection = databaseReference
          .collection('users')
          .document(userId)
          .collection('collections');
      // var subCollection = mainCollection.document(productId).collection('photos');
      try {
//      categoryCollection.document(userId).setData({
//        'imgUrl': imgUrl.toString(),
//        'userName':userName.toString(),
//        'checkInNote': checkInNote.toString(),
//        'countOfFriendsTaged': idForFriendsTaged.length.toString(),
//      });
        DocumentSnapshot id = await userCollection
            .document(collectionName)
            .collection(collectionName)
            .document(categoryId)
            .get();
        if (id == null || !id.exists) {
          DocumentSnapshot x =
              await userCollection.document(collectionName).get();
          int n =
              x.data['countOfCategory'] == null ? 0 : x.data['countOfCategory'];
          n = n + 1;
          if (resturant.imgUrl.isNotEmpty) {
            await userCollection.document(collectionName).updateData({
              'categoryImage': resturant.imgUrl[0],
              'countOfCategory': n,
            });
          } else {
            await userCollection.document(collectionName).updateData({
              'countOfCategory': n,
            });
          }

          await userCollection
              .document(collectionName)
              .collection(collectionName)
              .document(categoryId)
              .setData({
            'categoryName': resturant.name.toString(),
            'underCategory': underCategory.toString(),
            'rating': resturant.rating,
            'openNow': resturant.openNow,
            'priceLevel': resturant.priceLevel.toString(),
            'vicinity': resturant.vicinity,
            'distance': resturant.distance,
            'lat': resturant.lat,
            'long': resturant.long,
            'phone': resturant.phone.toString(),
            'types': resturant.types,
            'categoryImage':
                resturant.imgUrl.isEmpty ? 'noImage' : resturant.imgUrl[0],
            'categoryId': categoryId.toString(),
            'date': DateTime.now().toString(),
          });
          return 'true';
        } else {
          return 'already exits';
        }
      } catch (e) {
        return 'false';
      }
    } else {
      return 'none';
    }
  }

  Future<bool> removeCollection({String collectionName}) async {
    try {
      String userId;
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }

      CollectionReference userCollection = databaseReference
          .collection('users')
          .document(userId)
          .collection('collections');
      userCollection.document(collectionName.toString()).delete();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<DocumentSnapshot>> getAllCollections() async {
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    QuerySnapshot doc = await databaseReference
        .collection('users')
        .document(userId)
        .collection('collections')
        .getDocuments();
    return doc.documents.toList();
  }

  Future<List<CollectionForFriend>> getAllCollectionsForFriend(
      {String userId = ''}) async {
    List<CollectionForFriend> _list = [];
    String myId;
    if (Auth.userId == '') {
      myId = await Auth().getUserId;
    } else {
      myId = Auth.userId;
    }
    QuerySnapshot doc = await databaseReference
        .collection('users')
        .document(userId)
        .collection('collections')
        .where('isPublic', isEqualTo: true)
        .getDocuments();
    if (doc.documents.length != 0) {
      for (int i = 0; i < doc.documents.length; i++) {
        bool isFollwing = false;
        DocumentSnapshot followingCollections = await databaseReference
            .collection('users')
            .document(myId)
            .collection('FollowingCollections')
            .document(doc.documents[i].documentID)
            .get();
        if (followingCollections.exists && followingCollections != null) {
          isFollwing = true;
        }
        _list.add(CollectionForFriend(
            friendId: userId,
            collectionId: doc.documents[i].documentID,
            lastUpdate: doc.documents[i].data['LastUpdate'],
            imgUrlForCollection: doc.documents[i].data['categoryImage'],
            countOfCategory: doc.documents[i].data['countOfCategory'],
            collectionName: doc.documents[i].data['nameOfCollection'],
            isPublic: doc.documents[i].data['isPublic'],
            isMeFollowing: isFollwing));
      }
    }
    return _list;
  }

  Future<List<CollectionForFriend>> getAllFollowingCollections(
      {String friendId}) async {
    List<CollectionForFriend> _list = [];
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    QuerySnapshot doc = await databaseReference
        .collection('users')
        .document(userId)
        .collection('FollowingCollections')
        .getDocuments();
    if (doc.documents.length != 0) {
      for (int i = 0; i < doc.documents.length; i++) {
        DocumentSnapshot friendCollection = await databaseReference
            .collection('users')
            .document(doc.documents[i].data['friendId'])
            .collection('collections')
            .document(doc.documents[0].data['collectionId'])
            .get();
//        bool isFollwing =false;
//    DocumentSnapshot x= await databaseReference
//        .collection('users')
//        .document(userId)
//        .collection('FollowingCollections').document(doc.documents[i].documentID).get();
//    if(x.exists && x!=null){
//    isFollwing=true;
//    }
        _list.add(CollectionForFriend(
            friendId: doc.documents[i].data['friendId'],
            collectionId: friendCollection.documentID,
            lastUpdate: friendCollection.data['LastUpdate'],
            imgUrlForCollection: friendCollection.data['categoryImage'],
            countOfCategory: friendCollection.data['countOfCategory'],
            collectionName: friendCollection.data['nameOfCollection'],
            isPublic: friendCollection.data['isPublic'],
            isMeFollowing: true));
      }
    }
    return _list;
  }

  Future<bool> addToFollowingCollections({
    String collectionId,
    String friendId,
  }) async {
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    try {
      await databaseReference
          .collection('users')
          .document(userId)
          .collection('FollowingCollections')
          .document(collectionId)
          .setData({
        'collectionId': collectionId,
        'friendId': friendId,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFromFollowingCollections({
    String collectionId,
  }) async {
    String userId;
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    try {
      await databaseReference
          .collection('users')
          .document(userId)
          .collection('FollowingCollections')
          .document(collectionId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }


  Future<bool> removePlaceFromCollection(
      {String collectionName, String categoryId, List<String> img}) async {
    try {
      String userId;
      if (Auth.userId == '') {
        userId = await Auth().getUserId;
      } else {
        userId = Auth.userId;
      }
      CollectionReference userCollection = databaseReference
          .collection('users')
          .document(userId)
          .collection('collections');
      DocumentSnapshot x = await userCollection.document(collectionName).get();
      int n = x.data['countOfCategory'];
      n = n - 1;
      String imgUrl = x.data['categoryImage'];
      if (img.isNotEmpty) {
        if (imgUrl == img[0]) {
          await userCollection.document(collectionName).updateData({
            'categoryImage':
                'https://devblog.axway.com/wp-content/uploads/blog-572x320-image-device.png',
            'countOfCategory': n,
          });
        }
      } else {
        await userCollection.document(collectionName).updateData({
          'countOfCategory': n,
        });
      }
      userCollection
          .document(collectionName)
          .collection(collectionName)
          .document(categoryId)
          .delete();
      return true;
    } catch (_) {
      return false;
    }
  }

  double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  double rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    // try {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    return dist * 1.609344;
//  }catch (_){
//    var p = 0.017453292519943295;
//    var c = cos;
//    var a = 0.5 -
//        c((lat2 - lat1) * p) / 2 +
//        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//    return 12742 * asin(sqrt(a));
//  }
  }

  Future<List<Category>> getCategorysForSpecificCollection(
      {String collectionName, String id}) async {
    List<Category> _listOfCaterory = [];
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
    QuerySnapshot doc = await databaseReference
        .collection('users')
        .document(userId)
        .collection('collections')
        .document(collectionName.toString())
        .collection(collectionName.toString())
        .getDocuments();
    for (int i = 0; i < doc.documents.length; i++) {
      List<String> typ = [];
      doc.documents[i].data['types'].forEach((x) {
        typ.add(x.toString());
      });
      bool isGet = await Auth().getLocation();
      double dist = 0.0;
      if (isGet) {
        LatLng currentLocation = Auth().myLatLng;
        dist = _calculateDistance(
            currentLocation.latitude,
            currentLocation.longitude,
            doc.documents[i].data['lat'],
            doc.documents[i].data['long']);
      }
      _listOfCaterory.add(Category(
          id: doc.documents[i].data['categoryId'],
          rating: doc.documents[i].data['rating'],
          imgUrl: [doc.documents[i].data['categoryImage']],
          vicinity: doc.documents[i].data['vicinity'],
          long: doc.documents[i].data['lat'],
          lat: doc.documents[i].data['long'],
          distance: dist,
          phone: doc.documents[i].data['phone'] == null
              ? ''
              : doc.documents[i].data['phone'],
          priceLevel: doc.documents[i].data['priceLevel'] == ''
              ? ''
              : doc.documents[i].data['priceLevel'],
          types: typ,
          openNow: doc.documents[i].data['openNow'],
          name: doc.documents[i].data['categoryName'] ?? '',
          underCategory: doc.documents[i].data['underCategory'],
          date: doc.documents[i].data['date']));
    }
    return _listOfCaterory;
  }

  Future<void> updateTransactionsForCategory(
      {Review review, Category category, String type}) async {
    final databaseReference = Firestore.instance;
    CollectionReference categoryCollection = databaseReference
        .collection(category.underCategory)
        .document(category.id)
        .collection('comments');
    QuerySnapshot x = await categoryCollection
        .where('userId', isEqualTo: review.userId)
        .where('date', isEqualTo: review.date)
        .getDocuments();
    String documentPath = x.documents[0].documentID;
    int usefulNum = x.documents[0]['useful'];
    int coolNum = x.documents[0]['cool'];
    int funnyNum = x.documents[0]['funny'];
    if (type == 'useful') {
      review.isUseful = !review.isUseful;
      if (review.isUseful) {
        usefulNum = usefulNum + 1;
      } else {
        if (usefulNum > 0) {
          usefulNum = usefulNum - 1;
        }
      }
      if (x.documents[0]['isCool']) {
        coolNum = coolNum - 1;
        review.isColl = false;
        review.cool = coolNum;
      }
      if (x.documents[0]['isFunny']) {
        funnyNum = funnyNum - 1;
        review.isFunny = false;
        review.funny = funnyNum;
      }
      review.useful = usefulNum;
      review.isColl = false;
      review.isFunny = false;
      databaseReference
          .collection(category.underCategory)
          .document(category.id)
          .collection('comments')
          .document(documentPath)
          .updateData({
        'useful': usefulNum,
        'isUseful': review.isUseful,
        'cool': coolNum,
        'isCool': false,
        'funny': funnyNum,
        'isFunny': false,
      });
    } else if (type == 'cool') {
      review.isColl = !review.isColl;
      if (review.isColl) {
        coolNum = coolNum + 1;
      } else {
        if (coolNum > 0) {
          coolNum = coolNum - 1;
        }
      }
      if (x.documents[0]['isFunny']) {
        funnyNum = funnyNum - 1;
        review.isFunny = false;
        review.funny = funnyNum;
      }
      if (x.documents[0]['isUseful']) {
        usefulNum = usefulNum - 1;
        review.isUseful = false;
        review.useful = usefulNum;
      }
      review.cool = coolNum;
      databaseReference
          .collection(category.underCategory)
          .document(category.id)
          .collection('comments')
          .document(documentPath)
          .updateData({
        'cool': coolNum,
        'isCool': review.isColl,
        'funny': funnyNum,
        'isFunny': false,
        'useful': usefulNum,
        'isUseful': false,
      });
    } else {
      review.isFunny = !review.isFunny;
      if (review.isFunny) {
        funnyNum = funnyNum + 1;
      } else {
        if (funnyNum > 0) {
          funnyNum = funnyNum - 1;
        }
      }

      if (x.documents[0]['isCool']) {
        coolNum = coolNum - 1;
        review.isColl = false;
        review.cool = coolNum;
      }
      if (x.documents[0]['isUseful']) {
        usefulNum = usefulNum - 1;
        review.isUseful = false;
        review.useful = usefulNum;
      }
      review.funny = funnyNum;
      databaseReference
          .collection(category.underCategory)
          .document(category.id)
          .collection('comments')
          .document(documentPath)
          .updateData({
        'funny': funnyNum,
        'isFunny': review.isFunny,
        'useful': usefulNum,
        'isUseful': false,
        'cool': coolNum,
        'isCool': false,
      });
    }
    notifyListeners();
  }

  void filterPlaces(
      {List<String> price,
      double distance = 0.0,
      double rating = 0.0,
      String openNow}) {
    _filterCategory.clear();

    List<Category> cat = [];
    if (price.length > 0 &&
        distance != 0.0 &&
        rating != 0.0 &&
        openNow != 'false') {

      _filterCategory
          .addAll(_categorysForFilters.where((x) => x.distance <= distance));

      cat.addAll(_filterCategory.where((x) => x.openNow == openNow));


      _filterCategory.clear();
      for (int i = 0; i < cat.length; i++) {

        for (int n = 0; n < price.length; n++) {

          if (cat[i].priceLevel == price[n]) {
            _filterCategory.add(cat[i]);
          }
        }
      }

      _filterCategory.sort((a, b) => b.rating.compareTo(a.rating));
    }
    if (distance != 0.0 &&
        price.length == 0 &&
        rating == 0.0 &&
        openNow == 'false') {

      _filterCategory
          .addAll(_categorysForFilters.where((x) => x.distance <= distance));
    }
    if (rating != 0.0 &&
        price.length == 0 &&
        distance == 0.0 &&
        openNow == 'false') {

      _filterCategory.addAll(_categorysForFilters);
      _filterCategory.sort((a, b) => b.rating.compareTo(a.rating));
    }
    if (openNow != 'false' &&
        price.length == 0 &&
        distance == 0.0 &&
        rating == 0.0) {

      _filterCategory
          .addAll(_categorysForFilters.where((x) => x.openNow == openNow));
    }
    if (openNow == 'false' &&
        price.length > 0 &&
        distance == 0.0 &&
        rating == 0.0) {

      for (int i = 0; i < _categorysForFilters.length; i++) {
        for (int n = 0; n < price.length; n++) {
          if (_categorysForFilters[i].priceLevel == price[n]) {
            _filterCategory.add(_categorysForFilters[i]);
          }
        }
      }
    }
    if (price.length > 0 &&
        openNow != 'false' &&
        distance == 0 &&
        rating == 0) {

      for (int i = 0; i < _categorysForFilters.length; i++) {
        for (int n = 0; n < price.length; n++) {
          if (_categorysForFilters[i].priceLevel == price[n]) {
            _filterCategory.add(_categorysForFilters[i]);
          }
        }
      }
      _filterCategory
          .addAll(_categorysForFilters.where((x) => x.openNow == openNow));
    }
    if (price.length != 0 &&
        distance != 0 &&
        openNow == 'false' &&
        rating == 0) {

      cat.clear();
      for (int i = 0; i < _categorysForFilters.length; i++) {
        for (int n = 0; n < price.length; n++) {
          if (_categorysForFilters[i].priceLevel == price[n]) {
            cat.add(_categorysForFilters[i]);
          }
        }
      }
      _filterCategory.addAll(cat.where((x) => x.distance <= distance));
    }
    if (price.length != 0 &&
        openNow == 'false' &&
        distance == 0 &&
        rating != 0) {

      for (int i = 0; i < _categorysForFilters.length; i++) {
        for (int n = 0; n < price.length; n++) {
          if (_categorysForFilters[i].priceLevel == price[n]) {
            _filterCategory.add(_categorysForFilters[i]);
          }
        }
      }
      _filterCategory.sort((a, b) => b.rating.compareTo(a.rating));
    }

    if (openNow != 'false' &&
        price.length == 0 &&
        distance != 0 &&
        rating == 0) {

      cat.clear();
      cat.addAll(_categorysForFilters.where((x) => x.openNow == openNow));
      _filterCategory.addAll(cat.where((x) => x.distance <= distance));
    }
    if (openNow != 'false' &&
        price.length == 0 &&
        distance == 0 &&
        rating != 0) {

      _filterCategory
          .addAll(_categorysForFilters.where((x) => x.openNow == openNow));
      _filterCategory.sort((a, b) => b.rating.compareTo(a.rating));
    }
    if (openNow == 'false' &&
        price.length == 0 &&
        distance != 0 &&
        rating != 0) {

      _filterCategory
          .addAll(_categorysForFilters.where((x) => x.distance <= distance));
      _filterCategory.sort((a, b) => b.rating.compareTo(a.rating));
    }
    if (price.length != 0 &&
        openNow != 'false' &&
        distance != 0 &&
        rating == 0) {

      cat.clear();
      for (int i = 0; i < _categorysForFilters.length; i++) {
        for (int n = 0; n < price.length; n++) {
          if (_categorysForFilters[i].priceLevel == price[n]) {
            _filterCategory.add(_categorysForFilters[i]);
          }
        }
      }
      cat.addAll(_filterCategory.where((x) => x.openNow == openNow));
      _filterCategory.clear();
      _filterCategory.addAll(cat.where((x) => x.distance <= distance));
    }
    if (price.length != 0 &&
        openNow == 'false' &&
        distance != 0 &&
        rating != 0) {

      cat.clear();
      for (int i = 0; i < _categorysForFilters.length; i++) {
        for (int n = 0; n < price.length; n++) {
          if (_categorysForFilters[i].priceLevel == price[n]) {
            cat.add(_categorysForFilters[i]);
          }
        }
      }
      _filterCategory.addAll(cat.where((x) => x.distance <= distance));
      _filterCategory.sort((a, b) => b.rating.compareTo(a.rating));
    }
    if (price.length != 0 &&
        openNow != 'false' &&
        distance == 0 &&
        rating != 0) {

      cat.clear();
      for (int i = 0; i < _categorysForFilters.length; i++) {
        for (int n = 0; n < price.length; n++) {
          if (_categorysForFilters[i].priceLevel == price[n]) {
            cat.add(_categorysForFilters[i]);
          }
        }
      }
      _filterCategory.addAll(cat.where((x) => x.openNow == openNow));
      _filterCategory.sort((a, b) => b.rating.compareTo(a.rating));
    }
    if (price.length == 0 &&
        openNow != 'false' &&
        distance != 0 &&
        rating != 0) {
      cat.clear();
      cat.addAll(_categorysForFilters.where((x) => x.distance > distance));
      _filterCategory.addAll(cat.where((x) => x.openNow == openNow));
      _filterCategory.sort((a, b) => b.rating.compareTo(a.rating));
    }
    _resturants = _filterCategory;
    notifyListeners();
  }

  Future<List<Category>> getNearbyPlaces(
      {String type, LatLng currentLocation, double radius = 2000,bool isCommingFromNearby=false}) async {
    try {
      List<Category> _rest = [];

      final location =
          Location(currentLocation.latitude, currentLocation.longitude);
      QuerySnapshot places =
      await databaseReference.collection('places').getDocuments();
      if (places.documents.length != 0) {
        for (int i = 0; i < places.documents.length; i++) {
          DocumentSnapshot place = await databaseReference
              .document('users/${places.documents[i].data['userId']}')
              .collection('shop')
              .document(places.documents[i].documentID)
              .get();
          String list =place.data['typeOfServices'];
          List<String> types = list.split(',');
          distance = _calculateDistance(
              currentLocation.latitude,
              currentLocation.longitude,
              double.parse(place.data['lat']),
              double.parse(place.data['lng']));
          if (distance <= radius && place.data['bussinessCategory'] == type) {
            List<String> start = place.data['startTime'].split(':');
            List<String> end = place.data['endTime'].split(':');
            DateTime timeNow = DateTime.now();
            timeNow = timeNow.toLocal();
            print(timeNow);
            print(start[0].runtimeType);
            print(end);
            bool isOpen=false;
            if (timeNow.hour >= int.parse(start[0]) &&
                timeNow.hour <= int.parse(end[0])) {
              isOpen =true;
            }
            print(place.data['businessName']);
            _rest.add(Category(
              id: places.documents[i].documentID,
              name: place.data['businessName'],
              rating: 0.0,
              openNow: isOpen.toString(),
              types: types != null
                  ? types
                  : [],
              underCategory: place.data['bussinessCategory'],
              distance: distance,
              priceLevel: place.data['priceLevel'] != null
                  ? place.data['priceLevel']
                  : '',
              imgUrl: place.data['imgUrl'] != null ? [place.data['imgUrl']] : [],
              phone: place.data['businessPhone'],
              vicinity: place.data['businessAddress'] != null
                  ? place.data['businessAddress']
                  : '',
              lat: double.parse(place.data['lat']),
              long: double.parse(place.data['lng']),
              ownerId: place.data['userId'],
            ));
          }
        }
      }
      final result = await _resturantsOnGoogle
          .searchNearbyWithRadius(location, radius, type: type.trim());
     print(result.results);
      if (result.status == 'OK') {
        if (result.results != null) {
          result.results.forEach((rest) async {
            List<String> imgUrl = List<String>();
            if (rest.photos != null) {
              List<Photo> ref = rest.photos;
              if (ref.length == 1) {
                ref.forEach((url) {
                  var img =
                      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${url.photoReference}&key=AIzaSyCqOxzWfXHCTM_9ri4eevx7VRvVcKOjH8I';
                  imgUrl.add(img);
                });
              }
            }
            distance = _calculateDistance(
                currentLocation.latitude,
                currentLocation.longitude,
                rest.geometry.location.lat,
                rest.geometry.location.lng);
            _rest.add(Category(
              id: rest.id != null ? rest.id : '',
              name: rest.name != null ? rest.name : '',
              rating: rest.rating != null ? rest.rating * 1.0 : 0.0,
              openNow: rest.openingHours != null
                  ? rest.openingHours.openNow != null
                      ? rest.openingHours.openNow.toString()
                      : 'none'
                  : 'none',
              types: rest.types != null ? rest.types : [],
              underCategory: type,
              distance: distance,
              priceLevel:
                  rest.priceLevel != null ? rest.priceLevel.toString() : '',
              imgUrl: imgUrl != null ? imgUrl : [],
              phone: '',
              vicinity: rest.vicinity != null ? rest.vicinity : '',
              lat: rest.geometry.location.lat,
              long: rest.geometry.location.lng,
            ));
          });
        }
      }
      if (radius != 2000) {
        _categorysForFilters.clear();
        _categorysForFilters = _rest;
      }
      if (isCommingFromNearby==true) {
        nearByResturant = _rest;
        _resturants =_rest;
        return _resturants;
      }else{
        _resturants = _rest;
        notifyListeners();
        return _resturants;
      }
    } catch (e) {
      notifyListeners();
      return [];
    }
  }
}
