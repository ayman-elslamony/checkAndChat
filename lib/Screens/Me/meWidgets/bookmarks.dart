import 'package:flutter/material.dart';

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  
  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,size: _width*0.06,),
          onPressed:() => Navigator.pop(context, false),
        )
,
        title: Text('Bookmarks',style: TextStyle(color: Colors.white,fontSize: _width*0.045),),
        backgroundColor: Color(0xffc62828),
      ),
    );
  }
}