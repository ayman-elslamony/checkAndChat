import 'package:checkandchat/Providers/resturants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowCollections extends StatefulWidget {
  Category category;
  BuildContext buildContext;

  ShowCollections({this.category,this.buildContext});

  @override
  _ShowCollectionsState createState() => _ShowCollectionsState();
}

class _ShowCollectionsState extends State<ShowCollections> {
  final databaseReference = Firestore.instance;
  bool _isAddingToCollection =false;
  bool _isCollectionRemove=false;
  Future<List<DocumentSnapshot>> collections;
 @override
  void initState() {
    super.initState();
    collections = Provider.of<Categorys>(context, listen: false).getAllCollections();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: Provider.of<Categorys>(context, listen: false).getAllCollections(),
        builder: (context, snapshot) {
          print(snapshot.data);
           if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                height: 70,
                width: 70,
                child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    )));
          } else {
            if (snapshot.error != null) {
              return SizedBox(
                height: 70,
                child: Center(
                  child: Text('An error occurred!'),
                ),
              );
            } else {
              if(snapshot.data.length == 0){
                return Container(
                    height: 50,
                    child: Center(child: Text('There is no Collection',style: TextStyle(color: Colors.blue),),));
              }else{
                return Container(
                  height: 70.0*snapshot.data.length,
                  width: 350,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context,index)=>ListTile(
                      onTap: () async{
                        setState(() {
                          _isAddingToCollection =true;
                        });
                        String x= await Provider.of<Categorys>(context,listen: false).addToCollection(resturant: widget.category,collectionName: snapshot.data[index]['nameOfCollection']);
                        print(x);
                        if(x=='true'){
                        //  Toast.show( context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                          Navigator.of(context).pop();
                        }else if(x=='false'){
                         // Toast.show("failed to added please try again", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                        }else if(x=='already exits'){
                          //Toast.show("Already Exists", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                          Navigator.of(context).pop();
                        }
                        else{
                          //Toast.show("please try again", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                        }

                        setState(() {
                          _isAddingToCollection =false;
                        });

                      },
                      title: Text(
                        snapshot.data[index]['nameOfCollection'] == null?'':snapshot.data[index]['nameOfCollection'],
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      subtitle: Text(
                        snapshot.data[index]['countOfCategory']==null?'1':snapshot.data[index]['countOfCategory'].toString(),
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      leading: _isAddingToCollection?CircularProgressIndicator(backgroundColor: Colors.blue,):
                      FadeInImage.assetNetwork(placeholder: 'images/placeholder.png',
                          image: snapshot.data[index]['categoryImage']==null?'images/placeholder.png':snapshot.data[index]['categoryImage'],width: 70,
                          height: 80,
                          fit: BoxFit.fill ),
                      trailing: InkWell(
                        child:Text(
                          'Remove',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                        onTap: () async{
                          bool x= await Provider.of<Categorys>(context,listen: false).removeCollection(collectionName: snapshot.data[index]['nameOfCollection']);
                          if(x == true){
                            //Toast.show("Successfully removed", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                            Navigator.of(context).pop();
                          }else{
                           // Toast.show("please try again", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                          }
                        },
                      ),
                      isThreeLine: false,
                    ),
                  ),
                );
              }
            }
          }
        }
      ),
    );
  }
}