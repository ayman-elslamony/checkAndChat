import 'package:checkandchat/Providers/user_data.dart';
import 'package:checkandchat/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chat/category_selector.dart';
import '../chat/favorite_contacts.dart';
import '../chat/recent_chat.dart';
import 'package:easy_localization/easy_localization.dart';


class ChatHomeScreen extends StatefulWidget {
  @override
  _ChatHomeScreenState createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
bool isLoading = false;
String value = '';


  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffc62828),
      appBar: PreferredSize(
              child: AppBar(
                automaticallyImplyLeading: false,
              backgroundColor: Color(0xffc62828),
          // leading: IconButton(
          //   icon: Icon(Icons.menu),
          //   iconSize: 25.0,
          //   color: Colors.white,
          // onPressed: () {},
          // ),
          title: Padding(
            padding: const EdgeInsets.only(top:12.0),
            child: Text(LocaleKeys.chats,style: TextStyle(fontSize:22,color:Colors.white),).tr(context: context),
            // Row(
            //   children: <Widget>[
            //     IconButton(
            //       icon: Icon(Icons.menu),
            //       iconSize: 25.0,
            //       color: Colors.white,
            //     onPressed: () {},
            //     ),
            //     SizedBox(width:20),
            //     Container(
            //       alignment: Alignment.center,
            //       height: _width*0.08,
            //       width: _width*0.7,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius:  BorderRadius.circular(10),
            //       ),
            //       child: TextField(
                    
            //         cursorColor: Color(0xffc62828),
            //         decoration: InputDecoration(
            //           hintStyle: TextStyle(fontSize: 14),
            //           hintText: 'Search for Friends',
            //           suffixIcon: Icon(Icons.search,color: Color(0xffc62828),),
            //           border: InputBorder.none,
            //           contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      
            //         ),
            //         onChanged: (val) async {
            //         if (value == '') {
            //           value = val;
            //         }
            //         if (val.isEmpty) {
            //           await Provider.of<UserData>(context, listen: false)
            //               .getAllFriendsInTheAppWithOutNotifer();
            //         }
            //           if (val.length < value.length) {
            //             setState(() {
            //               isLoading=true;
            //             });
            //             await Provider.of<UserData>(context, listen: false)
            //                 .searchForFriends(nameForSearch: val);
            //           } else {
            //             setState(() {
            //               isLoading=true;
            //             });
            //             await Provider.of<UserData>(context, listen: false)
            //                 .searchForFriends(nameForSearch: val);
            //         }
            //         setState(() {
            //           isLoading = false;
            //           value = val;
            //         });
            //       },
            //       ),
            //     ),
            //   ],
            // ),
          ),
          elevation: 0.0,
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.search),
          //     iconSize: 25.0,
          //     color: Colors.white,
          //     onPressed: () {
          //     //   setState(() {
          //     //     _isSearch = ! _isSearch;
          //     //   });
          //     },
          //   ),
          // ],
        ),
         preferredSize: Size.fromHeight(70.0),
      ),
      body:  isLoading?Container(
              decoration: BoxDecoration(
               color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
              height: _height,
              width: _width,
              child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Color(0xffc62828),
                  ))):Consumer<UserData>(
                builder: (context, dataSnapshot, _) {
                  return Column(
                    children: <Widget>[
                      CategorySelector(),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              // FavoriteContacts(),
                              RecentChats(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      
    );
  }
}


