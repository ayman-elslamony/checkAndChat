import 'package:checkandchat/Providers/user_data.dart';
import 'package:checkandchat/Screens/Me/meWidgets/moreWidgets.dart/FriendPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:checkandchat/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  bool refresh = true;
  String value = '';
  bool isLoading = false;

Future<void>  _refreshToGetFriends() async{
//    if (refresh) {
//      _futureFriends =
//          Provider.of<UserData>(context, listen: false).getAllFriendsInTheApp();
//      refresh = false;
//    }
  setState(() {
    isLoading = true;
  });
    await Provider.of<UserData>(context, listen: false)
        .getAllFriends();
  setState(() {
    isLoading = false;
  });
  }

  @override
  void initState() {
    _refreshToGetFriends();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    Widget _friendsCard(
        {Widget image,
          String name,
          String address,
          int friends,
          int reviews,
          int photos,
          Function function}) {
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
                      left: _width * 0.02, right: _width * 0.02),
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
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: _width * 0.01),
                        child: Text(
                          '$name',
                          style: TextStyle(
                              color: Colors.grey[850], fontSize: _width * 0.04),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: _width * 0.01),
                        child: Text(
                          '$address',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: _width * 0.025),
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
                )
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
                LocaleKeys.friends,
                style: TextStyle(color: Colors.white, fontSize: _width * 0.045),
              ).tr(context: context),
            ],
          ),
          backgroundColor: Color(0xffc62828),
        ),
        body: RefreshIndicator(
          onRefresh: ()async{
            await Provider.of<UserData>(context, listen: false)
                .getAllFriends();
          },
          color: Color(0xffc62828),
          child: Stack(
            children: <Widget>[
              isLoading?Container(
                  height: _height,
                  width: _width,
                  child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xffc62828),
                      ))):Consumer<UserData>(
                builder: (context, dataSnapshot, _) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: _height * 0.07,
                      ),
                      Expanded(
                        child: value == '' && dataSnapshot.allFriends.length==0
                            ? Center(
                            child: Text(
                              'there are no friends yet',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ))
                            : ListView.builder(
                          itemCount: dataSnapshot.allFriends.length,
                          itemBuilder: (context, index) => _friendsCard(
                            image: FadeInImage.assetNetwork(
                              placeholder: 'images/meScreenIcons/userPlaceholder.png',
                              image: dataSnapshot.allFriends[index].imgUrl,
                              fit: BoxFit.fill,
                              height: 120,
                              width: 120,
                            ),
                          
                            address: dataSnapshot.allFriends[index].address,
                            name: dataSnapshot.allFriends[index].name,
                            friends:
                            dataSnapshot.allFriends[index].friendsCount,
                            photos:
                            dataSnapshot.allFriends[index].imageCount,
                            reviews:
                            dataSnapshot.allFriends[index].reviewsCount,
                            function: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FriendPage(
                                    friendId: dataSnapshot
                                        .allFriends[index].id,
                                  )));
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Positioned(
                top: 4,
                left: _width * 0.03,
                child: Container(
                  width: _width * 0.94,
                  height: _height * 0.08,
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Search For Friends',
                      hintStyle: TextStyle(fontSize: _width * 0.04),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey[400])),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey[400])),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.grey[400]),
                      ),
                      contentPadding: new EdgeInsets.symmetric(vertical: 15.0),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.black54,
                          ),
                          onPressed: () {}),
                    ),
                    onChanged: (val) async {
                      if (value == '') {
                        value = val;
                      }
                      if (val.isEmpty) {
                        await Provider.of<UserData>(context, listen: false)
                            .getAllFriendsWithOutNotifer();
                      }
                      if (val.length < value.length) {
                        setState(() {
                          isLoading=true;
                        });
                        await Provider.of<UserData>(context, listen: false)
                            .searchForFriends(nameForSearch: val);
                      } else {
                        setState(() {
                          isLoading=true;
                        });
                        await Provider.of<UserData>(context, listen: false)
                            .searchForFriends(nameForSearch: val);
                      }
                      setState(() {
                        isLoading = false;
                        value = val;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}