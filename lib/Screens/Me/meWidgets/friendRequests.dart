import 'package:checkandchat/Providers/user_data.dart';
import 'package:checkandchat/Screens/Me/meWidgets/moreWidgets.dart/FriendPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkandchat/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class FriendRequests extends StatefulWidget {
  @override
  _FriendRequestsState createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  bool isLoadingData = true;
  bool isConfirming = false;
  bool isCanceling = false;
  List<UserData> allRequests = [];

  Future _refreshToGetAllCollections() async {
    allRequests = await Provider.of<UserData>(context, listen: false)
        .getAllFriendRequest();
    setState(() {
      isLoadingData = false;
    });
  }

  @override
  void initState() {
    _refreshToGetAllCollections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    Widget _requestButton({String text, Color color, Function function}) {
      return InkWell(
          onTap: function,
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Container(
              height: _width * 0.09,
              width: _width * 0.12,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: Text(
                text,
                style: TextStyle(fontSize: _width*0.024, color: Colors.white),
              )),
            ),
          ));
    }

    Widget _friendsCard(
        {Widget image,
        String name,
        String address,
        int friends,
        int reviews,
        int photos,
          int index,
        Function function,
        String friendId}) {
      return InkWell(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: _width * 0.01, right: _width * 0.01),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: SizedBox(
                      child: FittedBox(
                        child: image,
                        fit: BoxFit.cover,
                      ),
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: _width * 0.01),
                        child: SizedBox(
                          width: _width*0.3,
                          child: Text(
                            '$name',
                            style: TextStyle(
                                color: Colors.grey[850], fontSize: _width * 0.032),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: _width * 0.01),
                        child: SizedBox(
                          width: _width*0.25,
                          child: Text(
                            '$address',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: _width * 0.02),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ImageIcon(
                              AssetImage('images/meScreenIcons/friends.png'),
                              size: _width * 0.04,
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
                              size: _width * 0.04,
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
                              size: _width * 0.04,
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
                ),
                Spacer(),
                _requestButton(
                    text: 'Confirm',
                    color: Colors.green[700],
                    function: isConfirming ==false
                        ? () async {
                            setState(() {
                              isConfirming = true;
                            });
                            bool x = await Provider.of<UserData>(context, listen: false)
                                .acceptFriend(friendID: friendId,friendDeta: allRequests[index]);
                            if(x==true){
                              setState(() {
                                allRequests.removeAt(index);
                                isConfirming = false;
                              });
                            }else{
                              setState(() {
                                isConfirming = false;
                              });
                            }

                          }
                        : (){}),
                _requestButton(
                    text: 'Cancel',
                    color: Color(0xffc62828),
                    function: isCanceling ==false
                        ? () async {
                            setState(() {
                              isCanceling = true;
                            });
                           bool x = await Provider.of<UserData>(context, listen: false)
                                .unFriend(friendID: friendId,friendDeta: allRequests[index]);
                            if(x==true){
                              setState(() {
                                allRequests.removeAt(index);
                                isCanceling = false;
                              });
                            }else{
                              setState(() {
                                isCanceling = false;
                              });
                            }

                          }
                        : (){})
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              Text(
                LocaleKeys.friendRequests,
                style: TextStyle(color: Colors.white, fontSize: _width * 0.045),
              ).tr(context: context),
            ],
          ),
          backgroundColor: Color(0xffc62828),
        ),
        body: RefreshIndicator(
          backgroundColor: Colors.red,
          onRefresh: ()async{
              allRequests.clear();
            await _refreshToGetAllCollections();
            setState(() {
            });
          },
          child: isLoadingData
              ? Container(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
              ),
            ),
          )
              : allRequests.length == 0
              ? ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(
              height: _height,
              width: _width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    LocaleKeys.noFriendRequests.tr(),
                    style:
                    TextStyle(fontSize: 18, color: Colors.grey[700]),
                  )
                ],
              ),
            )],
              )
              : SizedBox(
            height: _height * 0.70,
            width: _width,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return _friendsCard(
                  friendId: allRequests[index].id,
                  index: index,
                  image: FadeInImage.assetNetwork(
                    placeholder:
                    'images/meScreenIcons/userPlaceholder.png',
                    image: allRequests[index].imgUrl,
                    fit: BoxFit.fill,
                    height: 120,
                    width: 120,
                  ),
                  friends: allRequests[index].friendsCount,
                  name: allRequests[index].name,
                  function: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FriendPage(
                          friendId: allRequests[index].id,
                        )));
                  },
                  photos: allRequests[index].imageCount,
                  reviews: allRequests[index].reviewsCount,
                  address: allRequests[index].address,
                );
              },
              itemCount: allRequests.length,
            ),
          ),
        ));
  }
}
