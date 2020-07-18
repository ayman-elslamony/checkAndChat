import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import '../../../../Screens/Search/searchWidgets/item_details/widgets/zoom_in_and_out_to_image.dart';
class ResturantItem{
  String name;
  String imgUrl;
  double price;

  ResturantItem({this.name, this.imgUrl, this.price});

}
class FullMenu extends StatefulWidget {
  @override
  _FullMenuState createState() => _FullMenuState();
}

class _FullMenuState extends State<FullMenu> {
  final List<String> imgList = [
    'https://image.freepik.com/foto-gratis/minestrone-sopa-verduras-italiano-pasta-sobre-fondos-negros_2829-606.jpg',
    'https://lh3.googleusercontent.com/proxy/hGulqwwnfXDxq9T7J_bVJg1v5oeZAv2CIIXPGFBCkcoDQl43emDXNXIJlNvWhohUjywD-wVaVJySfnqQb6XjcKPT4frrBy4NzbyzJdQ1rCy6tlWc-Pmg3h02JpPITiI-F8j6pXBCcS_crVN-94iJ85O7WOO-JQCPy5GVW407YS7XkCROmFGblH4QCxuIMdrrK2hhKhonEjojGz5mQp7n8KgUkL5ZcNzv',
    'https://wallpapersmug.com/download/1600x1200/f19d15/dark-mood-food-raspberry-blackberry.jpg',
    'https://da28rauy2a860.cloudfront.net/wellbeing/wp-content/uploads/2017/06/cc719df559a44e74a740aa7b5a0731d6.png',
    'https://omnivorescookbook.com/wp-content/uploads/2018/07/1806_Black-Pepper-Chicken_550.jpg',
    'https://i2.wp.com/lisagcooks.com/wp-content/uploads/2017/01/Instant-Pot-Hot-Beef.jpg'
  ];
List<ResturantItem> _resturantItem = [
  ResturantItem(
    name: 'rice',
    imgUrl: 'images/meal.jpg',
    price: 2,
  ),
  ResturantItem(price: 4,imgUrl: 'images/meal.jpg',name: '641')
];
  List<NetworkImage> _convetURlImgToNetworkImage() {
    List<NetworkImage> _listImg = List<NetworkImage>();
    for (int i = 0; i < imgList.length; i++) {
      _listImg.add(NetworkImage(imgList[i]));
    }
    return _listImg;
  }
Widget _resturantItems({int index}){
    return  Container(
     // height: 110,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffc62828)),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: SizedBox(
        height: 170,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Carousel(
                images: _convetURlImgToNetworkImage(),
                dotSize: 5,
                dotColor: Colors.white,
                dotIncreasedColor: Color(0xffc62828),
                onImageTap: (int imgIndex) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShowImage(imgUrl: imgList[imgIndex],)));
                },
                boxFit: BoxFit.fill,
                autoplay: true,
                dotBgColor: Colors.transparent,
              ),
            ),
            Positioned(child: Container(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _resturantItem[index].name,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),Text(
                      '\$ ${_resturantItem[index].price}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),left: 0.0,bottom: 0.0,right: 0.0,)
          ],
        ),
      ),
    );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffc62828),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Resturant Name Menu',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
             itemCount: _resturantItem.length,
             itemBuilder: (context,index)=>_resturantItems(index: index),
            ),
          ),
        ],
      ),
    );
  }
}
