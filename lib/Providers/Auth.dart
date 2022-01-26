import 'dart:convert';

import 'package:checkandchat/Providers/user_data.dart';
import 'package:checkandchat/models/http_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  var firebaseAuth = FirebaseAuth.instance;
  UserData _userData=UserData();
  static String _token;
  static String userId='';
  static String _address;
  static LatLng _currentLatLng;
String signInType='';
  final databaseReference = Firestore.instance;
bool get isAuth {
    try{
      firebaseAuth.currentUser().then((user){
        if(user != null){
          user.getIdToken().then(
                  (token){
                _token =token.token;
              }
          );
        }
        });
      return _token != null;
    }catch (e){
      return _token == null;
    }
  }
String  getToken(){
  print(_token);
  return _token;
}
LatLng get myLatLng{
  return _currentLatLng;
}
String get myAddress{
  return _address;
}
  Future<bool> getLocation() async {
  print('her i get location');
  // final prefs = await SharedPreferences.getInstance();
  // _currentLatLng =LatLng(23.8859425, 45.0791626);
  //       _address='المملكة العربية السعودية';
  // if(_currentLatLng != null && _address !=null){
  //   final userLocation =json.encode({
  //     'LatLng': _currentLatLng,
  //     'address': _address,
  //   });
  //   prefs.setString('userLocation', userLocation);
  // }
  // print('from try if :$_address : $_currentLatLng');
  // //notifyListeners();
  // var users = databaseReference.collection("users");
  // await userId.then((id){
  //   users.document(id).updateData({
  //     'address': _address,
  //   });
  // });
  // return true;
   final prefs = await SharedPreferences.getInstance();
   try{
     Position position = await Geolocator()
         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     _currentLatLng = LatLng(position.latitude,position.longitude);
     var addresses =
     await placemarkFromCoordinates(position.latitude,position.longitude);
    String first = addresses.first.street;
     //,${first[1]},${first[(first.length-1)]}
     //String add = '${first[0]}';
     _address =first;

     if(_currentLatLng != null && _address !=null){
       final userLocation =json.encode({
         'LatLng': _currentLatLng,
         'address': _address,
       });
       prefs.setString('userLocation', userLocation);
     }
     print('from try if :$_address : $_currentLatLng');
     //notifyListeners();
     var users = databaseReference.collection("users");
     if(userId ==''){
       await getUserId.then((id){
         users.document(id).updateData({
           'address': _address,
         });
       });
     }else{
       users.document(userId).updateData({
         'address': _address,
       });
     }

     return true;
   }catch (e){
     if(!prefs.containsKey('userLocation')){
       _currentLatLng =LatLng(23.8859425, 45.0791626);
       _address='المملكة العربية السعودية';
       final userLocation =json.encode({
         'LatLng': _currentLatLng,
         'address': _address,
       });
       prefs.setString('userLocation', userLocation);
       print('from catch if:$_address : $_currentLatLng');
       // notifyListeners();
       var users = databaseReference.collection("users");
       if(userId ==''){
         await getUserId.then((id){
           users.document(id).updateData({
             'address': _address,
           });
         });
       }else{
         users.document(userId).updateData({
           'address': _address,
         });
       }
       return false;
     }else{
       print('else');
       final userLocation = await json.decode( prefs.getString('userLocation')) as Map<String, Object>;
       print('.......${userLocation['LatLng']}');
       print('.......${userLocation['address']}');
       _currentLatLng = userLocation['LatLng'];
       _address = userLocation['address'];
       print('from catch else :$_address : $_currentLatLng');
       var users = databaseReference.collection("users");
       if(userId ==''){
         await getUserId.then((id){
           users.document(id).updateData({
             'address': _address,
           });
         });
       }else{
         users.document(userId).updateData({
           'address': _address,
         });
       }
     return false;
     }
   }
}

  Future<String> get getUserId async{
    var user= await firebaseAuth.currentUser();
    if(user.uid !=null){
      return user.uid;
    }else{
      return null;
    }
  }

