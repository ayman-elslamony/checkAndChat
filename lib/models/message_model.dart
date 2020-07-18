
import 'package:checkandchat/Providers/user_data.dart';

import '../models/user_model.dart';

class Message {
  UserData senderdata;  
  String id;
  String friendId;
  String name;
  final String time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  bool isLiked=false;
   bool unread;

  Message({
    
    this.friendId,
   this.id,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
    this.senderdata,
  });
}

class Recentchat{
  UserData userdata;
  final String time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  bool unread;

  Recentchat({
    this.userdata,
    this.time,
    this.text,
    this.unread
  });
}
List<Message> chats = [];

List<Message> messages = [];


// YOU - current user
// final User currentUser = User(
//   id: 0,
//   name: 'Current User',
//   imageUrl: 'assets/images/greg.jpg',
// );

// USERS
// final User megz1 = User(
//   id: 1,
//   name: 'Ahmed Magdy',
//   imageUrl: 'images/ahmed.jpg',
// );
// final User megz2 = User(
//   id: 2,
//   name: 'Mohamed Ragab',
//   imageUrl: 'images/BradPitt.jpg',
// );
// final User megz3 = User(
//   id: 3,
//   name: 'Abdelrahman Bl',
//   imageUrl: 'images/Bl.jpg',
// );
// final User olivia = User(
//   id: 4,
//   name: 'Ahmed Magdy',
//   imageUrl: 'images/ahmed.jpg',
// );
// final User megz4 = User(
//   id: 5,
//   name: 'Ahmed Magdy',
//   imageUrl: 'images/ahmed.jpg',
// );
// final User megz5 = User(
//   id: 6,
//   name: 'Ahmed Magdy',
//   imageUrl: 'images/ahmed.jpg',
// );
// final User megz6 = User(
//   id: 7,
//   name: 'Ahmed Magdy',
//   imageUrl: 'images/ahmed.jpg',
// );
// final User megz7 = User(
//   id: 8,
//   name: 'Ahmed Magdy',
//   imageUrl: 'images/ahmed.jpg',
// );
// final User megz8 = User(
//   id: 8,
//   name: 'Ahmed Magdy',
//   imageUrl: 'images/ahmed.jpg',
// );
// final User megz9 = User(
//   id: 8,
//   name: 'Ahmed Magdy',
//   imageUrl: 'images/ahmed.jpg',
// );
// final User megz10 = User(
//   id: 8,
//   name: 'Ahmed Magdy',
//   imageUrl: 'images/ahmed.jpg',
// );
// final User megz11 = User(
//   id: 8,
//   name: 'Ahmed Magdy',
//   imageUrl: 'images/ahmed.jpg',
// );

// FAVORITE CONTACTS
// List<User> favorites = [megz1, megz2, megz3, megz4, megz5, megz6, megz7, megz8, megz11];

// EXAMPLE CHATS ON HOME SCREEN
