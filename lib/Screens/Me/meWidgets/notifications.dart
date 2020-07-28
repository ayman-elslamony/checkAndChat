import 'package:checkandchat/Screens/Me/meScreens.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
    Divider _divider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1.0,
      height: 1,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;




      Widget _createListButton({Widget image,IconData icon2, Text text, Function function , Widget route}){
      return InkWell(
        onTap:(){
          Navigator.push(context, MaterialPageRoute(builder:(context)=>route));
           },
        child: ListTile(
          leading: image ,
          dense: true,
          title: Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(right:_width*0.03),child: text,),
                      Spacer(),
                      Icon(icon2,color: Colors.black12,size: 20,)
                    ],
                  ),
          
        )
        );
      
    }    

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
      Text('Notifications',style: TextStyle(color: Colors.white,fontSize: _width*0.045),),
    ],
  ),
        backgroundColor: Color(0xffc62828),
      ),

      body: ListView(
        children: <Widget>[
           
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()            
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
            
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
           ),
         _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
            
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
            
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
            
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
            
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()            
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
            
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
           ),
         _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
            
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
            
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
            
           ),
          _divider(),
           _createListButton(
             image: CircleAvatar(backgroundImage: AssetImage('images/ahmed.jpg'),),
             text: Text('Ahmed Magdy Reacted your Review',style: TextStyle(fontSize: _width*0.03),),
             icon2: Icons.arrow_forward_ios,
             route: MeScreens()
            
           ),
          _divider(),
        ],
      ),
    );
  }
}