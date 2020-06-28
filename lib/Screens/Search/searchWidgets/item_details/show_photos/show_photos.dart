import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:checkandchat/Providers/resturants.dart';
import 'package:checkandchat/Screens/Search/searchWidgets/item_details/widgets/zoom_in_and_out_to_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'click_on_specific_photo.dart';

class ShowPhotos extends StatefulWidget {
  String photosType;
  List<UserPhotoForSpecificCategory> photosForSpecificCategory;
  Category category;
  Function addPhotos;
  Function deletePhoto;
  String userId;

  ShowPhotos(
      {this.category,
      this.photosType,
      this.photosForSpecificCategory,
      this.deletePhoto,
      this.addPhotos,
      this.userId});

  @override
  _ShowPhotosState createState() => _ShowPhotosState();
}

class _ShowPhotosState extends State<ShowPhotos> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    Widget _photoWithTitle({int index}) {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShowImage(
                    imgUrl:
                        widget.photosForSpecificCategory[index].categoryImage,
                  )));
        },
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.network(
              widget.photosForSpecificCategory[index].categoryImage,
              fit: BoxFit.fill,
            ),
            widget.photosForSpecificCategory[index].userName == null ||
                    widget.photosForSpecificCategory[index].userName ==
                        'null' ||
                    widget.photosForSpecificCategory[index].userName == ''
                ? SizedBox()
                : Positioned(
                    child: Container(
                      color: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              widget.photosForSpecificCategory[index].userName,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            widget.photosForSpecificCategory[index].userId ==
                                    widget.userId
                                ? PopupMenuButton<String>(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ),
                                    itemBuilder: (context) => ['Delete']
                                        .map((String val) =>
                                            PopupMenuItem<String>(
                                              child: Text(val),
                                              value: val,
                                            ))
                                        .toList(),
                                    onSelected: (String val) {
                                      widget.deletePhoto(
                                          val,
                                          widget.photosForSpecificCategory[
                                              index]);
                                    })
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                  )
          ],
        ),
      );
    }

    Widget addPhoto() {
      return InkWell(
        onTap: widget.addPhotos,
        child: Container(
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ImageIcon(
                  AssetImage('images/meScreenIcons/addPhoto.png'),
                  color: Colors.grey[600],
                  size: 35,
                ),
                Text(
                  'Add',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                )
              ],
            ),
          ),
        ),
      );
    }

    return widget.photosForSpecificCategory.length == 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'There are no photos for ${widget.photosType}',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            ],
          )
        : GridView.builder(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              childAspectRatio: 3 / 3,
            ),
            itemBuilder: (context, index) =>
                index != widget.photosForSpecificCategory.length
                    ? _photoWithTitle(index: index)
                    : addPhoto(),
            itemCount: widget.photosForSpecificCategory.length + 1);
  }
}
