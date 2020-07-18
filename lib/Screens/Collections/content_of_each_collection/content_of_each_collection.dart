import 'package:carousel_pro/carousel_pro.dart';
import 'package:checkandchat/Providers/resturants.dart';
import 'package:checkandchat/Screens/Search/searchWidgets/item_details/widgets/zoom_in_and_out_to_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../Search/searchWidgets/item_details/item_details.dart';
import 'package:toast/toast.dart';
class ContentOfCollection extends StatefulWidget {
  String collectionName;
  String imgUrlForCollection;
  String lastUpdate;
  bool isPublic;
  String collectionId;
  int countOfCategory;
  String friendId;
  bool isMeFollowing;
  ContentOfCollection(
      {this.countOfCategory,
      this.collectionName,
      this.imgUrlForCollection,
      this.isPublic,
        this.friendId='',
        this.isMeFollowing,
        this.collectionId,
      this.lastUpdate});

  @override
  _ContentOfCollectionState createState() => _ContentOfCollectionState();
}

class _ContentOfCollectionState extends State<ContentOfCollection> {
  _refreshToGetContentOfCollection() {
    if(widget.friendId ==''){
      Provider.of<Categorys>(context, listen: false).getAllCollections();
    }else{
      Provider.of<Categorys>(context, listen: false).getAllCollectionsForFriend(userId: widget.friendId);
    }

  }

