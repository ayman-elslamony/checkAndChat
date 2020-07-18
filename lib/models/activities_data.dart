import 'package:checkandchat/Providers/resturants.dart';

class Activities{

  String userId;
  String userName;
  String userImgUrl;
  String type;
  String name;
  String dateForReview;
  Category category;
  Review review;

  Activities({this.review,this.userId, this.userName, this.userImgUrl, this.name,this.type,
    this.dateForReview, this.category});
//  String id;
//  double rating;
//  List<String> imgUrl;
//  List<String> types;
//  String phone;
//  String openNow;
//  String priceLevel;
//  String vicinity;
//  double lat;
//  double long;
//  String underCategory;
//  double distance;
//
//  String ownerId;

}