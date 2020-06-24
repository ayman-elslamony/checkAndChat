import 'dart:io';

import 'package:checkandchat/Providers/resturants.dart';
import 'package:checkandchat/Screens/Search/searchWidgets/item_details/widgets/zoom_in_and_out_to_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:checkandchat/Screens/Me/meWidgets/user_location.dart';
import 'package:checkandchat/generated/locale_keys.g.dart';

class StartReview extends StatefulWidget {
  Category category;
  Review review;
  StartReview({this.category,this.review,});

  @override
  _StartReviewState createState() => _StartReviewState();
}

class _StartReviewState extends State<StartReview> {
  double categoryRating = 0.0;
  File _imageFile;
  String _writeReview ;
  String imgUrl;
  TextEditingController _textEditingController =TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _isWritting = false;
  bool isImageSelected = false;
  bool descTextShowFlag = false;
  bool _showPreviousReviews = false;
  bool _isLoadingReview=false;
  Future<int> _getReview;
  bool result = false;
  Widget previousReviews() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(left: 0.0,bottom: 0.0),
            leading: Image.asset(
              'images/meal.jpg',
              height: 50,
              width: 50,
              fit: BoxFit.fill,
            ),
            title: Text(
              'Bill M.',
              style: TextStyle(
                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: RatingBar(
              initialRating: 0,
              onRatingUpdate: (_){},
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => Icon(
                Icons.stars,
                color: Color(0xffc62828),
              ),
              unratedColor: Colors.grey,
              itemSize: 22,
              ignoreGestures: true,
            ),
            trailing: Text(
              '1 month ago',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 0.0,
          ),
          SizedBox(height: 5.0,),
          InkWell(
              onTap: () {
                setState(() {
                  descTextShowFlag = !descTextShowFlag;
                });
              },
              child: Text(
                ' yes and no  yes and no  yes and no  yes and no  yes and no  yes and no  yes and no  yes and no  yes and no  yes and no  yes and no  yes and no  yes and no  yes and no  yes and no  yes and no ',
                maxLines: descTextShowFlag ? 8 : 3,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              )),
        ],
      ),
    );
  }

  Future<void> _getImage(BuildContext context, ImageSource source) async {
    await ImagePicker.pickImage(source: source, maxWidth: 400.0)
        .then((File image) async {
      if(image != null){
        setState(() {
          _imageFile = image;
          isImageSelected = true;
        });
      }
      Navigator.of(context).pop();
    });
  }
  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 120.0,
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              Text(
                'Pick an Image',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton.icon(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.blue,
                    textColor: Theme.of(context).primaryColor,
                    label: Text(
                      'Use Camera',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _getImage(context, ImageSource.camera);
                      // Navigator.of(context).pop();
                    },
                  ),
                  FlatButton.icon(
                    icon: Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.blue,
                    textColor: Theme.of(context).primaryColor,
                    label: Text(
                      'Use Gallery',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _getImage(context, ImageSource.gallery);
                      // Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ]),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    print(widget.review);
    if(widget.review != null){
      print(widget.review.rating);
     if(widget.review.rating != null){
       categoryRating = widget.review.rating;
     }
     print(widget.review.comment);
      if(widget.review.comment !='null'){
        _textEditingController.text = widget.review.comment;
      }
     print(widget.review.imgUrlForReview);
      if(widget.review.imgUrlForReview.isNotEmpty){
        isImageSelected =true;
        imgUrl=widget.review.imgUrlForReview;
      }
    }
    _getReview = Provider.of<Categorys>(context, listen: false)
        .getAllReviews(category: widget.category);
  }
  Future<void> _onRefresh() async {
    setState(() {
      result = true;
    });
  }
  Widget _iconWithTitle({String title, Widget icon}) {
    return Row(
      children: <Widget>[
        icon,
        Padding(
          padding: const EdgeInsets.only(left: 3.5, right: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
        )
      ],
    );
  }

  Widget _iconWithTitleAndNumbers(
      {String title,
        int number,
        Widget icon,
        Function function,
        bool isColorChange}) {
    return InkWell(
      onTap: function,
      child: Row(
        children: <Widget>[
          icon,
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 14,
                  color: isColorChange ? Colors.red : Colors.black54),
            ),
          ),
          Text(
            number.toString(),
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isColorChange ? Colors.red : Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget createComment({Review review, int index}) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(left: 0.0, bottom: 1.0),
            leading: CircleAvatar(
                radius: 25.0,
                child: ClipOval(
                    child: review.userImgUrl == null
                        ? Image.asset(
                      'images/user.png',
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    )
                        : FadeInImage.assetNetwork(
                      placeholder: 'images/user.png',
                      image: review.userImgUrl,
//                fit: BoxFit.fill,
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                      fadeInCurve: Curves.bounceIn,
                    ))),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  review.userName == null ? '' : review.userName,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Text(
                    DateFormat('dd/MM/yyyy hh:mm')
                        .format(DateTime.parse(review.date)),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    )),
                //            SizedBox(
                //              width: 6,
                //            ),
                //            Container(
                //              color: Colors.red,
                //              padding: EdgeInsets.all(3.0),
                //              child: Text(
                //                'Elite \'29',
                //                style: TextStyle(
                //                    fontSize: 12,
                //                    color: Colors.white),
                //              ),
                //            )
              ],
            ),
            subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _iconWithTitle(
                            icon: ImageIcon(
                                AssetImage('images/meScreenIcons/friends.png'),
                                size: 18),
                            title: review.friendsCount),
                        _iconWithTitle(
                            icon: ImageIcon(
                                AssetImage(
                                    'images/meScreenIcons/addReview.png'),
                                color: Colors.grey[700],
                                size: 18),
                            title: review.userRating),
                        _iconWithTitle(
                            icon: ImageIcon(
                              AssetImage('images/meScreenIcons/photo.png'),
                              color: Colors.grey[700],
                              size: 18,
                            ),
                            title: review.userPhoto),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        review.rating == 0.0
                            ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                        )
                            : RatingBar(
                          initialRating: review.rating,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                          EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.stars,
                            color: Color(0xffc62828),
                          ),
                          unratedColor: Colors.grey,
                          itemSize: 20,
                          ignoreGestures: true,
                          onRatingUpdate: (double value) {},
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          // Row(
          //   // mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     review.rating == 0.0?SizedBox(width: MediaQuery.of(context).size.width*0.25,):RatingBar(
          //       initialRating: review.rating,
          //       direction: Axis.horizontal,
          //       allowHalfRating: true,
          //       itemCount: 5,
          //       itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
          //       itemBuilder: (context, _) => Icon(
          //         Icons.stars,
          //         color: Color(0xffc62828),
          //       ),
          //       unratedColor: Colors.grey,
          //       itemSize: 22,
          //       ignoreGestures: true,
          //       onRatingUpdate: (double value) {},
          //     ),

          //   ],
          // ),
          SizedBox(
            height: 5,
          ),
          review.imgUrlForReview.isEmpty
              ? SizedBox()
              : FadeInImage.assetNetwork(
            placeholder: 'images/ImagePlaceholder.png',
            image: review.imgUrlForReview,
//                fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
            fadeInCurve: Curves.bounceIn,
          ),
          review.comment == 'null' || review.comment.isEmpty
              ? SizedBox()
              : Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(review.comment,
                      maxLines: descTextShowFlag ? 8 : 2,
                      textAlign: TextAlign.start,
                      style:
                      TextStyle(color: Colors.black54, fontSize: 15)),
                  review.comment.length > 80
                      ? InkWell(
                    onTap: () {
                      setState(() {
                        descTextShowFlag = !descTextShowFlag;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        descTextShowFlag
                            ? Text(
                          "Show Less",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16),
                        )
                            : Text("Show More",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16))
                      ],
                    ),
                  )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _iconWithTitleAndNumbers(
                    icon: ImageIcon(
                        AssetImage('images/meScreenIcons/useful.png'),
                        color: review.isUseful ? Colors.red : Colors.black54,
                        size: 19),
                    title: 'Useful',
                    number: review.useful,
                    function: () {
                      Provider.of<Categorys>(context, listen: false)
                          .updateTransactionsForCategory(
                          review: review,
                          type: 'useful',
                          category: widget.category);
                    },
                    isColorChange: review.isUseful),
                _iconWithTitleAndNumbers(
                    icon: ImageIcon(
                        AssetImage('images/meScreenIcons/happy.png'),
                        color: review.isFunny ? Colors.red : Colors.black54,
                        size: 20),
                    title: 'Funny',
                    number: review.funny,
                    function: () {
                      Provider.of<Categorys>(context, listen: false)
                          .updateTransactionsForCategory(
                          review: review,
                          type: 'funny',
                          category: widget.category);
                    },
                    isColorChange: review.isFunny),
                _iconWithTitleAndNumbers(
                    icon: ImageIcon(AssetImage('images/meScreenIcons/cool.png'),
                        color: review.isColl ? Colors.red : Colors.black54,
                        size: 20),
                    title: 'Cool',
                    number: review.cool,
                    function: () {
                      Provider.of<Categorys>(context, listen: false)
                          .updateTransactionsForCategory(
                          review: review,
                          type: 'cool',
                          category: widget.category);
                    },
                    isColorChange: review.isColl),
              ],
            ),
          )
        ],
      ),
    );
  }
  _startReviewFunction() {
    setState(() {
      _isLoadingReview = true;
    });
    if(widget.review != null){
      Provider.of<Categorys>(context,listen: false).editAReview(resturant: widget.category,review: widget.review,imageFile: _imageFile,comment: _writeReview,ratingCount: categoryRating.toString()).then((x){
        if(x == 'true'){
          Toast.show("successfully editing!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          Navigator.of(context).pop(true);
        }else if(x == 'false'){
          Toast.show("failed added!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        }else{
          Toast.show("Please add something!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        }
        setState(() {
          _isLoadingReview = false;
        });
      });
    }else{
      Provider.of<Categorys>(context,listen: false).startAReview(resturant: widget.category,imageFile: _imageFile,comment: _writeReview,ratingCount: categoryRating.toString()).then((x){
        if(x == 'true'){
          Toast.show("successfully added!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          Navigator.of(context).pop(true);
        }else if(x == 'false'){
          Toast.show("failed added!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        }else{
          Toast.show("Please add something!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        }
        setState(() {
          _isLoadingReview = false;
        });
      });

    }

}
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    if(result){
      _getReview = Provider.of<Categorys>(context, listen: false)
          .getAllReviews(category: widget.category);
      result =false;
    }
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xffc62828),
        title: Text(
          widget.category.name,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: BackButton(color: Colors.white,onPressed: (){
          Navigator.of(context).pop(false);
        },),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check,color: Colors.white,),
           onPressed:_isLoadingReview?(){}:_startReviewFunction)
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 12,),
                Center(
                  child: RatingBar(
                    initialRating: categoryRating,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.stars,
                      color: Color(0xffc62828),
                    ),
                    unratedColor: Colors.grey,
                    itemSize: 28,
                    onRatingUpdate: (double value) {
                      categoryRating = value;
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.20,
                  child: TextFormField(
                    
                    controller: _textEditingController,
                    onTap: () {
                      setState(() {
                        _isWritting = true;
                      });
                    },
                    autofocus: false,
                    minLines: 8,
                    maxLines: 11,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20.0),
                        border: InputBorder.none,
                        hintText:
                            'Example: This is probably my favorite steakhouse in town'),
                    focusNode: _focusNode,
                    onChanged: (val){
                      _writeReview = val;
                    },
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                InkWell(
                  onTap: isImageSelected == false ?(){_openImagePicker(context);}:(){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ShowImage(isFile: true,imageFile: _imageFile,)));
                  },
                  child: isImageSelected == false ?Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],),
                      alignment: Alignment.center,
                      width:_width*0.6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9.0,horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ImageIcon(
                                AssetImage(
                                    'images/meScreenIcons/addPhoto.png'),
                                color: Colors.grey[700],
                                size: 20),
                            Text(
                              'Add',
                              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                            )
                          ],
                        )

                      ),
                    ),
                  ):
                  Stack(
                    children: <Widget>[
                      imgUrl!=null?Image.network(imgUrl,fit: BoxFit.fill,height: 200,width: MediaQuery.of(context).size.width,)
                          :Image.file(_imageFile,fit: BoxFit.fill,height: 200,width: MediaQuery.of(context).size.width,),
                      Positioned(
                          right: 5.0,
                          top: 5.0
                          ,child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color:Colors.black45
                            ),
                            child: IconButton(icon: Icon(Icons.clear,color: Colors.white,), onPressed: (){
                              if(widget.review !=null){
                                widget.review.imgUrlForReview ='';
                              }
                        setState(() {
                            isImageSelected = false;
                        });
                      }),
                          )
                      )
                    ],
                  ),
                ),
                SizedBox(height:20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_focusNode);
                        setState(() {
                          _isWritting = true;
                          _showPreviousReviews =false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Aa',
                          style: TextStyle(
                              fontSize: 18,
                              color: _isWritting ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.stars,color: _showPreviousReviews?Colors.blue:Colors.grey,),
                        onPressed: () {
                          _focusNode.unfocus();
                          setState(() {
                            _isWritting = false;
                            _showPreviousReviews = true;
                          });
                        }),
                    Spacer(),
                    RaisedButton(
                      color: Colors.transparent,
                      elevation: 0.0,
                      onPressed: _isLoadingReview?(){}:_startReviewFunction,
                      child: _isLoadingReview?CircularProgressIndicator(backgroundColor: Colors.blue,):Text(
                        'POST REVIEW',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                _showPreviousReviews?SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Previews Reviews',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      FutureBuilder(
                          future: _getReview,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                  height:  MediaQuery.of(context).size.height * 0.45,
                                  width: 70,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.red,
                                      )));
                            } else {
                              if (snapshot.error != null) {
                                return SizedBox(
                                  height:  MediaQuery.of(context).size.height * 0.45,
                                  child: Center(
                                    child: Text('An error occurred!'),
                                  ),
                                );
                              } else {
                                if(snapshot.data == 0){
                                  return SizedBox();
                                }else{
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8.0),
                                    child: Material(
                                      type: MaterialType.card,
                                      color: Colors.grey[200],
                                      borderOnForeground: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RefreshIndicator(
                                          onRefresh: _onRefresh,
                                          color: Colors.red,
                                          backgroundColor: Colors.white,
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                  height: MediaQuery.of(context).size.height * 0.45,
                                                  child: Consumer<Categorys>(
                                                    builder: (ctx, reviewData, _) =>
                                                        ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: reviewData
                                                                .allReviews.length,
                                                            itemBuilder:
                                                                (context, index) {
                                                              return createComment(
                                                                  index: index,
                                                                  review: reviewData
                                                                      .allReviews[
                                                                  index]);
                                                            }),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          }),
                    ],
                  ),
                ):SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}