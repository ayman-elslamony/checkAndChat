import 'dart:convert';
import 'package:checkandchat/Providers/Auth.dart';
import 'package:checkandchat/Providers/resturants.dart';
import 'package:checkandchat/Screens/Search/searchWidgets/item_details/item_details.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class ShowSpecificPlaceOnMap extends StatefulWidget {
  Category category;
  ShowSpecificPlaceOnMap({@required this.category});

  @override
  State<StatefulWidget> createState() => ShowSpecificPlaceOnMapState();
}

class ShowSpecificPlaceOnMapState extends State<ShowSpecificPlaceOnMap>
    with SingleTickerProviderStateMixin {
  Auth _auth ;
  LatLng _currentPosition;
  GoogleMapController _mapController;
  MarkerId markerId;
  GoogleMap myMap;
  BitmapDescriptor customIcon;
  Set<Marker> markers;
  final CameraPosition _initialCamera =
  CameraPosition(target: LatLng(23.8859425, 45.0791626), zoom: 18);
  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Auth>(context,listen: false);
    _currentPosition = LatLng(widget.category.lat, widget.category.long);//_auth.myLatLng;
    print(_currentPosition);
    markers = Set.from([]);
    markerId = MarkerId(widget.category.name);
    markers.add(Marker(
      visible: true,
        markerId: markerId,
        position: LatLng(widget.category.lat,widget.category.long),
        infoWindow: InfoWindow(
            title: widget.category.name,
            snippet: widget.category.vicinity,
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ItemDetails(id: widget.category.id,)));
            }
            )));
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
appBar: AppBar(
  backgroundColor: Color(0xffc62828),
  title: Text(
    widget.category.name,
    style: TextStyle(color: Colors.white, fontSize: 16),
  ),
  leading: BackButton(
    onPressed: () {
      Navigator.of(context).pop();
    },
    color: Colors.white, // Here
  ),
),
        body: GoogleMap(
          mapToolbarEnabled: true,
          myLocationEnabled: true,
        //  compassEnabled: true,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          scrollGesturesEnabled: true,
          markers: markers,
          myLocationButtonEnabled: true,
          onMapCreated: (controller) {
            setState(() {
              _mapController = controller;
            });
//            _mapController.showMarkerInfoWindow(markerId
//            );
          },
          initialCameraPosition: _currentPosition == null?_initialCamera:CameraPosition(
              target:_currentPosition,
              zoom: 14.0),
        ),
      ),
    );
  }
}