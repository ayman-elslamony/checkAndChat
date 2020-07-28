import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/Providers/user_data.dart';
import 'package:checkandchat/Screens/Me/meWidgets/moreWidgets.dart/Friend_collections.dart';
import 'package:checkandchat/chat/user_chat_screen.dart';
import 'package:checkandchat/chats/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Screens/Me/meWidgets/moreWidgets.dart/freiend-activities.dart';
import '../../../../Screens/Me/meWidgets/moreWidgets.dart/friend_friends_list.dart';
import '../../../../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class FriendPage extends StatefulWidget {
  String friendId;
  FriendPage({this.friendId});

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  bool loading =false;
  UserData _userData;
  bool isLoadingData=true;

  @override
  void initState() {
    _refreshToGetUserData();
    super.initState();
  }

  Future<UserData> _refreshToGetUserData() async {
//    if(isgettingFriendAdded == false){
//      try{
//        isFriendAdded = await Provider.of<UserData>(context,listen: false).isAddFriend(friendID: widget.friendId);
//        isgettingFriendAdded = true;
//        print(isFriendAdded);
//      }catch(e){
//        print(e);
//      }
//    }

    if(_userData == null){
      _userData = await Provider.of<UserData>(context, listen: false)
          .getUserData(id: widget.friendId);
      setState(() {
        isLoadingData=false;
      });
    }
    return _userData;
  }
