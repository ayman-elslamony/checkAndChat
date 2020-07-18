import 'package:checkandchat/Providers/user_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
  TextEditingController _changeNameController = TextEditingController();
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    bool _isTapped = false;


  Divider _divider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1.0,
      height: 1,
    );
  }    

  Widget _createListButton({Widget icon1,IconData icon2, Text text, Function function , Widget route}){
      return InkWell(
        onTap:function,
        child: ListTile(
          dense: true,
          title: Row(
                    children: <Widget>[
                      icon1,
                      Padding(padding: EdgeInsets.only(right:_width*0.03),),
                      text,
                      Spacer(),
                      Icon(icon2,color: Colors.black12)
                    ],
                  ),
        )
        );
    }

  Widget _createIconWithText(
      {Widget icon, String title, Function function, Widget widget,Widget widget2}) {
    return InkWell(
        onTap: function,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              icon,
              SizedBox(
                height: 5.0,
              ),
              Text(title,
                  style: _textStyle.copyWith(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500)
                      ),
              widget,
              widget2
            ],
          ),
        ),
      );
    }    

    Widget _instructionsContainer (){
      return Container(
          height: 200,
          width: 200,
          color: Colors.red,
        
      );
    }

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
                    color: Colors.red),
              ),
              SizedBox(
                height: 5.0,
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
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right:20),
            child: IconButton(icon: Icon(Icons.check, color:Colors.white,size: 30,), 
            onPressed: ()async {
              print(_changeNameController
                  .text);
              if (_changeNameController
                      .text.isEmpty ||
                  _changeNameController
                          .text.length <
                      2) {
                Toast.show("Invalid Name",
                    context,
                    duration:
                        Toast.LENGTH_LONG,
                    gravity:
                        Toast.BOTTOM);
              } else {
                bool x = await Provider
                        .of<UserData>(
                            context,
                            listen: false)
                    .changeName(
                        name:
                            _changeNameController
                                .text);
                if (x == true) {
                  Toast.show(
                      "Successfully Changed",
                      context,
                      duration: Toast
                          .LENGTH_LONG,
                      gravity:
                          Toast.BOTTOM);
                  Navigator.of(context)
                      .pop();
                  setState(() {});
                } else {
                  Toast.show(
                      "please try again",
                      context,
                      duration: Toast
                          .LENGTH_SHORT,
                      gravity:
                          Toast.BOTTOM);
                }
              }
            },
            ),
          )
        ],
    automaticallyImplyLeading: false,        
        titleSpacing: 0.0,
        title:Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      Text('Settings',style: TextStyle(color: Colors.white,fontSize: _width*0.045),),
    ],
  ),
        backgroundColor: Color(0xffc62828),
      ),
      body: ListView(
        children: <Widget>[
          _divider(),          
          _createIconWithText(
              icon: ImageIcon(AssetImage('images/meScreenIcons/addPhoto.png'),color: Colors.grey[700],),
              title: 'Change Profile Picutre',
              function: ()=>_openImagePicker(context),
              widget: SizedBox(),
              widget2:SizedBox(),
            ),
           _divider(), 
           _createIconWithText(
              icon: SizedBox(),
              title: 'Change your Name',
              function: (){},
              widget: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: _width*0.8,
                   child: TextFormField(
                     controller: _changeNameController,
                    autofocus: true,
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Your New Name',
                      hintStyle: TextStyle(fontSize: _width*0.04),
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
                        Icons.person,
                        color: Colors.black54,
                      ),
                      onPressed: () {}),
                      ),
                      onFieldSubmitted: (_) async {
                        print(_changeNameController
                            .text);
                        if (_changeNameController
                                .text.isEmpty ||
                            _changeNameController
                                    .text.length <
                                2) {
                          Toast.show("Invalid Name",
                              context,
                              duration:
                                  Toast.LENGTH_LONG,
                              gravity:
                                  Toast.BOTTOM);
                        } else {
                          bool x = await Provider
                                  .of<UserData>(
                                      context,
                                      listen: false)
                              .changeName(
                                  name:
                                      _changeNameController
                                          .text);
                          if (x == true) {
                            Toast.show(
                                "Successfully Changed",
                                context,
                                duration: Toast
                                    .LENGTH_LONG,
                                gravity:
                                    Toast.BOTTOM);
                            Navigator.of(context)
                                .pop();
                            setState(() {});
                          } else {
                            Toast.show(
                                "please try again",
                                context,
                                duration: Toast
                                    .LENGTH_SHORT,
                                gravity:
                                    Toast.BOTTOM);
                          }
                        }
                      },
                    ),
                  ),
              ),
              widget2:SizedBox(),
            ),

           _divider(),
           _createIconWithText(
              icon: SizedBox(),
              title: 'Change Your Password',
              function: (){},
              widget: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: _width*0.8,
                   child: TextFormField(
                    autofocus: true,
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your Password',
                      hintStyle: TextStyle(fontSize: _width*0.04),
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
                        Icons.location_on,
                        color: Colors.black54,
                      ),
                      onPressed: () {}),
                      ),
                    ),
                  ),
                  
              ),
              widget2:Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    width: _width*0.8,
                   child: TextFormField(
                    autofocus: true,
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your New Password',
                      hintStyle: TextStyle(fontSize: _width*0.04),
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
                        Icons.location_on,
                        color: Colors.black54,
                      ),
                      onPressed: () {}),
                      ),
                    ),
                  ),
                  
              ),
            ),

           _divider(),

          // _createListButton(
          //             icon1: ImageIcon(AssetImage('images/meScreenIcons/instractions.png')),
          //             icon2: Icons.arrow_forward_ios,
          //             text: Text('Instructions',style: TextStyle(color: Colors.grey[850],fontSize: _width*0.035,fontWeight: FontWeight.w700))
          //              ),
          // _divider(),
          // _createListButton(
          //             icon1: ImageIcon(AssetImage('images/meScreenIcons/instractions.png')),
          //             icon2: Icons.arrow_forward_ios,
          //             text: Text('About',style: TextStyle(color: Colors.grey[850],fontSize: _width*0.035,fontWeight: FontWeight.w700)),
          //             function: (){setState(() { _isTapped=true;});}
                      
          //              ),
          // _divider(),
          // _isTapped==true?_instructionsContainer():SizedBox()                                       
        ],
      ),
    
    );
  }
}