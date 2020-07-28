import 'dart:io';

import 'package:checkandchat/Providers/resturants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
class CheckIn extends StatefulWidget {
  Category resturant;

  CheckIn({this.resturant});

  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  File _imageFile;
  String _checkInNote;
  bool isImageSelected = false;
  bool _isCkeckInLoading = false;
  Future<void> _getImage(BuildContext context, ImageSource source) async {
    await ImagePicker.pickImage(source: source, maxWidth: 400.0)
        .then((File image) async {
      setState(() {
        _imageFile = image;
        isImageSelected = true;
      });
      Navigator.of(context).pop();
    });
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
                    color: Colors.red),
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
  _checkInButton() {
    setState(() {
      _isCkeckInLoading = true;
    });
    print(_isCkeckInLoading);
    Provider.of<Categorys>(context,listen: false).checkIn(resturant: widget.resturant,checkInNote: _checkInNote,idForFriendsTaged: ['xx'],imageFile: _imageFile).then((x){
      if(x == 'true'){
        Toast.show("successfully added!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        Navigator.of(context).pop();
      }else if(x == 'false'){
        Toast.show("failed added!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }else{
        Toast.show("Please add image!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      }
      setState(() {
        _isCkeckInLoading = false;
      });
    });

  }
  @override
  Widget build(BuildContext context) {

    return
      Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffc62828),
          leading: BackButton(
            color: Colors.white,
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.check,color: Colors.white,), onPressed: _isCkeckInLoading
                ? (){}:_checkInButton)
          ],
          title: Text(widget.resturant.name,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
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
                        child: isImageSelected == false?Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.photo_camera,
                              size: 40,
                              color: Colors.grey[700],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Add Check-in Photo',
                                style: TextStyle(fontSize: 12, color: Colors.grey[700],),maxLines: 2,
                              ),
                            )
                          ],
                        ):Image.file(_imageFile,fit: BoxFit.fill,),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top:25, left: 15),
                        child: TextFormField(
                          onTap: (){},
                          minLines: 10,
                          maxLines: 11,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add a note to your check-in(e.g. \'Hanging out with friends!\')'
                          ),
                          onChanged: (val){
                            _checkInNote = val;
                          },
                        ),
                      ),
                    )
                  ],
                ),
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
                    ),color: Color(0xff4064ac),),
                    SizedBox(width: 5.0,),
                    RaisedButton(onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: Text('twitter',
                          style: TextStyle(fontSize: 14, color: Colors.white),),
                      ),color: Color(0xff1a92dc),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left:85,right:85),
                  child: RaisedButton(onPressed: _isCkeckInLoading
                      ? (){}:_checkInButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      child: Center(
                        child: _isCkeckInLoading?CircularProgressIndicator(backgroundColor: Color(0xffc62828),):Text('Check In',
                          style: TextStyle(fontSize: 14, color: Colors.white),),
                      ),
                    ),color: Color(0xffc62828),),
                ),
              ],
            ),
          ),
        ),
      );
  }
}