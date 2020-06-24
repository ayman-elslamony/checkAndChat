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
  bool isLoadingData=true;
  
  Future<List<UserData>> _refreshToGetAllCollections() async {
    
    return Provider.of<UserData>(context, listen: false).getAllFriendRequest();
  }

  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme
        .of(context)
        .textTheme
        .title;
    double _height = MediaQuery
        .of(context)
        .size
        .height;
    double _width = MediaQuery
        .of(context)
        .size
        .width;

    Widget _requestButton({String text, Color color,Function function}) {
      return InkWell(
          onTap: (){
            function();
            setState(() {
                  if(isLoadingData){
                   setState(() {         
                    _refreshToGetAllCollections();
                    });
                   }
                  });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              height: _width * 0.09,
              width: _width * 0.15,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5)
              ),
              child: Center(child: Text(
                text, style: TextStyle(fontSize: 10, color: Colors.white),)),
            ),
          )
      );
    }


    Widget _friendsCard(
        {Widget image, String name, String address, int friends, int reviews, int photos, Function function,String friendId}) {
      return InkWell(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[300]),),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: _width * 0.02, right: _width * 0.02),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: SizedBox(
                      child: FittedBox(child: image, fit: BoxFit.cover,),
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: _width * 0.01),
                        child: Text('$name', style: TextStyle(
                            color: Colors.grey[850], fontSize: _width * 0.04),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: _width * 0.01),
                        child: Text('$address', style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: _width * 0.025),),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ImageIcon(
                              AssetImage('images/meScreenIcons/friends.png'),
                              size: _width * 0.04, color: Color(0xffc62828),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text('$friends', style: TextStyle(
                              fontSize: _width * 0.025,
                              color: Colors.grey[700],)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ImageIcon(
                              AssetImage('images/meScreenIcons/addReview.png'),
                              size: _width * 0.04, color: Color(0xffc62828),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text('$reviews', style: TextStyle(
                              fontSize: _width * 0.025,
                              color: Colors.grey[700],)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ImageIcon(
                              AssetImage('images/meScreenIcons/photo.png'),
                              size: _width * 0.04, color: Color(0xffc62828),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text('$photos', style: TextStyle(
                              fontSize: _width * 0.025,
                              color: Colors.grey[700],),),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
                Spacer(),
                _requestButton(text: 'Confirm', color: Colors.green[700],
                  function: ()async{
                  await Provider.of<UserData>(context, listen: false).acceptFriend(friendID: friendId);
                  
                }),
                _requestButton(text: 'Cancel', color: Color(0xffc62828),function: ()async{
                  await Provider.of<UserData>(context, listen: false).unFriend(friendID: friendId);
                  
                })
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
              Text(LocaleKeys.friendRequests, style: TextStyle(
                  color: Colors.white, fontSize: _width * 0.045),).tr(context: context),
            ],
          ),
          backgroundColor: Color(0xffc62828),
        ),


        body: FutureBuilder(
            future: _refreshToGetAllCollections(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    height: _height,
                    width: _width,
                    child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Color(0xffc62828),
                        )));
              } else {
                if (dataSnapshot.error != null) {
                  return
                    Container(
                      height: _height,
                      width: _width,
                      child: Center(
                      child: Text('An error occurred!'),
                  ),
                    );
                } else {
                  if (dataSnapshot.data.length == 0) {
                    return SizedBox(
                      height: _height,
                      width: _width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('There are no friend requests yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey[700]),)
                        ],
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: _height*0.70,
                      width: _width,
                      child: ListView.builder(
                        itemBuilder: (context, index){
                            return _friendsCard(
                              friendId: dataSnapshot.data[index].id,
                              image: FadeInImage.assetNetwork(
                                placeholder: 'images/meScreenIcons/userPlaceholder.png',
                                image: dataSnapshot.data[index].imgUrl,
                                fit: BoxFit.fill,
                                height: 120,
                                width: 120,
                              ),
                                friends: dataSnapshot.data[index].friendsCount,
                                name: dataSnapshot.data[index].name,
                                function: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FriendPage(friendId: dataSnapshot.data[index].id,)));
                                },
                              photos: dataSnapshot.data[index].imageCount,
                              reviews: dataSnapshot.data[index].reviewsCount,
                              address: dataSnapshot.data[index].address,
                            );
                        },
                        itemCount: dataSnapshot.data.length,
                      ),
                    );
                  }
                }
              }
            })
    );
  }
}