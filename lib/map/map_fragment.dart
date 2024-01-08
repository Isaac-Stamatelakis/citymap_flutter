
import 'dart:async';
import 'dart:html';

import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/map/app_map_fragment.dart';
import 'package:city_map/map/marker_container.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/worker/worker.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as web_map;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
class MapFragmentLoader extends SizedWidgetLoader {
  final String? workerID;
  final LatLng? startingCoordinates;

  const MapFragmentLoader({super.key, required this.workerID, required this.startingCoordinates}) : super(size: const Size(200,200));
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data;
    return _MapFragment(
      workerGroup: data['worker_group'], 
      siteTasks: data['site_tasks'], 
      bitmaps: data['bitmaps'], 
      worker: data['worker'], 
      startingCoordinates: data['coordinates'],
    );
    
  }

  @override
  Future getFuture() async {
    Worker worker = await WorkerDatabaseHelper(workerID: workerID!).fromDatabase();
    WorkerGroup workerGroup = await WorkerGroupDatabaseHelper(id: worker.groupID!).fromDatabase();
    Manager manager = await ManagerDatabaseRetriever(id:workerGroup.managerID!).fromDatabase();
    
    List<SiteTask> unassignedSiteTasks = [];
    List<SiteTask> assignedSiteTasks = (await SiteTaskMultiRetriever(workerGroup.siteTaskIDs).fromDatabase()).map((dynamic item) => (item as SiteTask)).toList();
    List<SiteTask> managerSiteTasks = (await SiteTaskManagerQuery(managerID: manager.id).retrieve()).map((dynamic item) => (item as SiteTask)).toList();
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
    
    // why is this async flutter whyyyy
    Map<String, BitmapDescriptor> bitmaps = await SiteTaskMarkerFactory.buildBitMaps(
      ['assets/marker_completed.png','assets/marker_assigned.png','assets/marker_not_completed.png'], 
      30
    );
    
    LatLng mapCoords;
    if (startingCoordinates == null) {
      LocationData locationData = await Location().getLocation();
      
      mapCoords = LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
    } else {
      mapCoords = startingCoordinates!;
    }
    return {
      'worker' : worker,
      'worker_group' : workerGroup,
      'site_tasks' : _SiteTaskBundle(assigned: assignedSiteTasks, unassigned: unassignedSiteTasks),
      'bitmaps' : bitmaps,
      'coordinates' : mapCoords
    };
  }
}

class _SiteTaskBundle {
  late List<SiteTask> assigned;
  late List<SiteTask> unassigned;
  _SiteTaskBundle({required this.assigned, required this.unassigned});
}
class _MapFragment extends StatefulWidget {
  final Worker? worker;
  final WorkerGroup workerGroup;
  final _SiteTaskBundle siteTasks;
  final Map<String, BitmapDescriptor> bitmaps;
  final LatLng startingCoordinates;
  const _MapFragment({required this.worker, required this.workerGroup, required this.siteTasks, required this.bitmaps, required this.startingCoordinates});

  @override
  State<_MapFragment> createState() => _MapFragmentState();
}


class _MapFragmentState extends State<_MapFragment> {
  late GoogleMapController _mapController;
  late MarkerContainer markerContainer = MarkerContainer(widget.siteTasks.assigned,widget.siteTasks.unassigned,widget.bitmaps);
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
            target:widget.startingCoordinates,
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
                  onPress: toggleCompleted,
                  hint: "Toggled Completed",
                ),
                CustomGoogleMapButton(
                  image: Image.asset('assets/marker_not_completed.png'), 
                  onPress: toggleUnAssigned,
                  hint: "Toggled Unassigned",
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
  final String hint;
  const CustomGoogleMapButton({super.key, required this.image, required this.onPress, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: hint,
      child: Container(
        decoration: const BoxDecoration(
          color : Color.fromARGB(255, 255, 255, 255),
          
        ),
        width: 40,
        height: 40,
        
        child: IconButton(
          onPressed:() => onPress(),
          icon: image
        ),
      )
    );
  }
}
