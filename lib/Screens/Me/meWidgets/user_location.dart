import 'dart:convert';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserLocation extends StatefulWidget {
  static const routeName = '/GetUserLocation';
  Function getAddress;

  GetUserLocation({this.getAddress});

  @override
  State<StatefulWidget> createState() => GetUserLocationState();
}


class GetUserLocationState extends State<GetUserLocation> with SingleTickerProviderStateMixin {
TextEditingController _textEditingController =TextEditingController();
TextEditingController _realAddressController =TextEditingController();
  List<dynamic> _placePredictions = [];
  BitmapDescriptor customIcon;
  Set<Marker> markers;
  @override
  void initState() {
    super.initState();
    markers = Set.from([]);
  }
  GoogleMapController _mapController;
  searchChangedNavigate(){
    Geolocator().placemarkFromAddress(_textEditingController.text).then((res) async{
      _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(res[0].position.latitude,res[0].position.longitude),zoom: 10.0)));
    });
  }
  final CameraPosition _initialCamera = CameraPosition(target: LatLng(30.03,31.23), zoom: 18);
  createMarker(context) {
    if (customIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/icons/marker.png')
          .then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
    }
  }
  double radius = 30000;
  void _autocompletePlace(String input) async {
    if (input.length > 0) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=AIzaSyC5rVumZ-Lyqa8Bk6qZ6llkLwWbX82hxWE&language=en";
      if ( _initialCamera.target != null && radius != null) {
        url += "&location=${_initialCamera.target.latitude},${_initialCamera.target.longitude}&radius=${radius}";
      }
      final response = await http.get(url);
      final json = jsonDecode(response.body);

      if (json["error_message"] != null) {
        var error = json["error_message"];
        if (error == "This API project is not authorized to use this API.")
          error += " Make sure the Places API is activated on your Google Cloud Platform";
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
    createMarker(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              markers: markers,
              myLocationButtonEnabled: true,
              onTap: (pos) async{
                print(pos);
                Marker m =
                Marker(markerId: MarkerId('1'), icon: customIcon, position: pos);
                setState(() {
                  markers.add(m);
                });final coordinates =
                new Coordinates(pos.latitude, pos.longitude);
                var addresses =
                    await Geocoder.local.findAddressesFromCoordinates(coordinates);
                setState(() {
                  _realAddressController.text =addresses.first.addressLine;
                });
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  contentPadding: EdgeInsets.only(top: 10.0),
                  title: Text(
                    'Are you sure',
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    height: 80,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(height: 60 ,width: MediaQuery.of(context).size.width/0.85,child: TextFormField(
                              //style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                              controller: _realAddressController,
                              decoration: InputDecoration(
                              labelText: 'this is Your location',
                                  labelStyle: TextStyle(color: Color(0xffc62828)),
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
                              ),
                              keyboardType: TextInputType.text,
                            ),)
                          )
                      //,Text('this is Your location',style: TextStyle(fontSize: 18,color: Colors.blue),),
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
                    ),
                    FlatButton(
                      child: Text('ok'),
                      onPressed: () {
                        print(_realAddressController.text);
                         setState(() {
                           widget.getAddress(_realAddressController.text,pos.latitude,pos.longitude);
                         });
                        Navigator.of(ctx).pop();
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
              },
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              initialCameraPosition:
              CameraPosition(target: LatLng(36.98, -121.99), zoom: 18),
            ),
        Positioned(
            top: 0.0,
            left: 0.0,
            right: 55,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 45,
                child: Row(
                  children: <Widget>[
                    IconButton(
                    color: Color(0xffc62828),
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: (){
                      Navigator.of(context).pop();
                  },
                ),
                    Expanded(
                      child: TextFormField(
                        autofocus: false,
                        cursorColor: Color(0xffc62828),
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
                                color: Colors.grey[700]),
                            labelText: 'Search for Location',
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
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )),
            Positioned(
              top: 60,
              left: 15,
              right: 15,
              child:  _placePredictions.length == 0?SizedBox(height: 1.0,):Material(
                  shadowColor: Colors.redAccent,
                  elevation: 8.0,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  type: MaterialType.card,
              child:
              Container(
                  height: 180,
                  child: ListView.builder(itemBuilder: (ctx,index)=>InkWell(
                      onTap: (){
                        setState(() {
                          _textEditingController.text = _placePredictions[index]['description'];
                          searchChangedNavigate();
                          _placePredictions.clear();
                        });
                      },
                      child: ListTile(title: Text('${_placePredictions[index]['description']}'),)),itemCount: _placePredictions.length,))
              )
            )
          ],
        ),
      ),
    );
  }

}