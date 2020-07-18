import 'dart:io';
import 'package:checkandchat/Screens/Me/meWidgets/user_location.dart';
import 'package:checkandchat/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:checkandchat/Providers/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../../Screens/Me/meWidgets/moreWidgets.dart/settings.dart';

class AddShop extends StatefulWidget {
  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  List _shopCategory = [
    "Resturant",
    "Caffe",
    "Pharmacy",
    "Hospital",
    "Accounting",
    "shopping",
    "Car Gas"
  ];

  List _shopPrcie = [
    LocaleKeys.free.tr(),
    LocaleKeys.inexpensive.tr(),
    LocaleKeys.moderate.tr(),
    LocaleKeys.expensive.tr(),
    LocaleKeys.veryExpensive.tr(),
  ];
  bool isImageSelected = false;
  bool _isEditLocationEnable = false;
  bool _selectUserLocationFromMap = false;
  Country _selected;
  String businessName = '';
  String _selectedShopCategory;
  String businessPhone;
  String _selectedShopPrice;
  String businessWebsite = '';
  String types;
  File _imageFile;
  String imgUrl;
  String startTime;
  String endTime;
  String businessDistance;
  String businessAddress;
  String lat;
  String lng;
  TextEditingController _locationTextEditingController =
  TextEditingController();
  final FocusNode _businessAddress = FocusNode();
  final FocusNode _businessCategory = FocusNode();
  final FocusNode _businessPhone = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isRegiterNow = false;

