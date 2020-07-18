// import 'package:flutter/material.dart';
// import '../chat/user_chat_screen.dart';
// import '../models/message_model.dart';

// class FavoriteContacts extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final _textStyle = Theme.of(context).textTheme.title;
//     double _height = MediaQuery.of(context).size.height;
//     double _width = MediaQuery.of(context).size.width;    

//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10.0),
//       child: Column(
        
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text(
//                   'Favorite Contacts',
//                   style: TextStyle(
//                     color: Colors.blueGrey,
//                     fontSize: _width*0.04,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 1.0,
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.more_horiz,
//                   ),
//                   iconSize: 25.0,
//                   color: Colors.blueGrey,
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 75.0,
//             child: ListView.builder(
//               padding: EdgeInsets.only(left: 10.0),
//               scrollDirection: Axis.horizontal,
//               itemCount: favorites.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return GestureDetector(
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => ChatScreen(
//                         user: favorites[index],
//                       ),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.only(left:10,right:10),
//                     child: Column(
//                       children: <Widget>[
//                         CircleAvatar(
//                           radius: 25.0,
//                           backgroundImage:
//                               AssetImage(favorites[index].imageUrl),
//                         ),
//                         SizedBox(height: 6.0),
//                         Text(
//                           favorites[index].name,
//                           style: TextStyle(
//                             color: Colors.blueGrey,
//                             fontSize: _width*0.032,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }