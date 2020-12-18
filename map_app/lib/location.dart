import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  final double lat;
  final double long;

  const Location({Key key, this.lat, this.long}) : super(key: key);
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location>{
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double r_lat;
  double r_long;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    r_lat=widget.lat;
    r_long=widget.long;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(alignment: Alignment.center,child: Center(child: Icon(Icons.location_on,color: Colors.orange,)),),
        GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.lat, widget.long),
            zoom: 14.4746,
          ),
          markers: Set<Marker>.of(
            <Marker>[
              Marker(
                  onTap: () {
                    print('Tapped');
                  },
                  draggable: true,
                  markerId: MarkerId('Marker'),
                  position: LatLng(widget.lat, widget.long),
                  onDragEnd: ((newPosition) {
                    r_long=newPosition.longitude;
                    r_lat=newPosition.latitude;
                    print(newPosition.latitude);
                    print(newPosition.longitude);
                  }))
            ],
          ),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
        ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.pop(context);
          showDialog(context: context, child:
          new AlertDialog(
            title: Text("Latitude: "+r_lat.toString()+" Longitude: "+r_long.toString()),
          ));
        },
        backgroundColor: Colors.pinkAccent,
        label: Text('Set'),
        icon: Icon(Icons.check_box),
      ),
    );
  }

}
