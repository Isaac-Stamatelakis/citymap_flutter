
import 'dart:html';

import 'package:city_map/consts/colors.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/map/app_map_fragment.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/worker/worker.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
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
  late Worker worker;
  late WorkerGroup workerGroup;
  late List<SiteTask> siteTasks;
  late List<Area> areas;
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
    
    await getData();

    LocationData locationData = await getLocation();
    Set<Marker> markers = siteTasks.map((sitetask) => SiteTaskMarkerFactory.generateMarker(sitetask,context)).toSet();
    print("${locationData.latitude}, ${locationData.longitude}");
    LatLng location = LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
    //String platformStr = Theme.of(context).platform.toString();
    TargetPlatform platform = Theme.of(context).platform;
    debugPrint("Building Map in ${platform.toString()}");
    return Stack(
      children: [
        GoogleMap(
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
          markers: markers
            
        ),
        Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: const Align(
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomGoogleMapButton(),
                SizedBox(
                  height: 105,
                ),
              ],
            )
          )
        )        
      ],
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
  Future getData() async {
    worker = await WorkerDatabaseHelper().fromDatabase();
    workerGroup = await WorkerGroupDatabaseHelper(worker.groupID).fromDatabase();
    Manager manager = await ManagerDatabaseRetriever(workerGroup.managerID!).fromDatabase();
    areas = (await AreaMultiDatabaseRetriever(manager.managedAreaIDs).fromDatabase()).map((dynamic item) => (item as Area)).toList();
    siteTasks = (await SiteTaskAreaQuery(manager.managedAreaIDs).fromDatabase())!.map((dynamic item) => (item as SiteTask)).toList();
    List<SiteTask> assignedSiteTasks = (await SiteTaskMultiRetriever(workerGroup.siteTaskIDs).fromDatabase()).map((dynamic item) => (item as SiteTask)).toList();
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

class CustomGoogleMapButton extends StatelessWidget {
  const CustomGoogleMapButton({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color : Color.fromARGB(255, 255, 255, 255),
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        )
      ),
      width: 40,
      height: 40,
      
      child: IconButton(
        onPressed: (){
          print(true);
        }, 
        icon: const Icon(Icons.abc)
      ),
    );
  }

}