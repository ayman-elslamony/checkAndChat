import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      body: Container(
      height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/appIcon.png',height: 60,width: 60,fit: BoxFit.fill,),
              SizedBox(
                height: 15.0,
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
            ],
          ))),
    );
  }
}