  _addShop() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (startTime.isEmpty && endTime.isEmpty) {
        Toast.show("Please enter opening hours", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        setState(() {
          _isRegiterNow = true;
        });
        String x =
        await Provider.of<UserData>(context, listen: false).registerShop(
          countryName: _selected == null ? '' : _selected.name,
          businessAddress: businessAddress,
          businessName: businessName,
          businessPhone: businessPhone,
          businessWebsite: businessWebsite,
          businessCategory: _selectedShopCategory,
          imgFile: _imageFile,
          lat: lat,
          lng: lng,
          priceLevel: _selectedShopPrice,
          endTime: endTime,
          startTime: startTime,
          typeOfServices: types,
        );
        if (x == 'true') {
          Toast.show("Successfully Regitered", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else if (x == 'Already Exists') {
          Toast.show('Already Exists', context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("please try again", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        }
        setState(() {
          _isRegiterNow = false;
        });
      }
    }
  }

  Future<void> _getImage(ImageSource source) async {
    await ImagePicker.pickImage(source: source, maxWidth: 400.0)
        .then((File image) {
      if(image !=null){
        setState(() {
          _imageFile = image;
          isImageSelected = true;
        });
        Navigator.pop(context);
      }

    });

  }

  void _openImagePicker() {
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
                      _getImage(ImageSource.camera);
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
                      _getImage(ImageSource.gallery);
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
  Widget build(BuildContext context) {
    final _textStyle = Theme.of(context).textTheme.title;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    bool _isTapped = false;
    Future<String> _getLocation() async {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final coordinates =
      new Coordinates(position.latitude, position.longitude);
      var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
      lat = position.latitude.toString();
      lng = position.longitude.toString();
      return addresses.first.addressLine;
    }

    void _getUserLocation() async {
      businessAddress = await _getLocation();
      setState(() {
        _locationTextEditingController.text = businessAddress;
        _isEditLocationEnable = true;
        _selectUserLocationFromMap = !_selectUserLocationFromMap;
      });
      Navigator.of(context).pop();
    }

    void selectLocationFromTheMap(String address, double lat, double long) {
      setState(() {
        _locationTextEditingController.text = address;
      });
      businessAddress = address;
      this.lat = lat.toString();
      this.lng = long.toString();
    }

    void selectUserLocationType() async {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          title: Text(
            'Location',
            textAlign: TextAlign.center,
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: _getUserLocation,
                    child: Material(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        type: MaterialType.card,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Get current Location',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (ctx) => GetUserLocation(
                            getAddress: selectLocationFromTheMap,
                          )));
                      setState(() {
                        _isEditLocationEnable = true;
                        _selectUserLocationFromMap =
                        !_selectUserLocationFromMap;
                      });
                    },
                    child: Material(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        type: MaterialType.card,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Select Location from Map',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    Divider _divider() {
      return Divider(
        color: Colors.grey[300],
        thickness: 1.0,
        height: 1,
      );
    }

    Widget _createListButton(
        {Widget icon1,
          Widget icon2,
          Widget text,
          Function function,
          Widget route}) {
      return InkWell(
          onTap: function,
          child: ListTile(
            dense: true,
            title: Row(
              children: <Widget>[
                icon1,
                Padding(
                  padding: EdgeInsets.only(right: _width * 0.03),
                ),
                text,
                Spacer(),
                icon2
              ],
            ),
          ));
    }

    Widget _expantion(
        {Widget icon1,
          IconData icon2,
          Text titleText,
          Widget widget,
          Function function}) {
      return ExpansionTile(
        trailing: Icon(icon2, color: Colors.black38),
        title: Row(
          children: <Widget>[
            icon1,
            Padding(
              padding: EdgeInsets.only(right: _width * 0.03),
            ),
            titleText,
          ],
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget,
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          _isRegiterNow
              ? Padding(
            padding: const EdgeInsets.all(10.0),
            child:
            CircularProgressIndicator(backgroundColor: Colors.grey),
          )
              : Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
                size: 30,
              ),
              onPressed: _isRegiterNow? (){}:_addShop,
            ),
          )
        ],
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
            Text(
              LocaleKeys.addShop,
              style: TextStyle(color: Colors.white, fontSize: _width * 0.045),
            ).tr(context: context),
          ],
        ),
        backgroundColor: Color(0xffc62828),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              LocaleKeys.country,
              style:
              TextStyle(fontSize: _width * 0.045, color: Colors.grey[700]),
            ).tr(context: context),
          ),
          _divider(),
          _createListButton(
              icon1: SizedBox(),
              icon2: SizedBox(),
              text: CountryPicker(
                showFlag: true,
                showDialingCode: false,
                showName: true,
                showCurrency: false,
                showCurrencyISO: true,
                onChanged: (Country country) {
                  _selected = country;
                },
                selectedCountry: _selected,
              ),
              function: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));
              }),
          _divider(),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              LocaleKeys.shopInfo,
              style:
              TextStyle(fontSize: _width * 0.045, color: Colors.grey[700]),
            ).tr(context: context),
          ),
          _divider(),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: _width * 0.8,
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.shopName.tr(),
                        hintStyle: TextStyle(fontSize: _width * 0.04,fontFamily: 'Cairo'),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey[400])),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey[400])),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey[400])),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey[400]),
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey[400])),
                        contentPadding:
                        new EdgeInsets.symmetric(vertical: 15.0),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: Colors.black54,
                        ),
                      ),
                      // ignore: missing_return
                      validator: (x) {
                        if (x.isEmpty || x.length < 2) {
                          return 'Invalid Name';
                        }
                      },
                      onSaved: (val) {
                        businessName = val;
                      },
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(_businessAddress);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: _width * 0.8,
                    child: TextFormField(
                      autofocus: false,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number ,
                      focusNode: _businessPhone,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.shopPhone.tr(),
                        hintStyle: TextStyle(fontSize: _width * 0.04,fontFamily: 'Cairo'),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey[400])),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey[400])),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey[400])),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey[400]),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey[400]),
                        ),
                        contentPadding:
                        new EdgeInsets.symmetric(vertical: 15.0),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.black54,
                        ),
                      ),
                      // ignore: missing_return
                      validator: (x) {
                        if (x.isEmpty || x.length < 10) {
                          return 'Invalid Phone';
                        }
                      },
                      onSaved: (val) {
                        businessPhone = val;
                      },
                      onFieldSubmitted: (val) {
                        _businessPhone.unfocus();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: _width * 0.8,
                    child: InkWell(
                        onTap: selectUserLocationType,
                        child: TextFormField(
                          autofocus: false,
                          style: TextStyle(fontSize: 15),
                          controller: _locationTextEditingController,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: selectUserLocationType,
                              child: Icon(
                                Icons.my_location,
                                size: 20,
                                color: Color(0xffc62828),
                              ),
                            ),
                            hintText: LocaleKeys.shopLocation.tr(),
                            hintStyle: TextStyle(fontSize: _width * 0.04,fontFamily: 'Cairo'),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                BorderSide(color: Colors.grey[400])),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                BorderSide(color: Colors.grey[400])),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                BorderSide(color: Colors.grey[400])),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: Colors.grey[400]),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                BorderSide(color: Colors.grey[400])),
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          enabled: _isEditLocationEnable,
                          keyboardType: TextInputType.text,