//  _requestButton(text: 'Confirm', color: Colors.green,function: (){
//  Provider.of<UserData>(context, listen: false).acceptFriend(friendID: friendId);
//  }),
//  _requestButton(text: 'Cancel', color: Colors.red,function: (){
//  Provider.of<UserData>(context, listen: false).unFriend(friendID: friendId);
//  })
  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    Widget _requestButton({String text, Color color,Function function}) {
      return InkWell(
          onTap: function,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              height: _width * 0.09,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Center(child: Text(
                text, style: TextStyle(fontSize: 10, color: Colors.white),)),
            ),
          )
      );
    }
    Divider _divider() {
      return Divider(
        color: Colors.grey[300],
        thickness: 1.0,
        height: 1,
      );
    }

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
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(_width * 0.02),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  child: FittedBox(
                    child: image,
                    fit: BoxFit.cover,
                  ),
                  height: 120,
                  width: 120,
                ),
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
                          color: Colors.grey[850], fontSize: _width * 0.045),
                    ),
                  ),
                  address == ''?SizedBox():Padding(
                    padding: EdgeInsets.only(bottom: _width * 0.02),
                    child: SizedBox(
                      width: _width*0.4,
                           child: Text(
                        '$address',
                        style: TextStyle(
                            color: Colors.grey[600], fontSize: _width * 0.03),
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
                            )),
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
                            )),
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
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget _createListButton(
        {Widget icon1,
        IconData icon2,
        Text text,
        Function function,
        Widget route}) {
      return InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => route));
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

  _unfriend() async{
    await Provider.of<UserData>(
        context,
        listen: false)
        .unFriend(
        friendID:
        widget.friendId,friendDeta: _userData);
    }

  _confirmFriend() async{
    
    await Provider.of<UserData>(
      context,
      listen: false)
      .acceptFriend(
      friendID:
      widget.friendId,friendDeta: _userData);
  }

    return Scaffold(
        body: RefreshIndicator(
          onRefresh: ()async{
          _userData=null;
          setState(() {
            isLoadingData=true;
          });
            _refreshToGetUserData();
          },
          backgroundColor: Colors.white,
          color: Color(0xffc62828),
          child: isLoadingData?
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0.0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white),
              ),
              Text(
                '',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: _width * 0.045),
              ),
            ],
          ),
          backgroundColor: Color(0xffc62828),
          ),
          body: Container(
              height: _height,
              width: _width,
              child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ))),
          ):
          Consumer<UserData>(
            builder: (ctx, userData, child)=> 
            Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0.0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: _width*0.55,
                    child: Text(
                      userData.friendUserData.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: _width * 0.045),
                    ),
                  ),
                ],
              ),
              backgroundColor: Color(0xffc62828),
            ),
              body:
              ListView(
                children: <Widget>[
                  SizedBox(
                    height: _height * 0.01,
                  ),
                  child,
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      userData.friendUserData.isFriendAdded == 'notMeSendRequest'?InkWell(
                          onTap: (){
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              25.0))),
                                  contentPadding:
                                  EdgeInsets.only(top: 10.0),
                                                        //                                          title: Text('Accept Friend',
                                                        //                                              textAlign: TextAlign.center,
                                                      //                                              style: TextStyle(
                                                      //                                                  color: Colors.red,
                                                      //                                                  fontSize: 18)),
                                content: Padding(
                                  padding: const EdgeInsets.only(top: 18.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(onPressed: (){
                                          _confirmFriend();
                                          Navigator.of(context).pop();
                                          if(isLoadingData){
                                            setState(() {
                                            
                                          _refreshToGetUserData();
                                          });
                                          }

                                        },
                                          color: Colors.green[700],
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                          child: Text(
                                            'Confirm ', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold, color: Colors.white),),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(onPressed: ()async{
                                          setState(() {
                                            loading=true;
                                          });
                                          _unfriend();
                                          Navigator.of(context).pop();
                                        },
                                          color: Color(0xffc62828),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                          child: Text(
                                            'Cancel ', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold, color: Colors.white),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // actions: <Widget>[
                                //   FlatButton(
                                //     child: Text('skip',
                                //         style: TextStyle(
                                //             color: Colors.black54,
                                //             fontWeight:
                                //             FontWeight.bold)),
                                //     onPressed: () {
                                //       Navigator.of(context).pop();
                                //     },
                                //   ),
                                // ],
                              ));
                          setState(() {
                            loading=false;
                          });
                        },
                        child: loading?CircularProgressIndicator(backgroundColor: Color(0xffc62828),):Column(
                          children: <Widget>[
                            ImageIcon(
                                AssetImage('images/addFriend.png'),
                                color:Color(0xffc62828)),
                            SizedBox(height: 5),
                            Text(
                              'Accept Friend',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xffc62828)),
                            )
                          ],
                        )):
                    userData.friendUserData.isFriendAdded == 'alreadyFriends'?
                    InkWell(
                        onTap: (){
                          setState(() {
                            loading=true;
                          });

                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            25.0))),
                                contentPadding:
                                EdgeInsets.only(top: 10.0),
                                title: Text('Friends',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18)),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Remove Friend',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight:
                                            FontWeight.bold)),
                                    onPressed: () {
                                      _unfriend();
                                      Navigator.of(context).pop();
                                      if(isLoadingData){
                                            setState(() {
                                          _refreshToGetUserData();
                                          });
                                          }

                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Cancel',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight:
                                            FontWeight.bold)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ));
                          setState(() {
                            loading=false;
                          });
                        },
                        child: loading?CircularProgressIndicator(backgroundColor: Color(0xffc62828),):Column(
                          children: <Widget>[
                            ImageIcon(
                                AssetImage('images/meScreenIcons/friends.png'),
                                color:Color(0xffc62828)),
                            SizedBox(height: 5),
                            Text(
                              'Friends',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xffc62828)),
                            )
                          ],
                        ))
                        :InkWell(
                        onTap: ()async{
                          setState(() {
                            loading=true;
                          });
                          print('cc ${userData.friendUserData.isFriendAdded}');
                          if(userData.friendUserData.isFriendAdded == 'isMeSendRequest'){
                            print('unadd');
                            await Provider.of<UserData>(context,listen: false).unFriend(
                              friendDeta: userData.friendUserData,
                                friendID: widget.friendId,
                            );
                          }else{
                            print('add');
                            await Provider.of<UserData>(context,listen: false).addFriend(
                              friendDeta: userData.friendUserData,
                                friendID: widget.friendId
                            );
                          }
                          setState(() {
                            loading=false;
                          });
                        },
                        child: loading?CircularProgressIndicator(backgroundColor: Color(0xffc62828),):Column(
                          children: <Widget>[
                            ImageIcon(
                                AssetImage('images/addFriend.png'),
                                color: userData.friendUserData.isFriendAdded == 'false'?Colors.grey[600]:Color(0xffc62828)),
                            SizedBox(height: 5),
                            Text(
                              userData.friendUserData.isFriendAdded == 'false'?'Add Friend':'Unfriend',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: userData.friendUserData.isFriendAdded == 'false'?Colors.grey[600]:Color(0xffc62828)),
                            )
                          ],
                        )),
                    InkWell(
                      onTap: (){
                        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Chat
                      (
                      peerAvatar: userData.friendUserData.imgUrl,
                      peerId: widget.friendId,
                      friendName: userData.friendUserData.name,
                    ),
                  ),
                );
                      },
                      child: Column(
                        children: <Widget>[
                          ImageIcon(
                              AssetImage(
                                  'images/meScreenIcons/messages.png'),
                              color: Colors.grey[600]),
                          SizedBox(height: 5),
                          Text(
                            'Message',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey[600]),
                          )
                        ],
                      ),
                    ),
