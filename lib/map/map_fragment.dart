
import 'package:city_map/map/app_map_fragment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as web_map;
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class StatefulMapWidget extends StatefulWidget {

  const StatefulMapWidget ({Key? key}) : super(key : key);
  @override
  AMapState createState() {
    return AMapState();
  }
}
class AMapState extends State<StatefulMapWidget> {
  late dynamic _mapController;
  Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Fragment'),
      ),
      body: 
        FutureBuilder(
          future: _buildMap(context),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              if (snapshot.data != null) {
                return snapshot.data!;
              } else {
                return Text("Somethign wnet wrong");
              }
            } 
        }
      )
    );
  }
  
  
  Future<Widget> _buildMap(BuildContext context) async {
    LocationData locationData = await getLocation();
    print("${locationData.latitude}, ${locationData.longitude}");
    LatLng location = LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
    //String platformStr = Theme.of(context).platform.toString();
    TargetPlatform platform = Theme.of(context).platform;
    debugPrint("Building Map in ${platform.toString()}");
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      myLocationEnabled: true,
      initialCameraPosition: 
      CameraPosition(
        bearing: 0,
        target:location,
        zoom:15,
        tilt:0
        ),
      markers: Set.from([
                Marker(
                  markerId: MarkerId("MyLocation"),
                  position: location,
                  infoWindow: InfoWindow(title: "Your Location"),
                ),
              ]),
      );
    /*
    if (platform == TargetPlatform.iOS) {
     //return IOSMapFragment();
    } 
    if (platform == TargetPlatform.android) {
      //return AndroidMapFragment();
    }
    if (platform == TargetPlatform.fuchsia || platform == TargetPlatform.windows) {
      return MapFragment();
    }
    return UnsupportedPlatformMapFragment();
    */
  }

  Future<LocationData> getLocation() async {
    return Location().getLocation();
  }
  
}

class MapFragment extends StatelessWidget {
  late dynamic _mapController;
  MapFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      
      myLocationEnabled: true,
      initialCameraPosition: 
      const CameraPosition(
        bearing: 0,
        target:LatLng(0,0),
        zoom:0,
        tilt:0
        )
      );
      
  }

  
}

class UnsupportedPlatformMapFragment extends StatelessWidget {
  const UnsupportedPlatformMapFragment({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Unsupported Platform"));
  }
  
}
