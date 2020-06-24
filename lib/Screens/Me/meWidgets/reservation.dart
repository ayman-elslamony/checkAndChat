import 'package:flutter/material.dart';

class Reservations extends StatefulWidget {
  @override
  _ReservationsState createState() => _ReservationsState();
}

class _ReservationsState extends State<Reservations> {
  
  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;


        

    return Scaffold(
      appBar: AppBar(
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
              Text('Reservations',style: TextStyle(color: Colors.white,fontSize: _width*0.045),),
                ],
            ),
                backgroundColor: Color(0xffc62828),
              ),

    );
  }
}