Future<bool> tryToLogin() async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('signInUsingFBorG')) {
        final dataToSignIn =
        await json.decode(prefs.getString('signInUsingFBorG')) as Map<String, Object>;
        if(dataToSignIn['isSignInUsingFaceBook'] == true){
          await signInUsingFBorG('FB').then((x){
            if(x){
              signInType='signInUsingFBorG';
            }
          });
        }
        if(dataToSignIn['isSignInUsingGoogle'] == true){
          await signInUsingFBorG('G').then((x){
            if(x){
              signInType='signInUsingFBorG';
            }
          });
        }

      }
      if (prefs.containsKey('signInUsingEmail')) {
        final dataToSignIn =
        await json.decode(prefs.getString('signInUsingEmail')) as Map<String, Object>;
        await firebaseAuth.signInWithEmailAndPassword(email: dataToSignIn['email'], password: dataToSignIn['password']).then((_){
            signInType='signInUsingEmail';
        });
      }
      if(prefs.containsKey('userLocation')){
        final userLocation = await json.decode( prefs.getString('userLocation')) as Map<String, Object>;
        _currentLatLng = userLocation['LatLng'];
        _address = userLocation['address'];
      }
      if(_token ==null){
        await firebaseAuth.currentUser().then((user) {
          if (user != null) {
            user.getIdToken().then(
                    (token) {
                  _token = token.token;
                }
            );
          }
        });
      }

      if(signInType == 'signInUsingFBorG'){
        return true;
      }else if(signInType =='signInUsingEmail'){
        return true;
      }else{
        return false;
      }
  }

  createAccount({String name,String email,String imgUrl,String id,bool isSignUsingEmail=false})async{
    if(isSignUsingEmail){
     await _userData.createRecord(userId: id,userData: UserData(email: email,name: name,imgUrl: imgUrl));
    }else{
      await _userData.createRecord(userId: id,userData: UserData(email: email,name: name,imgUrl: imgUrl));
    }
  }
 Future<bool> signInUsingEmail({String email,String password})async{
   AuthResult auth;
  try{
    auth= await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      if(auth != null){
        userId =auth.user.uid;
        final prefs = await SharedPreferences.getInstance();
        final _signInUsingEmail =json.encode({
          'email': email,
          'password': password,
        });
        prefs.setString('signInUsingEmail', _signInUsingEmail);

      }
      notifyListeners();
      return true;
    }catch (e) {
     throw HttpException(e.code);
    }
  }
  Future<bool> signUpUsingEmail({String name,String imgUrl,String email,String password})async{
    try{
      var auth = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(auth != null){
        userId=auth.user.uid;
        await createAccount(id: auth.user.uid,name: name,email: email,imgUrl: imgUrl,isSignUsingEmail: true);
        final prefs = await SharedPreferences.getInstance();
        final _signInUsingEmail =json.encode({
          'email': email,
          'password': password,
        });
        prefs.setString('signInUsingEmail', _signInUsingEmail);
      }
      notifyListeners();
      return true;
    }catch (e) {
      throw HttpException(e.code);
    }
  }

  Future<bool> signInUsingFBorG(String type) async {
    final prefs = await SharedPreferences.getInstance();
   try{
     switch (type) {
     case "FB":
       FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
       final accessToken = facebookLoginResult.accessToken.token;
       if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
         final facebookAuthCred =
         FacebookAuthProvider.getCredential(accessToken: accessToken);
         final user =
         await firebaseAuth.signInWithCredential(facebookAuthCred);
         userId =user.user.uid;
//         email: googleSignIn.currentUser.email,
//    name: googleSignIn.currentUser.displayName,
//    profilePicURL: googleSignIn.currentUser.photoUrl,
//    gender: await getGender()
         FacebookLogin facebookLogin = FacebookLogin();
         //user.additionalUserInfo.profile.
         //createAccount(imgUrl: ,name: user.user.displayName,email: user.user.email,id: user.user.uid)
         print("User : " + user.user.displayName);
         final _signInUsingFBorG =json.encode({
           'isSignInUsingFaceBook':true,
           'isSignInUsingGoogle':false,
         });
         prefs.setString('signInUsingFBorG', _signInUsingFBorG);
       //  notifyListeners();
         return true;
       } else
         //notifyListeners();
         return false;
       break;
     case "G":
       try {
         GoogleSignInAccount googleSignInAccount = await _handleGoogleSignIn();
         final googleAuth = await googleSignInAccount.authentication;
         final googleAuthCred = GoogleAuthProvider.getCredential(
             idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
         final user = await firebaseAuth.signInWithCredential(googleAuthCred);
         userId =user.user.uid;
         await createAccount(imgUrl: user.user.photoUrl,name: user.user.displayName,email: user.user.email,id: user.user.uid);
         final _signInUsingFBorG =json.encode({
           'isSignInUsingFaceBook':false,
           'isSignInUsingGoogle':true,
         });
         prefs.setString('signInUsingFBorG', _signInUsingFBorG);
         return true;
       } catch (error) {
         return false;
       }
   }

   }catch (e){
     return false;
   }
  }


  Future<FacebookLoginResult> _handleFBSignIn() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
    await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        print("Logged In");
        break;
    }
    return facebookLoginResult;
  }
  Future<GoogleSignInAccount> _handleGoogleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    return googleSignInAccount;
  }
  Future<bool> logout() async {
 try{
   firebaseAuth.signOut();
   _token = null;
   userId = null;
   final prefs = await SharedPreferences.getInstance();
   prefs.clear();

   return true;
 }catch(e){
   notifyListeners();
   return false;
 }

  }
}