import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:checkandchat/Providers/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../models/http_exception.dart';
import '../homeScreen.dart';
import 'sign_with_email.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email;
  String password;
  String imgUrl;
  String name;
  final FocusNode _passwordNode = FocusNode();
  bool _showPassword = false;
  bool _isSignUp = false;
  String errorMessage;
  bool _isSignInSuccessful=false;
  bool _isSignInUsingFBSuccessful=false;
  bool _isSignInUsingGoogleSuccessful=false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var loggedIn = false;
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
  Future<void> _submitForm() async {
    if(!_isSignUp){
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        setState(() {
          _isSignInSuccessful = true;
        });
        try {
           bool auth = await Provider.of<Auth>(context, listen: false).signInUsingEmail(
              email: email.trim(), password: password.trim());
            if (auth == true) {
              await getLocation();
              Toast.show(
                  "successfully Sign Up", context, duration: Toast.LENGTH_SHORT,
                  gravity: Toast.BOTTOM);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }
        } on HttpException catch (error) {
          setState(() {
                _isSignInSuccessful = false;
              });
          switch (error.toString()) {
            case "ERROR_INVALID_EMAIL":
              errorMessage = "Your email address appears to be malformed.";
              break;
            case "ERROR_WRONG_PASSWORD":
              errorMessage = "Your password is wrong.";
              break;
            case "ERROR_USER_NOT_FOUND":
              errorMessage = "User with this email doesn't exist.";
              break;
            case "ERROR_USER_DISABLED":
              errorMessage = "User with this email has been disabled.";
              break;
            case "ERROR_TOO_MANY_REQUESTS":
              errorMessage = "Too many requests. Try again later.";
              break;
            case "ERROR_OPERATION_NOT_ALLOWED":
              errorMessage = "Signing in with Email and Password is not enabled.";
              break;
            default:
              errorMessage = "An undefined Error happened.";
          }
          _showErrorDialog(errorMessage);
        } catch (error) {
          setState(() {
            _isSignInSuccessful = false;
          });
          const errorMessage =
              'Could not authenticate you. Please try again later.';
          _showErrorDialog(errorMessage);
        }
      }
    }
  }

  getLocation() async{
    try {
      await Provider.of<Auth>(context, listen: false).getLocation();
    } on HttpException catch (error) {
      switch (error.toString()) {
        case "PERMISSION_DENIED":
          errorMessage = "Please enable Your Location";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      _showErrorDialogLocation(errorMessage);
    } catch (error) {
      const errorMessage = 'Could not get your location. Please try again.';
      _showErrorDialogLocation(errorMessage);
    }
  }
  void _showErrorDialogLocation(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Enable Now'),
            onPressed: () {
              getLocation();
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
    return Scaffold(
      body:
      SafeArea(
        child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40.0,
                        ),
                            ColorizeAnimatedTextKit(
                                totalRepeatCount: 9,
                                pause: Duration(milliseconds: 1000),
                                isRepeatingAnimation: true,
                                speed: Duration(seconds: 1),
                                text: [' Check And Chat '],
                                textStyle: TextStyle(
                                    fontSize: 25, fontFamily: "Horizon"),
                                colors: [
                                  Colors.redAccent,
                                  Colors.red,
                                  Colors.grey[400],
                                  Colors.red,
                                  Colors.grey[400],
                                  Colors.red,
                                ],
                                textAlign: TextAlign.start,
                                alignment: AlignmentDirectional
                                    .topStart // or Alignment.topLeft
                            ),
                        SizedBox(
                          height: _isSignUp ? 250 : 100,
                        ),
                        _isSignUp
                            ? RaisedButton(
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SignWithEmail()));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Continue with Email',
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
                              )
                            : SizedBox(),
                        _isSignUp
                            ? SizedBox()
                            : TextFormField(
                                autofocus: false,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Color(0xffc62828),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  focusedErrorBorder:OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffc62828)),
                                      borderRadius: BorderRadius.all(Radius.circular(10))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffc62828)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffc62828)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffc62828)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
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
                                  FocusScope.of(context)
                                      .requestFocus(_passwordNode);
                                },
                              ),
                        _isSignUp
                            ? SizedBox()
                            : SizedBox(
                                height: 10.0,
                              ),
                        _isSignUp
                            ? SizedBox()
                            : TextFormField(
                                focusNode: _passwordNode,
                                autofocus: false,
                                cursorColor: Colors.red,
                                obscureText: !_showPassword,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        _showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: _showPassword
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _showPassword = !_showPassword;
                                        });
                                      }),
                                  labelText: 'Password',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffc62828)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffc62828)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffc62828)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
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
                        _isSignUp
                            ? SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    RaisedButton(
                                      color: Color(0xffc62828),
                                      onPressed: () {
                                        _submitForm();
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child:Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child:  _isSignInSuccessful?CircularProgressIndicator():Text(
                                          'Log In',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: RaisedButton(
                            color: Colors.red,
                            onPressed:
                                () async{
                                  setState(() {
                                    _isSignInUsingGoogleSuccessful=true;
                                  });
                                  bool x = await Provider.of<Auth>(context, listen: false).signInUsingFBorG('G');
                                    if(x==false){
                                      Toast.show("Please try again!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                      setState(() {
                                        _isSignInUsingGoogleSuccessful=false;
                                      });
                                    }else{
                                      await getLocation();
                                      Toast.show("successfully Sign Up", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
                                    }

                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _isSignInUsingGoogleSuccessful?Center(child: CircularProgressIndicator(),):Row(
                                children: <Widget>[
                                  ImageIcon(
                                    AssetImage('images/google.png'),
                                    color: Colors.white,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Continue with Google',
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
                        ),
                        // RaisedButton(
                        //   color: Colors.blue[900],
                        //   onPressed: () async{
                        //     setState(() {
                        //       _isSignInUsingFBSuccessful=true;
                        //     });
                        //     await Provider.of<Auth>(context, listen: false).signInUsingFBorG("FB").then((x){
                        //       if(x==false){
                        //         Toast.show("Please try again!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                        //         setState(() {
                        //           _isSignInUsingFBSuccessful=false;
                        //         });
                        //       }else{
                        //         Toast.show("successfully Sign Up", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                        //         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
                        //         getLocation();
                        //       }
                        //     });
                        //   },
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(10))),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: _isSignInUsingFBSuccessful?Center(child: CircularProgressIndicator(),):Row(
                        //       children: <Widget>[
                        //         ImageIcon(
                        //           AssetImage(
                        //             'images/facebook.png',
                        //           ),
                        //           color: Colors.white,
                        //         ),
                        //         Expanded(
                        //           child: Text(
                        //             'Continue with Facebook',
                        //             textAlign: TextAlign.center,
                        //             style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _isSignUp
                                    ? 'I have acount '
                                    : 'Don\'t have acount? ',
                                style:
                                    TextStyle(color: Colors.black, fontSize: 16),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _isSignUp = !_isSignUp;
                                  });
                                },
                                child: Text(
                                  _isSignUp ? 'Sign In' : 'Sign up',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}