  Widget _createImage({String imgUrl}) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(6),
          child: FadeInImage.assetNetwork(
            placeholder: 'images/placeholder.png',
            image: imgUrl,
            height: 85,
            width: 90,
            fit: BoxFit.cover,
            fadeInCurve: Curves.bounceIn,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final _textStyle = Theme.of(context).textTheme.title;
    Widget _createResultCard({Category result}) {
      print(result.id);
      String _priceLevel = '';
      if (result.priceLevel == 'PriceLevel.free') {
        _priceLevel = 'free';
      }
      if (result.priceLevel == 'PriceLevel.inexpensive') {
        _priceLevel = 'inexpensive';
      }
      if (result.priceLevel == 'PriceLevel.moderate') {
        _priceLevel = 'moderate';
      }
      if (result.priceLevel == 'PriceLevel.expensive') {
        _priceLevel = 'expensive';
      }
      if (result.priceLevel == 'PriceLevel.veryExpensive') {
        _priceLevel = 'veryExpensive';
      }
      String type = result.types[0];
      result.types.forEach((t) {
        if (t != result.types[0] &&
            t != 'point_of_interest' &&
            t != 'establishment') {
          type = type + ',$t';
        }
      });
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetails(
                        category: result,
                        isCommingFromCollection: true,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200],
            ),
            width: _width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: <Widget>[
                        result.imgUrl.isEmpty
                            ? SizedBox()
                            : Row(
                              children: <Widget>[
                                result.imgUrl.length == 1
                                    ? SizedBox(
                                    height: _height*0.15,
                                    width: _width*0.25,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: FadeInImage.assetNetwork(
                                          placeholder: 'images/placeholder.png',
                                          image: result.imgUrl[0],
                                          fit: BoxFit.fill,
                                          fadeInCurve: Curves.bounceIn,
                                      ),
                                        ))
                                    : SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              _createImage(
                                                  imgUrl:
                                                      result.imgUrl[index]),
                                          itemCount: result.imgUrl.length,
                                        ))
                              ],
                            ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            result.name,
                            style: _textStyle.copyWith(
                                fontSize: _width * 0.05,
                                color: Colors.black87),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          RatingBar(
                            initialRating: result.rating,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                            itemBuilder: (context, _) => Icon(
                              Icons.stars,
                              color: Color(0xffc62828),
                            ),
                            unratedColor: Colors.grey,
                            itemSize: 22,
                            ignoreGestures: true,
                            onRatingUpdate: (double value) {},
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Text(
                            type,
                            style: _textStyle.copyWith(
                                fontSize: _width * 0.04,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                          result.openNow == 'none'
                              ? SizedBox()
                              : Text(
                                  result.openNow == 'true'
                                      ? 'Open Now'
                                      : 'Closed Now',
                                  style: _textStyle.copyWith(
                                      fontSize: _width * 0.04,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500),
                                ),
                          Padding(padding: EdgeInsets.all(2)),
                          Text(
                            result.vicinity,
                            style: _textStyle.copyWith(
                                fontSize: _width * 0.032,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          result.priceLevel == ''
                              ? SizedBox()
                              : Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.bookmark,
                                      color: Colors.green,
                                      size: _width * 0.045,
                                    ),
                                    Text(
                                      ' price level ',
                                      style: _textStyle.copyWith(
                                        fontSize: _width * 0.033,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Text(
                                      _priceLevel,
                                      style: _textStyle.copyWith(
                                        fontSize: _width * 0.033,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                  widget.friendId==''?Column(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.bookmark,color: Color(0xffc62828),size: 30,), onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25.0))),
                            contentPadding: EdgeInsets.only(top: 10.0),
                           title: SizedBox(),
                            content: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: <Widget>[
                                 Text(
                                   'Do you want To remove From collection',
                                   textAlign: TextAlign.center,
                                   style: TextStyle(
                                     color: Colors.red,
                                     fontSize: _width*0.032,
                                     fontWeight: FontWeight.bold
                                   ),
                                 ),
                               ],
                           ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Ok',
                                    style: TextStyle(
                                        color: Colors.red,
                                         fontWeight: FontWeight.bold,
                                         fontSize: _width*0.032)),
                                onPressed: () async{
                                  bool x= await Provider.of<Categorys>(context,listen: false).removePlaceFromCollection(collectionName: widget.collectionName,categoryId: result.id,img: result.imgUrl);
                                  if(x == true){
                                    Toast.show("Successfully removed", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                                    Navigator.of(context).pop();
                                    setState(() {

                                    });
                                  }else{
                                    Toast.show("please try again", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                                  }
                                },
                              ),FlatButton(
                                child: Text('Cancel',
                                    style: TextStyle(
                                        color: Colors.black54,
                                         fontWeight: FontWeight.bold,
                                         fontSize: _width*0.032)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );

                      })
                    ],
                  ):SizedBox()
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${toBeginningOfSentenceCase(widget.collectionName)}',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.white, // Here
          ),
          actions: <Widget>[
            widget.isMeFollowing !=null?Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () async{
                  if(widget.isMeFollowing){
                    await Provider.of<Categorys>(context,listen: false).deleteFromFollowingCollections(
                      collectionId: widget.collectionId,
                    );
                  }else{
                    await Provider.of<Categorys>(context,listen: false).addToFollowingCollections(
                      friendId: widget.friendId,
                      collectionId: widget.collectionId,
                    );
                  }

                },
                color: Colors.white30,
                child: Text(
                  widget.isMeFollowing?'UnFollow':'Follow',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
              ),
            ):SizedBox()
          ],
          backgroundColor: Color(0xffc62828),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 200,
              child: Stack(fit: StackFit.expand, children: <Widget>[
                FadeInImage.assetNetwork(
                  placeholder: 'images/placeholder.png',
                  image: widget.imgUrlForCollection,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: ListTile(
                    title: Text(
                      widget.collectionName,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      maxLines: 2,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        //hh:mm
                        '${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.lastUpdate))}',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${widget.countOfCategory == 0 ? 'No' : widget.countOfCategory} places',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        maxLines: 2,
                      ),
                    ),
                  ),
                )
              ]),
            ),
            FutureBuilder(
                future: Provider.of<Categorys>(context, listen: false)
                    .getCategorysForSpecificCollection(
                  id: widget.friendId,
                        collectionName: widget.collectionName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        height: _height * 0.60,
                        width: _width,
                        child: Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        )));
                  } else {
                    if (snapshot.error != null) {
                      return SizedBox(
                        height: _height* 0.60,
                        child: Center(
                          child: Text('An error occurred!'),
                        ),
                      );
                    } else {
                      if (snapshot.data.length == 0) {
                        return SizedBox(
                          height: _height * 0.60,
                          width: _width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'There is no Places yet',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.red),
                              )
                            ],
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: _height * 0.60,
                          width: _width,
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) =>
                                  _createResultCard(
                                      result: snapshot.data[index])),
                        );
                      }
                    }
                  }
                }),
          ],
        ));
  }
}