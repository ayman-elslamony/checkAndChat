  
import 'package:checkandchat/Providers/resturants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListOfPhotos with ChangeNotifier {
  List<UserPhotoForSpecificCategory> _allPhotosForSpecificCategory=[];
  List<UserPhotoForSpecificCategory> _allOwnerPhotosForSpecificCategory=[];
  List<UserPhotoForSpecificCategory> _allOwnerPhotosFromCollectionForSpecificCategory=[];
  List<UserPhotoForSpecificCategory> _userPhotoForSpecificCategory=[];
  int all=0;
  int fromOwner=0;
  int fromUser=0;
  Future<List<UserPhotoForSpecificCategory>> _getPhotoForSpecificCategory({String type='users',Category category})async{
    final databaseReference = Firestore.instance;
    List<UserPhotoForSpecificCategory> _userPhotoForSpecificCategory =[];
    QuerySnapshot doc =await databaseReference.collection(category.underCategory).document(
        category.id).collection(type).getDocuments();
    for(int i=0;i<doc.documents.length; i++){
      DocumentSnapshot userData= await databaseReference.document('users/${doc.documents[i].data['userId']}').get();
      _userPhotoForSpecificCategory.add(UserPhotoForSpecificCategory(
        date: doc.documents[i].data['date'],
        userName: userData.data['name'],
        userId: doc.documents[i].data['userId'],
        type:doc.documents[i].data['type'],
        categoryImage: doc.documents[i].data['imgUrlForCategory'],
        userImage:userData.data['imgUrl'],
      ));
    }
    return _userPhotoForSpecificCategory;
  }
  Future<bool> preparingAllPhoto({Category category})async{
    _allOwnerPhotosForSpecificCategory.clear();
    _allOwnerPhotosFromCollectionForSpecificCategory.clear();
    _allPhotosForSpecificCategory.clear();
    _userPhotoForSpecificCategory.clear();
    try{
      if(category.imgUrl.length != 0){
        for(int i =0; i<category.imgUrl.length; i++){
          print(i);
          _allOwnerPhotosForSpecificCategory.add(UserPhotoForSpecificCategory(
            categoryImage: category.imgUrl[i],
            userImage: '',
            userId: '',
            userName: '',
            type: '',
            date: '',
          ));
        }
      }

          _allOwnerPhotosFromCollectionForSpecificCategory=await _getPhotoForSpecificCategory(type: 'owner',category: category);
      _allOwnerPhotosForSpecificCategory.addAll(_allOwnerPhotosFromCollectionForSpecificCategory);
      _allPhotosForSpecificCategory.addAll(_allOwnerPhotosForSpecificCategory);
      _userPhotoForSpecificCategory = await _getPhotoForSpecificCategory(category: category);
      if(_userPhotoForSpecificCategory.length != 0){
        _allPhotosForSpecificCategory.addAll(_userPhotoForSpecificCategory);
      }
      all = category.imgUrl.length + _userPhotoForSpecificCategory.length;
      fromOwner = category.imgUrl.length;
      fromUser = _userPhotoForSpecificCategory.length;
      print('owner $_allOwnerPhotosForSpecificCategory');
      print(_userPhotoForSpecificCategory);
      print(_allPhotosForSpecificCategory);
      return true;
    }catch (e){
      return false;
    }
  }
  List<UserPhotoForSpecificCategory> getPhotos({String listType}) {
    if(listType=='All'){
      return _allPhotosForSpecificCategory;
    }else if(listType == 'Owner'){
      return _allOwnerPhotosForSpecificCategory;
    }else{
      return _userPhotoForSpecificCategory;
    }

  }

  int photosCount({String listType}){
    if(listType=='All'){
      return _allPhotosForSpecificCategory.length;
    }else if(listType == 'Owner'){
      return _allOwnerPhotosForSpecificCategory.length;
    }else{
      return _userPhotoForSpecificCategory.length;
    }
  }

}