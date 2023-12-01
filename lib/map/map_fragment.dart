import 'package:flutter/material.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as google_map_web;
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_map_phone;

class MapFragment extends StatefulWidget {
  const MapFragment ({Key? key}) : super(key : key);
  @override
  mapState createState() => mapState();

}
class mapState extends State<MapFragment> {
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
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.android) {
      return google_map_phone.GoogleMap(
        initialCameraPosition: const google_map_phone.CameraPosition(
          target: google_map_phone.LatLng(37.7749,-122.4194),
          zoom: 12.0,
        ),
        onMapCreated: (controller) {
           _mapController = controller;
        },
      );
    }
    if (platform == TargetPlatform.fuchsia || platform == TargetPlatform.windows) {

    }
    return const Center(
      child: Text("You are using an unsupported platform"),
    );

  }
}