import 'package:checkandchat/Providers/resturants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class NewCollection extends StatefulWidget {
  Category category;
  bool isNotHaveCategory ;
  NewCollection({this.category,this.isNotHaveCategory= false});

  @override
  _NewCollectionState createState() => _NewCollectionState();
}

class _NewCollectionState extends State<NewCollection> {
 bool _isNameAvilable =false;
 bool _isPublic =false;
 String _collectionName ;
 bool _isCollectionLoading=false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      title: Text(
        'New Collection',
        textAlign: TextAlign.center,
      ),
      content:Container(
      child:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
                onChanged: (val){
                  if(val.isNotEmpty){
                    setState(() {
                      _isNameAvilable=true;
                    });
                    _collectionName = val;
                  }else{
                    setState(() {
                      _isNameAvilable=false;
                    });
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Make Collection Public',
                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                  Switch(
                      activeTrackColor: Colors.redAccent,
                      activeColor: Colors.red,
                      value: _isPublic,
                      onChanged: (val) {
                        setState(() {
                          _isPublic = val;
                        });
                      })
                ],
              )
              ,Text('Allows this Collection to be openly featured on yelp and alerts followers when make updates A non-puplic Collection can still be visible to others if you share a link to it',style: TextStyle(color: Colors.grey,fontSize: 12),)
            ],
          ),
        ),
      ),
    ),actions: <Widget>[
      FlatButton(
        child: Text('Cancel',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
     FlatButton(
        child: _isCollectionLoading?CircularProgressIndicator(backgroundColor: Colors.blue,):Text('Create',style: TextStyle(color: _isNameAvilable ?Colors.black54:Colors.grey,fontWeight: FontWeight.bold)),
        onPressed:  _isNameAvilable ?() async{
          setState(() {
            _isCollectionLoading =true;
          });
          String x= await Provider.of<Categorys>(context,listen: false).createCollection(isPublic: _isPublic,category: widget.category,nameOfCollection: _collectionName,withoutAddCategory: widget.isNotHaveCategory);
          if(x=='true'){
            Toast.show("Successfully created and added to collection", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }else if(x == 'specific create'){
            Toast.show("Successfully created", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
            Navigator.of(context).pop();
          }else if(x=='false'){
            Toast.show("failed to create please try again", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          }else{
            Toast.show("please insert collection name", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          }
          setState(() {
            _isCollectionLoading =false;
          });

        }:null
      ),
    ],);
  }
}