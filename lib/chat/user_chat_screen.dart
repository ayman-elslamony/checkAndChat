import 'dart:async';
import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/Providers/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pusher/pusher.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import 'package:flutter/services.dart';
import '../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatScreen extends StatefulWidget {
  String friendId;
  String friendName;

  ChatScreen({this.friendName, this.friendId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msg = TextEditingController();
  static DateTime time = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(time);

  Event lastEvent;
  String lastConnectionState;
  Channel channel;
  String userId;
  List<Message> _mess = [];
  bool _isLoading = true;
  bool isMe = false;

  bool isFriend = true;

  // StreamController<String> _eventData = StreamController<String>();
  // Sink get _inEventData => _eventData.sink;
  // Stream get eventStream => _eventData.stream;

// Future<void> initPusher() async {
//     try {
//       await Pusher.init('5cc0ce6f1c82fab7cf29', PusherOptions(cluster: 'eu'));
//     } on PlatformException catch (e) {
//       print(e.message);
//     }
//   }

  // Future<void> connectPusher() async {
  //   Pusher.connect(onConnectionStateChange: (x) async {
  //     if (mounted)
  //       setState(() {
  //         lastConnectionState = x.currentState;
  //       });
  //   }, onError: (x) {
  //     debugPrint("Error: ${x.message}");
  //   });
  // }

  // Future<void> subscribePusher(String channelName) async {
  //   channel = await Pusher.subscribe(channelName);
  // }

  // void unSubscribePusher(String channelName) {
  //   Pusher.unsubscribe(channelName);
  // }

  //   void bindEvent(String eventName) async {
  //     await channel.bind(eventName, (last) {
  //       if (mounted)
  //         setState(() {
  //           lastEvent = last;
  //           _inEventData.add(last.data);
  //         });
  //     });
  //   }

  // void unbindEvent(String eventName) {
  //   channel.unbind(eventName);
  //   _eventData.close();
  // }

  // Future<void> firePusher(String channelName, String eventName) async {
  //   await initPusher();
  //   await connectPusher();
  //   await subscribePusher(channelName);
  //   bindEvent(eventName);
  // }
  void initState() {
    getdata();
    super.initState();
  }

  getdata() async {
    if (Auth.userId == '') {
      userId = await Auth().getUserId;
    } else {
      userId = Auth.userId;
    }
    _mess = await Provider.of<UserData>(context, listen: false)
        .getMessage(friendId: widget.friendId);
    print(_mess.length);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    _buildMessage(Message message, bool isMe, int index) {
      final Container msg = Container(
        margin: isMe
            ? EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
                right: 0.0,
              )
            : EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
                left: 80.0,
              ),
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          color: !isMe ? Color(0xFFFFEFEE) : Color(0xFFFFE4E1),
          borderRadius: !isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              message.time,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: _width * 0.03,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              message.text,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: _width * 0.035,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
      if (!isMe) {
        return msg;
      } else {
        return Row(
          children: <Widget>[
            msg,
            IconButton(
              icon: message.isLiked
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              iconSize: 30.0,
              color: message.isLiked
                  ? Theme.of(context).primaryColor
                  : Colors.blueGrey,
              onPressed: () {
                setState(() {
                  Provider.of<UserData>(context, listen: false)
                      .changeHeart(friendId: widget.friendId, mm: message);

                  // message.isLiked = ! message.isLiked ;
                  // message.isLiked =true;
                  // if(message.isLiked==true){
                  //   message.isLiked =false;
                  // }else{
                  //   message.isLiked=true;
                  // }
                });
              },
            )
          ],
        );
      }
    }

    _buildMessageComposer() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: 70.0,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo),
              iconSize: 25.0,
              color: Color(0xffc62828),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: msg,
                maxLines: 3,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {},
                decoration: InputDecoration.collapsed(
                    hintText: LocaleKeys.sendMessage.tr(),
                    hintStyle: TextStyle(fontSize: _width * 0.045)),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              color: Color(0xffc62828),
              onPressed: () async {
                if (msg.text.trim().isNotEmpty) {
                  print('scuccess');
                  var x = await Provider.of<UserData>(context, listen: false)
                      .sendMessage(
                          friendId: widget.friendId,
                          message: Message(
                            friendId: widget.friendId,
                            text: msg.text,
                            isLiked: false,
                            unread: true,
                            time: time.toString(),
                          ));
                  print(x);
                  if (x) {
                    _mess.add(Message(
                      friendId: widget.friendId,
                      text: msg.text,

                      isLiked: false,
                      unread: true,
                      time: time.toString(),
                    ));
                    setState(() {
                      msg.text = '';
                    });
                  }
                }
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xffc62828),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Color(0xffc62828),
        title: Text(
          widget.friendName,
          style: TextStyle(
              fontSize: _width * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        elevation: 0.0,
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.more_horiz),
//            iconSize: 25.0,
//            color: Colors.white,
//            onPressed: () {},
//          ),
//        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            // StreamBuilder(
            //   stream: eventStream,
            //   builder: (context, snapshot) {
            //     if(snapshot.hasData){
            //         print(snapshot.data);
            //           messages.add(
            //           Message(
            //             friendId: snapshot.data['id'],
            //             text: snapshot.data,
            //             isLiked: false,
            //             unread: true,
            //             time: time.toString(),
            //             ));

            //               }
            //     return
            Expanded(
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
                  child: Consumer<UserData>(
                    builder: (ctx, reviewData, _) => ListView.builder(
                      reverse: false,
                      padding: EdgeInsets.only(top: 15.0),
                      itemCount: _mess.length,
                      itemBuilder: (BuildContext context, int index) {
                        // if(snapshot.hasData){
                        //   print(snapshot.data);
                        //     _mess[index].id == userId?messages.add(
                        //     Message(
                        //       id: userId,
                        //       text: snapshot.data,
                        //       isLiked: false,
                        //       unread: true,
                        //       time: time.toString(),
                        //       )
                        //       ):
                        //       messages.add(
                        //     Message(
                        //       id: widget.friendId,
                        //       text: snapshot.data,
                        //       isLiked: false,
                        //       unread: true,
                        //       time: time.toString(),
                        //       )
                        //       );

                        //        }
                        // final Message message = messages[index];

//                             if(_mess[index].id == widget.friendId){
//                               isFriend=false;
//                             }
                        print(_mess[index].friendId);
                        print(userId);

                        if (_mess[index].friendId != userId) {
                          isMe = true;
                        } else {
                          isMe = false;
                        }
                        return _buildMessage(_mess[index], isMe, index);
                      },
                    ),
                  ),
                ),
              ),
            ),

            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
