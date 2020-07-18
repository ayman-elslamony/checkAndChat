import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class AddCheckIn extends StatefulWidget {
  @override
  _AddCheckInState createState() => _AddCheckInState();
}

class _AddCheckInState extends State<AddCheckIn> {
  File _imageFile;
  String imgUrl;
  Future<void> _getImage(BuildContext context, ImageSource source) async {
    await ImagePicker.pickImage(source: source, maxWidth: 400.0);
//        .then((File image) async {
//      try{
//        StorageReference storageReference = FirebaseStorage.instance
//            .ref()
//            .child('profiles/${basename(image.path)}}');
//        StorageUploadTask uploadTask = storageReference.putFile(image);
//        await uploadTask.onComplete;
//        storageReference.getDownloadURL().then((fileURL) {
//          setState(() {
//            _imageFile = image;
//            imgUrl = fileURL;
//          });
//        });
//        Navigator.pop(context);
//      }catch(e){
//        Toast.show("Please Try Again", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//      }
//    });
  }
  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 100.0,
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              Text(
                'Pick an Image',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xffc62828)),
              ),
              SizedBox(
                height: 10.0,
              ),
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
                      _getImage(context, ImageSource.camera);
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
                      _getImage(context, ImageSource.gallery);
                      // Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ]),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          
          automaticallyImplyLeading: false,        
          titleSpacing: 0.0,          
          actions: <Widget>[
            IconButton(icon: Icon(Icons.check,color: Colors.white,), onPressed: (){})
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,            
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              Text('Check In',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
            ],
          ),
          backgroundColor: Color(0xffc62828),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: ()=>_openImagePicker(context),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                          ,color: Colors.grey[200],
                        ),
                        width: MediaQuery.of(context).size.width*0.40,
                        height: MediaQuery.of(context).size.height*0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.photo_camera,
                              size: 40,
                              color: Colors.grey[700],
                            ),
                            Text(
                              'Add Check-in Photo',
                              style: TextStyle(fontSize: 16, color: Colors.grey[700],),maxLines: 2,
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onTap: (){},
                          minLines: 10,
                          maxLines: 11,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add a note to your check-in(e.g. \'Hanging out with friends!\')'
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey,),bottom: BorderSide(color: Colors.grey,)),
                  ),
                  child: TextFormField(
                    onTap: (){},
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.people),
                        hintText: 'Tag friends'
                    ),
                  ),
                ),
                SizedBox(height: 14.0,),
                Text('SHARE WITH FRIENDS ON',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black54),),
                SizedBox(height: 3.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(onPressed: (){},shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      child: Text('Facebook',style: TextStyle(fontSize: 14,color: Colors.white),),
                    ),color: Color(0xff38569a),),
                    SizedBox(width: 5.0,),
                    RaisedButton(onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: Text('twitter',
                          style: TextStyle(fontSize: 14, color: Colors.white),),
                      ),color: Color(0xff1ea1f3),),
                  ],
                ),
                RaisedButton(onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Center(
                      child: Text('Check In',
                        style: TextStyle(fontSize: 14, color: Colors.white),),
                    ),
                  ),color: Color(0xffc62828),),
              ],
            ),
          ),
        ),
      );
  }
}
