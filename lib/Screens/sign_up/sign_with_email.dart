import 'dart:io';

import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/Screens/Search/searchWidgets/item_details/widgets/zoom_in_and_out_to_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../homeScreen.dart';
import '../../models/http_exception.dart';

class SignWithEmail extends StatefulWidget {
  @override
  _SignWithEmailState createState() => _SignWithEmailState();
}

class _SignWithEmailState extends State<SignWithEmail> {
  String firstName = '';
  String lastName = '';
  String email;
  String password;
  String imgUrl='';
  bool _isSignUpSuccessful=false;
  final FocusNode _lastNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  bool _showPassword = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  File _imageFile;
  bool _isloadImgSuccessful=false;
  String errorMessage;
  Future<void> uploadPic(BuildContext context) async {
    setState(() {
      _isloadImgSuccessful=true;
    });
    try{
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('profiles/${basename(_imageFile.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(_imageFile);
      await uploadTask.onComplete;
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          imgUrl = fileURL;
          _isloadImgSuccessful=false;
        });
      });
    }catch (e){
      Toast.show("Please try again!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      setState(() {
        _isloadImgSuccessful = false;
      });
    }
  }

  Future<void> _getImage(BuildContext context, ImageSource source) async {
    await ImagePicker.pickImage(source: source, maxWidth: 400.0)
        .then((File image) {
        _imageFile = image;
      Navigator.pop(context);
    });
    uploadPic(context);
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
  getLocation(BuildContext context) {
    try {
      Provider.of<Auth>(context, listen: false).getLocation();
    } on HttpException catch (error) {
      switch (error.toString()) {
        case "PERMISSION_DENIED":
          errorMessage = "Please enable Your Location";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      _showErrorDialogLocation(errorMessage,context);
    } catch (error) {
      const errorMessage = 'Could not get your location. Please try again.';
      _showErrorDialogLocation(errorMessage,context);
    }
  }
  void _showErrorDialogLocation(String message,BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Enable Now'),
            onPressed: () {
              getLocation(context);
              Navigator.of(ctx).pop();
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred!'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }
    Future<void> _submit() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        String name = '$firstName $lastName';
        setState(() {
          _isSignUpSuccessful=true;
        });
        try{
          bool auth =await Provider.of<Auth>(context, listen: false).signUpUsingEmail(imgUrl: imgUrl.trim(),name: name.trim(),email: email.trim(),password: password.trim());
          if(auth ==true){
            Toast.show("successfully Sign Up", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
            getLocation(context);
          }
        }on HttpException catch (error) {
          setState(() {
            _isSignUpSuccessful=false;
          });
          switch (error.toString()) {
            case "ERROR_OPERATION_NOT_ALLOWED":
              errorMessage = "Anonymous accounts are not enabled";
              break;
            case "ERROR_EMAIL_ALREADY_IN_USE":
              errorMessage = "Email is already in use";
              break;
            case "ERROR_WEAK_PASSWORD":
              errorMessage = "Your password is too weak";
              break;
            case "ERROR_INVALID_EMAIL":
              errorMessage = "Your email is invalid";
              break;
            case "ERROR_EMAIL_ALREADY_IN_USE":
              errorMessage = "Email is already in use on different account";
              break;
            case "ERROR_INVALID_CREDENTIAL":
              errorMessage = "Your email is invalid";
              break;
            default:
              errorMessage = "An undefined Error happened.";
          }
          _showErrorDialog(errorMessage);
        }catch (error) {
          setState(() {
            _isSignUpSuccessful=false;
          });
          const errorMessage =
              'Could not authenticate you. Please try again later.';
          _showErrorDialog(errorMessage);
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc62828),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(

              children: <Widget>[
            Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowImage(imgUrl: imgUrl==''?'images/meScreenIcons/userPlaceholder.png':imgUrl,isAsset: imgUrl==''?true:false,
                    )));
                  },
                  child:_isloadImgSuccessful? Container(width: 130,height: 130,
                  child: CircularProgressIndicator(backgroundColor: Color(0xffc62828),),
                  decoration: BoxDecoration(color: Color(0xffc62828),shape: BoxShape.circle),)
                  :Container(
                    width: 130,
                    height: 130,
                    child: CircleAvatar(
                      backgroundImage: imgUrl == ''
                          ? AssetImage('images/meScreenIcons/userPlaceholder.png')
                          : NetworkImage(imgUrl),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                InkWell(
                  onTap: () {
                    _openImagePicker(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          "Select Image",
                          style: Theme.of(context)
                              .textTheme
                              .display1
                              .copyWith(color: Colors.white, fontSize: 14),
                        ),
                        Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  cursorColor: Color(0xffc62828),
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    focusedErrorBorder:OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  // ignore: missing_return
                  validator: (val) {
                    if (val.isEmpty || val.length < 2) {
                      return 'Invalid Name';
                    }
                  },
                  onSaved: (val) {
                    firstName = val;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_lastNameNode);
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  focusNode: _lastNameNode,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  cursorColor: Color(0xffc62828),
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  // ignore: missing_return
                  validator: (val) {
                    if (val.isEmpty || val.length < 2) {
                      return 'Invalid Name';
                    }
                  },
                  onSaved: (val) {
                    lastName = val;
                  },
                  onFieldSubmitted: (_) {
                    _lastNameNode.unfocus();
                    FocusScope.of(context).requestFocus(_emailNode);
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  focusNode: _emailNode,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Color(0xffc62828),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  // ignore: missing_return
                  validator: (val) {
                    if (val.isEmpty || !val.contains('@')) {
                      return 'InvalidEmail';
                    }
                  },
                  onSaved: (val) {
                    email = val;
                  },
                  onFieldSubmitted: (_) {
                    _emailNode.unfocus();
                    FocusScope.of(context).requestFocus(_passwordNode);
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  focusNode: _passwordNode,
                  cursorColor: Color(0xffc62828),
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: _showPassword ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        }),
//                      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                    labelText: 'Password',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffc62828)),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  // ignore: missing_return
                  validator: (val) {
                    if (val.isEmpty || val.length < 8) {
                      return 'Invalid password';
                    }
                  },
                  onSaved: (val) {
                    password = val;
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: _isSignUpSuccessful?(){}:_submit,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: _isSignUpSuccessful? CircularProgressIndicator():Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Sign Up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}