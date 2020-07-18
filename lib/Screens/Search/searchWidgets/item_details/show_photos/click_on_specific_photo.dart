  
import 'dart:io';

import 'package:checkandchat/Providers/resturants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../../../../Providers/list_of_photos.dart';
import 'package:carousel_slider/carousel_slider.dart';
class TabBar {
  String title;
  String number;

  TabBar({this.title, this.number});
}

class ShowPhotosWithCarsoul extends StatefulWidget {
  int imageIndex;
  String photosType;
  int photosTypeIndex;
  Category category;
String userId;
  ShowPhotosWithCarsoul({this.category,this.imageIndex, this.photosType,this.userId});

  @override
  _ShowPhotosWithCarsoulState createState() => _ShowPhotosWithCarsoulState();
}

class _ShowPhotosWithCarsoulState extends State<ShowPhotosWithCarsoul> {
  int index = 0;
  int all;
  int fromOwner;
  int fromUsers;
  ListOfPhotos _listOfPhotos;
  List<TabBar> _listOfTabBar;
  //List<NetworkImage> _listImg = List<NetworkImage>();
  List<UserPhotoForSpecificCategory> list=List<UserPhotoForSpecificCategory>();
String _type;
String _previousType='';
int initialPage =0;
  Widget _tabBar({String title, String num, int index}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Text(
        '$title($num)',
        style: TextStyle(
            color: _onclickedTabBar[index] ? Colors.red : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  List<bool> _onclickedTabBar = List.generate(3, (i) => false);

  Future<void> _convertURlImgToNetworkImage({String type}) async {
    if(type != _previousType){
      list.clear();
      list = Provider.of<ListOfPhotos>(context,listen: false).getPhotos(listType: type);
      if(list.isEmpty){
        bool x = await Provider.of<ListOfPhotos>(context,listen: false).preparingAllPhoto(category: widget.category);
        if(x){
          list = Provider.of<ListOfPhotos>(context,listen: false).getPhotos(listType: type);
        }
      }
    }
    print('List $type ${list.length}');
    _previousType = type;
  }

  void _onTabBarClicked({int index}) {
    _onclickedTabBar = List.generate(3, (i) => false);
    setState(() {
      initialPage=0;
      _onclickedTabBar[index] = !_onclickedTabBar[index];
      if (index == 0) {
        _type='All';
      }
      if (index == 1) {
        _type='Owner';
      }
      if (index == 2) {
        _type='Users';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initialPage=widget.imageIndex;
    _type=widget.photosType;
    _listOfPhotos = Provider.of<ListOfPhotos>(context, listen: false);
    all = _listOfPhotos.photosCount(listType: 'All');
    fromOwner = _listOfPhotos.photosCount(listType: 'Owner');
    fromUsers = _listOfPhotos.photosCount(listType: 'Users');

    if (widget.photosType == 'All') {
      _onclickedTabBar[0] = true;
    }
    if (widget.photosType == 'Owner') {
      _onclickedTabBar[1] = true;
    }
    if (widget.photosType == 'Users') {
      _onclickedTabBar[2] = true;
    }
    _listOfTabBar = [
      TabBar(title: 'ALL', number: '$all'),
      TabBar(title: 'Owner', number: '$fromOwner'),
      TabBar(title: 'Users', number: '$fromUsers'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      body: FutureBuilder(
          future: _convertURlImgToNetworkImage(type: _type),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  height: _height,
                  width: _width,
                  child: Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  )));
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {

                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[400],
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.black,
                          child: Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: Colors.grey, width: 2))),
                                child: BackButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Container(
                                height: 25,
                                width: MediaQuery.of(context).size.width * 0.85,
                                child: ListView.builder(
                                  itemCount: _listOfTabBar.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => InkWell(
                                      onTap: () => _onTabBarClicked(index: index),
                                      child: _tabBar(
                                          title: _listOfTabBar[index].title,
                                          num: _listOfTabBar[index].number,
                                          index: index)),
                                ),
                              )
                            ],
                          ),
                        ),
                        //SizedBox(height: 30,),
                        list.length==0?Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('There is no photos for $_type yet',style: TextStyle(fontSize: 18,color: Colors.grey[700]),),
                            ],
                          ),
                        ):Padding(
                          padding: const EdgeInsets.only(top:40),
                          child: CarouselSlider.builder(
                              options: CarouselOptions(
                                //                            initialPage: 0,
                                //                            autoPlay: false,
                                // enlargeCenterPage: true,
                                //viewportFraction: 0.9,
                                // aspectRatio: 1,

                                height: _height*0.4,
                                //aspectRatio: 16/9,
                                //                          viewportFraction: 0.8,
                                initialPage: initialPage,
                                //                          enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 8),
                                autoPlayAnimationDuration: Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
//                          enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                              ),
                              itemCount: list.length,
                              itemBuilder: (BuildContext context, int itemIndex) =>
                                  Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect( borderRadius: BorderRadius.all(Radius.circular(5.0)),child: Image.network(list[itemIndex].categoryImage,fit: BoxFit.fill, height: _height*0.88,)),
                                      ),
                                      list[itemIndex].userName == ''?SizedBox():
                                      Positioned(
                                        child: Container(
                                        color: Colors.black,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 12),
                                          child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                list[itemIndex].userName,
                                                style: TextStyle(
                                                    color: Colors.white, fontSize: 16),
                                              ),
                                              Spacer(),
                                              list[itemIndex].date.isEmpty?SizedBox(height: 8,):Text(
                                                '${DateFormat('dd/MM/yyyy').format(DateTime.parse(list[itemIndex].date))}'
                                                ,style:
                                              TextStyle(fontSize: 14, color: Colors.grey),
                                              ),
                                              list[itemIndex].userId == widget.userId
                                                  ? PopupMenuButton<String>(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(10))),
                                                  icon: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.white,
                                                  ),
                                                  itemBuilder: (context) => ['Delete']
                                                      .map(
                                                          (String val) => PopupMenuItem<String>(
                                                        child: Text(val),
                                                        value: val,
                                                      ))
                                                      .toList(),
                                                  onSelected: (String val) {
                                                    if (val == 'Delete') {
                                                      Provider.of<Categorys>(context,
                                                          listen: false)
                                                          .deletePhoto(
                                                          resturant: widget.category,
                                                          photosForSpecificCategory: list[itemIndex]
                                                      )
                                                          .then((x) {
                                                        if (x == 'true') {
                                                          Toast.show(
                                                              "successfully deleted!", context,
                                                              duration: Toast.LENGTH_SHORT,
                                                              gravity: Toast.BOTTOM);

                                                        } else if (x == 'false') {
                                                          Toast.show(
                                                              "failed to delete!", context,
                                                              duration: Toast.LENGTH_SHORT,
                                                              gravity: Toast.BOTTOM);
                                                        }
                                                      });
                                                    }
                                                  })
                                                  : SizedBox(),
//                      Divider(
//                        color: Colors.grey,
//                        thickness: 1.3,
//                      ),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.end,
//                        children: <Widget>[
//                          IconButton(
//                              icon: Icon(
//                                Icons.more_horiz,
//                                color: Colors.white,
//                              ),
//                              onPressed: () {}),
//                          InkWell(
//                            onTap: () {},
//                            child: Row(
//                              children: <Widget>[
//                                Icon(
//                                  Icons.favorite_border,
//                                  color: Colors.grey,
//                                ),
//                                Text(
//                                  ' 2 Likes',
//                                  style: TextStyle(
//                                      color: Colors.grey, fontSize: 14),
//                                )
//                              ],
//                            ),
//                          ),
//                        ],
//                      )
                                            ],
                                          ),
                                        ),
                                      ),bottom: 6.0,left: 6.0,right: 6.0,)
                                    ],
                                  )
                          ),
                        ),
                      ],
                    ),
                  );

              }
            }
          }),
    ));
  }
}