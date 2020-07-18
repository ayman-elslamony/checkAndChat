import 'package:flutter/material.dart';

class AddReview extends StatefulWidget {
  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  
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
        title: Text('Add Review',style: TextStyle(color: Colors.white,fontSize: _width*0.045),),
        bottom: PreferredSize(
          child: Padding(
            padding:  EdgeInsets.all(_width*0.018),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: _width * 0.95,
                    child: TextFormField(
                      style: TextStyle(fontSize: _width*0.035),
                          decoration: InputDecoration(
                            hintText: 'Search For Resturants and Caffes',
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: Colors.white)
                                ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: Colors.white),
                                ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(color: Colors.white),                              
                                ),
                            contentPadding: new EdgeInsets.symmetric(vertical: 15.0),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.black38,
                                  size: _width*0.05,
                                ),
                                onPressed: () {}),
                          ),
                      ),
                  ),
                ],
              ),
          ),
          
          preferredSize: Size(_width, _height * 0.06),
        ),
        backgroundColor: Color(0xffc62828),
      ),
    );
  }
}