// ignore: missing_return
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Invalid Location';
                            }
                          },
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: _width * 0.8,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(LocaleKeys.shopCategory,style: TextStyle(fontFamily: 'Cairo'),).tr(context: context),
                        value: _selectedShopCategory,
                        items: _shopCategory.map((value) {
                          return DropdownMenuItem(
                            child: Text('  ' + value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedShopCategory = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: _width * 0.8,
                    child: TextFormField(
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.serviceType.tr(),
                        hintStyle: TextStyle(fontSize: _width * 0.04,fontFamily: 'Cairo'),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey[400])),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey[400])),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey[400])),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(color: Colors.grey[400]),
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(color: Colors.grey[400])),
                        contentPadding:
                        new EdgeInsets.symmetric(vertical: 15.0),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: Colors.black54,
                        ),
                      ),
                      // ignore: missing_return
                      validator: (x) {
                        if (x.isEmpty || x.length < 2) {
                          return 'Invalid Services';
                        }
                      },
                      onSaved: (val) {
                        types = val;
                      },
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(_businessAddress);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: _width * 0.8,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text(LocaleKeys.priceLevel,style: TextStyle(fontFamily: 'Cairo'),).tr(context: context),
                        value: _selectedShopPrice,
                        items: _shopPrcie.map((value) {
                          return DropdownMenuItem(
                            child: Text('  ' + value),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedShopPrice = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  isImageSelected == false
                      ? Container(
                      height: 40,
                      width: _width * 0.8,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]),
                          borderRadius: BorderRadius.circular(4)),
                      child: FlatButton(
                        onPressed: () {
                          _openImagePicker();
                        },
                        child: Center(child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ImageIcon(AssetImage('images/meScreenIcons/addPhoto.png'),color: Colors.grey[600],),
                            SizedBox(width:5),
                            Text(LocaleKeys.addPhoto,style: TextStyle(color:Colors.grey[600],fontFamily: 'Cairo'),).tr(context: context)
                          ],
                        )),
                        color: Colors.white,
                      ))
                      : Stack(
                    children: <Widget>[
                      Container(
                        height: _height*0.25,
                        width: _width*0.78,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xffc62828),
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          child: Image.file(
                            _imageFile,
                            fit: BoxFit.fill,

                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                      Positioned(
                          right: 5.0,
                          top: 5.0,
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color:Colors.black45
                            ),
                            child: IconButton(icon: Icon(Icons.clear,color: Colors.white,),
                                onPressed: () {
                                  setState(() {
                                    isImageSelected = false;
                                  });
                                }),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      LocaleKeys.shopTime,
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ).tr(context: context),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        LocaleKeys.from,
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ).tr(context: context),
                      TimePickerSpinner(
                        is24HourMode: true,
                        normalTextStyle:
                        TextStyle(fontSize: 18, color: Colors.deepOrange),
                        highlightedTextStyle:
                        TextStyle(fontSize: 18, color: Colors.blue),
                        spacing: 30,
                        itemHeight: 40,
                        isForce2Digits: true,
                        time: DateTime.now(),
                        onTimeChange: (time) {
                          setState(() {
                            print(time);
                            startTime = '${time.hour}:${time.minute}';
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        LocaleKeys.to,
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ).tr(context: context),
                      TimePickerSpinner(
                        is24HourMode: true,
                        normalTextStyle:
                        TextStyle(fontSize: 18, color: Colors.deepOrange),
                        highlightedTextStyle:
                        TextStyle(fontSize: 18, color: Colors.blue),
                        spacing: 30,
                        itemHeight: 40,
                        isForce2Digits: true,
                        time: DateTime.now(),
                        onTimeChange: (time) {
                          setState(() {
                            endTime='${time.hour}:${time.minute}';
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              LocaleKeys.optionalInfo,
              style:
              TextStyle(fontSize: _width * 0.045, color: Colors.grey[700]),
            ).tr(context: context),
          ),
          _divider(),
          _expantion(
            icon1: Icon(Icons.laptop),
            icon2: Icons.expand_more,
            titleText: Text(LocaleKeys.webSite,
                style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: _width * 0.035,
                    fontWeight: FontWeight.w700,fontFamily: 'Cairo')).tr(context: context),
            widget: SizedBox(
              width: _width * 0.8,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'web site',
                  hintStyle: TextStyle(fontSize: _width * 0.04),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.grey[400])),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.grey[400])),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.grey[400])),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey[400]),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.grey[400]),
                  ),
                  contentPadding: new EdgeInsets.symmetric(vertical: 15.0),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.laptop,
                    color: Colors.black54,
                  ),
                ),
                onChanged: (val) {
                  businessWebsite = val;
                },
              ),
            ),
          ),
          _divider(),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: RaisedButton(
              onPressed:  _isRegiterNow? (){}:_addShop,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              color: Color(0xffc62828),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: _isRegiterNow
                    ? SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.grey))
                    : Text(
                  LocaleKeys.register,
                  style: TextStyle(color: Colors.white, fontSize: 18,fontFamily: 'Cairo'),
                ).tr(context: context),
              ),
            ),
          ),
          SizedBox(height:20)
        ],
      ),
    );
  }
}