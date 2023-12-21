
import 'dart:async';
import 'dart:html';

import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/map/app_map_fragment.dart';
import 'package:city_map/map/marker_container.dart';
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

class MapFragment extends StatefulWidget {

  const MapFragment({super.key});

  @override
  State<MapFragment> createState() => _MapFragmentState();
}

class _MapFragmentState extends State<MapFragment> {


  // IDK why in flutter BitmapDescriptor factory is async so have to load when getting data
  late Map<String, BitmapDescriptor> bitmaps;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          if (snapshot.data != null) {
            dynamic data = snapshot.data;
            return _MapState(
              assignedSiteTasks:data['assigned'],
              unassignedSiteTasks: data['unassigned'],
              bitmaps: data['bitmaps'],
              startLocation: data['location'],
            );
          } else {
            return Text("Something went wrong");
          }
        } 
      }
    );
  }

  Future<dynamic> getData() async {
    Worker worker = await WorkerDatabaseHelper().fromDatabase();
    WorkerGroup workerGroup = await WorkerGroupDatabaseHelper(worker.groupID).fromDatabase();
    Manager manager = await ManagerDatabaseRetriever(workerGroup.managerID!).fromDatabase();
    //List<Area> areas = (await AreaMultiDatabaseRetriever(manager.managedAreaIDs).fromDatabase()).map((dynamic item) => (item as Area)).toList();
    LatLng startLocation = await getLocation();
    // why is this async flutter whyyyy
    
    bitmaps = await SiteTaskMarkerFactory.buildBitMaps(
      ['assets/marker_completed.png','assets/marker_assigned.png','assets/marker_not_completed.png'], 
      30
    );
    List<SiteTask> unassignedSiteTasks = [];
    List<SiteTask> assignedSiteTasks = (await SiteTaskMultiRetriever(workerGroup.siteTaskIDs).fromDatabase()).map((dynamic item) => (item as SiteTask)).toList();
    List<SiteTask> managerSiteTasks = (await SiteTaskAreaQuery(manager.managedAreaIDs).fromDatabase())!.map((dynamic item) => (item as SiteTask)).toList();
    for (SiteTask siteTask in managerSiteTasks) {
      bool included = false;
      for (SiteTask assignedSiteTask in assignedSiteTasks) {
        if (!included && siteTask.number == assignedSiteTask.number) {
          included = true;
        }
      }
      if (!included) {
        unassignedSiteTasks.add(siteTask);
      }
    }
    return {
      'location':startLocation,
      'assigned':assignedSiteTasks,
      'unassigned':unassignedSiteTasks,
      'bitmaps' : bitmaps
    };
  }

  Future<LatLng> getLocation() async {
    LocationData locationData = await Location().getLocation();
    return LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
  }
}

class _MapState extends StatefulWidget {
  
  final LatLng startLocation;
  final List<SiteTask> assignedSiteTasks;
  final List<SiteTask> unassignedSiteTasks;
  final Map<String, BitmapDescriptor> bitmaps;

  const _MapState({super.key, required this.startLocation, required this.assignedSiteTasks, required this.unassignedSiteTasks, required this.bitmaps});

  

  @override
  State<StatefulWidget> createState() => _BMapState();

}
class _BMapState extends State<_MapState> {
  _BMapState();
  late GoogleMapController _mapController;
  late MarkerContainer markerContainer = MarkerContainer(widget.assignedSiteTasks,widget.unassignedSiteTasks,widget.bitmaps);
  late Set<Marker> markers = markerContainer.buildMarkers(context,updateMarker);
  @override
  Widget build(BuildContext context) {
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
            target:widget.startLocation,
            zoom:15,
            tilt:0
            ),
          markers: markers
          ),

          Container(
          margin: const EdgeInsets.only(right: 10.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomGoogleMapButton(
                  image: Image.asset('assets/marker_completed.png'), 
                  onPress: toggleCompleted
                ),
                CustomGoogleMapButton(
                  image: Image.asset('assets/marker_not_completed.png'), 
                  onPress: toggleUnAssigned
                ),
                const SizedBox(
                  height: 105,
                ),
              ],
            )
          )
        )     
       ]
    );
  }

  void toggleCompleted() {
    markerContainer.showCompleted = !markerContainer.showCompleted;
    markers = markerContainer.buildMarkers(context,updateMarker);
    setState((){});
  }

  void toggleUnAssigned() {
    markerContainer.showUnassigned = !markerContainer.showUnassigned;
    markers = markerContainer.buildMarkers(context,updateMarker);
    setState((){});
  }

  dynamic updateMarker(SiteTask updatedSiteTask) {
    markerContainer.toggleSiteTaskCompletion(updatedSiteTask);
    markers = markerContainer.buildMarkers(context,updateMarker);
    setState((){});
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
  final Image image;
  final Function onPress;
  const CustomGoogleMapButton({super.key, required this.image, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color : Color.fromARGB(255, 255, 255, 255),
        
      ),
      width: 40,
      height: 40,
      
      child: IconButton(
        onPressed:() => onPress(),
        icon: image
      ),
    );
  }

}
