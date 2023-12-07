import 'package:city_map/map/android_map_fragment.dart';
import 'package:city_map/map/app_map_fragment.dart';
import 'package:city_map/map/ios_map_fragment.dart';
import 'package:city_map/map/web_map_fragment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as web_map;

class StatefulMapWidget extends StatefulWidget {

  const StatefulMapWidget ({Key? key}) : super(key : key);
  @override
  AMapState createState() {
    return AMapState();
  }
}
class AMapState extends State<StatefulMapWidget> {
  late dynamic _mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Fragment'),
      ),
      body: _buildMap(context),
    );
  }

  Widget _buildMap(BuildContext context) {
    //String platformStr = Theme.of(context).platform.toString();

    TargetPlatform platform = Theme.of(context).platform;
    debugPrint("Building Map in ${platform.toString()}");
    if (platform == TargetPlatform.iOS) {
     return IOSMapFragment();
    } 
    if (platform == TargetPlatform.android) {
      return AndroidMapFragment();
    }
    if (platform == TargetPlatform.fuchsia || platform == TargetPlatform.windows) {
      return WebMapFragment();
    }
    return UnsupportedPlatformMapFragment();
  }
}

class MapFragment extends StatelessWidget {
  const MapFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoogleMap(initialCameraPosition: CameraPosition(
        bearing: 0,
        target:LatLng(0,0),
        zoom:0,
        tilt:0)
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
