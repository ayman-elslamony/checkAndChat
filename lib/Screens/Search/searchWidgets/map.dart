import 'dart:convert';
import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/Providers/resturants.dart';
import 'package:checkandchat/Screens/Search/searchWidgets/item_details/item_details.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../../generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class ShowItemsOnMap extends StatefulWidget {
  static const routeName = '/ShowItemsOnMap';
  String type;

  ShowItemsOnMap({@required this.type});

  @override
  State<StatefulWidget> createState() => ShowItemsOnMapState();
}

class ShowItemsOnMapState extends State<ShowItemsOnMap>
    with SingleTickerProviderStateMixin {
  Auth _auth ;
  LatLng _currentPosition;
  LatLng _movingPosition;
  TextEditingController _textEditingController = TextEditingController();
  GoogleMapController _mapController;
  List<dynamic> _placePredictions = [];
bool isOpened=false;
  BitmapDescriptor customIcon;
  Set<Marker> markers;
  final CameraPosition _initialCamera =
  CameraPosition(target: LatLng(23.8859425, 45.0791626), zoom: 13);
  double radius = 2500;
  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Auth>(context,listen: false);
    print('type: ${widget.type}');
    _currentPosition = _auth.myLatLng;
    _movingPosition = _auth.myLatLng;
    print(_currentPosition);

    markers = Set.from([]);
  }