//                    InkWell(
//                      child: Column(
//                        children: <Widget>[
//                          ImageIcon(
//                              AssetImage(
//                                  'images/meScreenIcons/deals.png'),
//                              color: Colors.grey[600]),
//                          SizedBox(height: 5),
//                          Text(
//                            'Follow',
//                            style: TextStyle(
//                                fontSize: 14,
//                                fontWeight: FontWeight.w800,
//                                color: Colors.grey[600]),
//                          )
//                        ],
//                      ),
//                    ),
                  ],
                ),

                SizedBox(height: 20),
                _divider(),
                _createListButton(
                    route: FriendsCollections(friendId: widget.friendId,userName: _userData.name,),
                    icon1: ImageIcon(
                        AssetImage(
                            'images/NavBar/bookmark.png'),
                        color: Colors.grey[600]),
                    icon2: Icons.arrow_forward_ios,
                    text: Text(LocaleKeys.collections.tr(),
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontSize: _width * 0.035,
                            fontWeight: FontWeight.w700,fontFamily: 'Cairo'))),
                _divider(),
                _createListButton(
                    route: FriendListOfFriends(friendId: widget.friendId,),
                    icon1: ImageIcon(
                        AssetImage(
                            'images/meScreenIcons/friends.png'),
                        color: Colors.grey[600]),
                    icon2: Icons.arrow_forward_ios,
                    text: Text(LocaleKeys.friends.tr(),
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontSize: _width * 0.035,
                            fontWeight: FontWeight.w700,fontFamily: 'Cairo'))),
                _divider(),
                _createListButton(
                    route: FriendActivitiesScreen(friendId: widget.friendId,),
                    icon1: ImageIcon(
                        AssetImage('images/NavBar/activity.png'),
                        color: Colors.grey[600]),
                    icon2: Icons.arrow_forward_ios,
                    text: Text(LocaleKeys.activities.tr(),
                        style: TextStyle(
                            color: Colors.grey[850],
                            fontSize: _width * 0.035,
                            fontWeight: FontWeight.w700,fontFamily: 'Cairo'))),
                _divider(),
              ],
            ),),
            child: _userCard(
                image: FadeInImage.assetNetwork(
                  placeholder: 'images/meScreenIcons/userPlaceholder.png',
                  image: _userData.imgUrl,
                  fit: BoxFit.fill,
                  height: 110,
                  width: 110,
                ),
                address: _userData.address,
                name:_userData.name,
                friends:_userData.friendsCount,
                photos: _userData.imageCount,
                reviews: _userData.reviewsCount),
            )
      ),
    );
  }
}