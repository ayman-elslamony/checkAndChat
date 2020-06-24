import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class ShowImage extends StatelessWidget {
  String imgUrl;
  bool isAsset;
  File imageFile;
  bool isFile;

  ShowImage({this.imgUrl,this.isAsset=false,this.isFile=false,this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(
        color: Colors.white,
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),),
      body: Container(
          child: PhotoView(
            loadFailedChild: Center(child: Text('An error occured'),),
            customSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            imageProvider: isAsset?AssetImage(imgUrl):isFile?FileImage(imageFile):NetworkImage(imgUrl),
          )
      ),
    );
  }
}