//  Future<void> _getUserLocation() async {
//    Position position = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//      setState(() {
//        _initialPosition = LatLng(position.latitude, position.longitude);
//      });
//  }
  searchChangedNavigate() {
   locationFromAddress(_textEditingController.text)
        .then((res) async {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target:
                  LatLng(res[0].latitude, res[0].longitude),
              zoom: 10.0)));
    });
  }



  createMarker(context) {
    if (customIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'images/marker.png')
          .then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
    }
  }


  List<Category> rest;
 _getAllMarkers() {
    rest = Provider.of<Categorys>(context, listen: true).resturants;
    print('dbdb');
   if(rest != []){
     markers.clear();
     for (int i = 0; i < rest.length; i++) {
       markers.add(Marker(
           markerId: MarkerId(rest[i].name),
           position: LatLng(rest[i].lat, rest[i].long),
           infoWindow: InfoWindow(
               title: rest[i].name,
               snippet: rest[i].vicinity,
               onTap: () {
                 Navigator.push(context,
                     MaterialPageRoute(builder: (context) => ItemDetails(id: rest[i].id,)));
               })));
     }
   }
  }

  void _autocompletePlace(String input) async {
    if (input.length > 0) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=AIzaSyC5rVumZ-Lyqa8Bk6qZ6llkLwWbX82hxWE&language=en";
      if (_initialCamera.target != null && radius != null) {
        url +=
            "&location=${_initialCamera.target.latitude},${_initialCamera.target.longitude}&radius=${radius}";
      }
      final response = await http.get(url);
      final json = jsonDecode(response.body);

      if (json["error_message"] != null) {
        var error = json["error_message"];
        if (error == "This API project is not authorized to use this API.")
          error +=
              " Make sure the Places API is activated on your Google Cloud Platform";
        throw Exception(error);
      } else {
        final predictions = json["predictions"];
        setState(() => _placePredictions = predictions);
        print(_placePredictions);
      }
    } else {
      setState(() => _placePredictions = []);
    }
  }
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    createMarker(context);
    return FutureBuilder(
        future:  _getAllMarkers(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
                height: _height * 0.30,
                width: _width,
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                )));
          } else {
            if (dataSnapshot.error != null) {
              return Container(
                height: _height * 0.30,
                width: _width,
                child: Center(
                  child: Text('An error occurred!'),
                ),
              );
            } else {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:Stack(children: [
                          GoogleMap(
                            myLocationEnabled: true,
                            compassEnabled: true,
                            scrollGesturesEnabled: true,
                            markers: markers,
                            myLocationButtonEnabled: true,
                            onCameraMove: (x) {
                              _movingPosition = x.target;
                              isOpened = false;
                              setState(() {
                              });
                            },
                            onMapCreated: (controller) {
                              setState(() {
                                _mapController = controller;
                              });
                            },
                            initialCameraPosition: _currentPosition == null?_initialCamera:CameraPosition(
                                target:_currentPosition,
                                zoom: 13),
                          ),
                          Positioned(
                              top: 0.0,
                              left: 55.0,
                              right: 55,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 45,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextFormField(
                                          autofocus: false,
                                          cursorColor: Colors.red,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400),
                                          textInputAction: TextInputAction.done,
                                          controller: _textEditingController,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(0.0),
                                              fillColor: Colors.white,
                                              filled: true,
                                              labelStyle: TextStyle(
                                                  color: Color(0xffc62828),fontFamily: 'Cairo'),
                                              labelText: LocaleKeys.searchForLocation.tr(),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                                borderSide: BorderSide(
                                                  color: Color(0xffc62828),
                                                ),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                                borderSide: BorderSide(
                                                  color: Color(0xffc62828),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                                borderSide: BorderSide(
                                                    color: Color(0xffc62828)),
                                              ),
                                              prefixIcon: IconButton(
                                                  onPressed:
                                                      searchChangedNavigate,
                                                  icon: Icon(
                                                    Icons.search,
                                                    color: Color(0xffc62828),
                                                  )),
                                              suffixIcon: _textEditingController
                                                          .text ==''
                                                  ? null
                                                  : IconButton(
                                                      icon: Icon(
                                                        Icons.clear,
                                                        color:
                                                            Color(0xffc62828),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _placePredictions
                                                              .clear();

                                                          _textEditingController
                                                              .clear();
                                                        });
                                                      })),
                                          keyboardType: TextInputType.text,
                                          onChanged: (val) {
                                            setState(() {
                                              _autocompletePlace(val);
                                              isOpened = true;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          Positioned(
                              top: 80,
                              left: 15,
                              right: 15,
                              child: _placePredictions.length == 0
                                  ? SizedBox(
                                      height: 1.0,
                                    )
                                  : Material(
                                      shadowColor: Colors.blueAccent,
                                      elevation: 8.0,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      type: MaterialType.card,
                                      child: Container(
                                          height: 180,
                                          child: ListView.builder(
                                            itemBuilder: (ctx, index) =>
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        _textEditingController
                                                                .text =
                                                            _placePredictions[
                                                                    index]
                                                                ['description'];
                                                        searchChangedNavigate();
                                                        _placePredictions
                                                            .clear();
                                                      });
                                                    },
                                                    child: ListTile(
                                                      title: Text(
                                                          '${_placePredictions[index]['description']}'),
                                                    )),
                                            itemCount: _placePredictions.length,
                                          )))),
//                    _movingPosition!=_currentPosition && !isOpened?Positioned(
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                RaisedButton(
//                                  onPressed: () {
//                                    print(widget.type);
//                                    if(widget.type == null){
//                                      Toast.show("Please Select category first", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
//                                    }else{
//                                      setState(() {
//                                        isOpened = true;
//                                      });
//                                      Provider.of<Categorys>(context,
//                                          listen: false)
//                                          .getNearbyPlaces(
//                                          type: widget.type,
//                                          radius: 3500,
//                                          currentLocation: _movingPosition);
//                                    }
//                                  },
//                                  color: Color(0xffc62828),
//                                  shape: RoundedRectangleBorder(
//                                      borderRadius: BorderRadius.all(
//                                          Radius.circular(10))),
//                                  child: Padding(
//                                    padding: const EdgeInsets.all(4),
//                                    child: Text(
//                                      LocaleKeys.redoSearch.tr(),
//                                      style: TextStyle(color: Colors.white,fontSize: _width*0.042,fontFamily: 'Cairo'),
//                                    ),
//                                  ),
//                                ),
//                              ],
//                            ),
//                            bottom: 52.0,
//                            left: 0.0,
//                            right: 0.0,
//                          ):SizedBox()
                        ]),
                      );
            }
          }
        });
  }
}