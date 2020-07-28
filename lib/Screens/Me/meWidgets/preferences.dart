import 'package:flutter/material.dart';

class Preferences extends StatefulWidget {
  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  
  @override
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
  Divider _divider() {
    return Divider(
      color: Colors.grey[300],
      thickness: 1.0,
      height: 1,
    );
  }    

  Widget _createListButton({Widget icon1,IconData icon2, Text text, Function function , Widget route}){
      return InkWell(
        onTap:(){
          Navigator.push(context, MaterialPageRoute(builder:(context)=>route));
           },
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

    Widget _addPrefrences({Text title , IconData icon}){
      return Container(
        height: 60,
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)
                      ),
                    height: 50,
                    width: _width*0.45,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.add,color:Colors.grey),
                        title
                      ],
                    ),
                  ),
                ),
        ),
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
      Text('Preferences',style: TextStyle(color: Colors.white,fontSize: _width*0.045),),
    ],
  ),
        backgroundColor: Color(0xffc62828),
      ),

      body: ListView(
        children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left:10,top:15),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 120,
                      width: 120,
                      child: Padding(
                      padding:  EdgeInsets.all(_width*0.02),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: FittedBox(child: Image.asset('images/meals.jpg'),fit: BoxFit.cover,),
                       ),
                      ),
                   ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Make Your Favourite List',style: TextStyle(color: Colors.grey[850],fontSize:  _width*0.045),),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 150,
                            child: Text(
                              "Tell us what you prefer so we can serve your taste buds better.",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: TextStyle(fontSize: _width*0.035,color: Colors.grey[600]),
                            ),
                          ),
                        ),

                      ],
                    ),
                  )
                  ],
                ),
              ),
            ) ,
            _divider(),
            SizedBox(height:15),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Wrap(
                children: <Widget>[
              _addPrefrences(title:Text('Vegetarian',style: TextStyle(color:Colors.grey[700],fontSize:_width*0.045,fontWeight: FontWeight.w500),)),
              _addPrefrences(title:Text('Vegan',style: TextStyle(color:Colors.grey[700],fontSize:_width*0.045,fontWeight: FontWeight.w500),)),
              _addPrefrences(title:Text('Pizza',style: TextStyle(color:Colors.grey[700],fontSize:_width*0.045,fontWeight: FontWeight.w500),)),
              _addPrefrences(title:Text('Sea Food',style: TextStyle(color:Colors.grey[700],fontSize:_width*0.045,fontWeight: FontWeight.w500),)),
              _addPrefrences(title:Text('Spicy food',style: TextStyle(color:Colors.grey[700],fontSize:_width*0.045,fontWeight: FontWeight.w500),)),
              _addPrefrences(title:Text('Desert',style: TextStyle(color:Colors.grey[700],fontSize:_width*0.045,fontWeight: FontWeight.w500),)),

                ],
              ),
            )
        ],
      ),
    
    );
  }
}