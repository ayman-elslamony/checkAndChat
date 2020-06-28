import 'dart:io';

import 'package:checkandchat/Providers/resturants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../../../../Providers/list_of_photos.dart';
import '../show_photos/show_photos.dart';

class ShowItemPhotos extends StatefulWidget {
  int tabIndex;
  Category category;
  String userId;
  ShowItemPhotos(
      {this.category,this.tabIndex = 0,@required this.userId});

  @override
  _ShowItemPhotosState createState() => _ShowItemPhotosState();
}

class _ShowItemPhotosState extends State<ShowItemPhotos>
    with SingleTickerProviderStateMixin {
bool _isloadingPhoto= false;
  TabController _tabController;
ListOfPhotos _listOfPhotos;
@override
  void initState() {
    _listOfPhotos = Provider.of<ListOfPhotos>(context,listen: false);
    _tabController = new TabController(length: 3, vsync: this);
    _tabController.animateTo(widget.tabIndex);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    Future<void> _getImage(ImageSource source) async {
      File imageFile;
      await ImagePicker.pickImage(source: source, maxWidth: 400.0)
          .then((File image) {
        imageFile = image;
        Navigator.pop(context);
      });
        if(imageFile != null){
          if(widget.category.ownerId!=null && widget.category.ownerId == widget.userId){
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                contentPadding: EdgeInsets.only(top: 10.0),
                title: Text(
                  'Add image as',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color:  Color(0xffc62828)
                  ),
                ),
                content: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        color: Color(0xffc62828),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Text('Owner',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                        onPressed: () async{
                          setState(() {
                            _isloadingPhoto = true;
                          });
                          try{
                            await Provider.of<Categorys>(context, listen: false)
                                .addPhoto(type: 'owner',resturant: widget.category, imageFile: imageFile);
                            Toast.show( "Successfully added",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          }catch(e){
                            Toast.show( "Failed Please try again",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          }
                          setState(() {
                            _isloadingPhoto = false;
                          });
                        },
                      ),
                      FlatButton(
                        color: Color(0xffc62828),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),

                        child: Text(
                          'User',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async{
                          setState(() {
                            _isloadingPhoto = true;
                          });
                          try{
                            await Provider.of<Categorys>(context, listen: false)
                                .addPhoto(resturant: widget.category, imageFile: imageFile);
                            Toast.show( "Successfully added",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          }catch(e){
                            Toast.show( "Failed Please try again",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          }
                          Navigator.of(context).pop();
                          setState(() {
                            _isloadingPhoto = false;
                          });
                        },
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xffc62828), fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          }else{
            setState(() {
              _isloadingPhoto = true;
            });
            try{
              await Provider.of<Categorys>(context, listen: false)
                  .addPhoto(resturant: widget.category, imageFile: imageFile);
              Toast.show( "Successfully added",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
            }catch(e){
              Toast.show( "Failed Please try again",context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
            }
            setState(() {
              _isloadingPhoto = false;
            });
          }
        }
    }
Future deletePhoto(String val,UserPhotoForSpecificCategory userPhotoForSpecificCategory) async{
      if (val == 'Delete') {
        await  Provider.of<Categorys>(context,
            listen: false)
            .deletePhoto(
            resturant: widget.category,
            photosForSpecificCategory:userPhotoForSpecificCategory
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
        setState(() {

        });
      }
    }
    void openImagePicker() {
      showModalBottomSheet(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 120.0,
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
                Text(
                  'Pick an Image',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.red),
                ),
//                SizedBox(
//                  height: 5.0,
//                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton.icon(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.blue,
                      textColor: Theme.of(context).primaryColor,
                      label: Text(
                        'Use Camera',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _getImage(ImageSource.camera);
                        // Navigator.of(context).pop();
                      },
                    ),
                    FlatButton.icon(
                      icon: Icon(
                        Icons.camera,
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.blue,
                      textColor: Theme.of(context).primaryColor,
                      label: Text(
                        'Use Gallery',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _getImage(ImageSource.gallery);
                        // Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ]),
            );
          });
    }
    return Scaffold(
      body: FutureBuilder(
          future: Provider.of<ListOfPhotos>(context,listen: false).preparingAllPhoto(category: widget.category),
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
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    title: Text(
                      widget.category.name,
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: BackButton(
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    actions: <Widget>[
                  _isloadingPhoto?Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(backgroundColor: Colors.red,),
                  ): IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.red,
                          ),
                          onPressed:  openImagePicker)
                    ],
                    bottom: TabBar(
                      indicatorPadding: EdgeInsets.all(10),
                      isScrollable: true,
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.red,
                      tabs: [
                        Tab(
                          text: 'ALL(${_listOfPhotos.photosCount(listType: 'All')})',
                        ),
                        Tab(
                          text: 'Owner(${_listOfPhotos.photosCount(listType: 'Owner')})',
                        ),
                        Tab(
                          text: 'Users(${_listOfPhotos.photosCount(listType: 'Users')})',
                        ),
                      ],
                      controller: _tabController,
                      indicatorColor: Colors.red,
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                  body:  TabBarView(controller: _tabController, children: [
                    ShowPhotos(category: widget.category,photosType: 'All',deletePhoto: deletePhoto,photosForSpecificCategory: _listOfPhotos.getPhotos(listType: 'All'),addPhotos: openImagePicker,userId: widget.userId,),
                    ShowPhotos(category: widget.category,photosType: 'Owner',deletePhoto: deletePhoto,photosForSpecificCategory: _listOfPhotos.getPhotos(listType: 'Owner'),addPhotos: openImagePicker,userId: widget.userId,),
                    ShowPhotos(category: widget.category,photosType: 'Users',deletePhoto: deletePhoto,photosForSpecificCategory: _listOfPhotos.getPhotos(listType: 'Users'),addPhotos: openImagePicker,userId: widget.userId,),
                  ]),
                );
              }
            }
          }),
    );
  }
}