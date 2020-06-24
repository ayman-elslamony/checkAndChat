import 'package:checkandchat/Providers/user_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chat/user_chat_screen.dart';
import '../models/message_model.dart';

class RecentChats extends StatefulWidget {
  @override
  _RecentChatsState createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  bool _isLoading = true;
  List<Recentchat> _recentchat = [];
  @override
  void initState() {
     getAllFriendChat();
    super.initState();
  }

  getAllFriendChat() async {
    _recentchat =
        await Provider.of<UserData>(context,listen:false).getAllFriendsForChatSreen();
        print(_recentchat.length);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Expanded(
      
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: _isLoading
              ? Column(
                children: <Widget>[
                  SizedBox(height:_height*0.35),
                  Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                  ),
                ],
              )
              : _recentchat.length == 0
                  ? Column(
                      children: <Widget>[
                        SizedBox(height:_height*0.35),
                        Center(child: Text('There is no chats yet',style: TextStyle(color:Colors.grey[700],fontSize: 18),)),
                      ],
                    )
                  : ListView.builder(
                      itemCount:  _recentchat.length,
                      itemBuilder: (BuildContext context, int index) {
                        //final Message chat = chats[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                friendName: _recentchat[index].userdata.name,
                                friendId:  _recentchat[index].userdata.id,
                              ),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 5.0, bottom: 5.0, right: 20.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color:  _recentchat[index].unread
                                  ? Color(0xFFFFEFEE)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                       child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child:
                                            FadeInImage.assetNetwork(
                                              placeholder: 'images/meScreenIcons/userPlaceholder.png',
                                              image:_recentchat[index].userdata.imgUrl),
                                      ),
                                    ),
                                    SizedBox(width: 10.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _recentchat[index].userdata.name,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: _width * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        Container(
                                          child: SizedBox(
                                            width: _width *0.4,
                                             child: Text(
                                             _recentchat[index].text,
                                              style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: _width * 0.032,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width:_width*0.3,
                                        child: Text(
                                         _recentchat[index].time,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: _width * 0.028,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                     _recentchat[index].unread
                                        ? Container(
                                            width: 40.0,
                                            height: 25.0,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'NEW',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: _width * 0.03,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        : Text(''),
                                  ],
                                ),
                                  ],
                                ),
                                
                              
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
