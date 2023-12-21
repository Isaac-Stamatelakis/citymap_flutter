
import 'package:city_map/task/site_task/site_task.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerContainer {
  MarkerContainer(this._assignedSiteTasks, this._unassignedSiteTasks, this.bitmaps);
  final List<SiteTask> _assignedSiteTasks;
  final List<SiteTask> _unassignedSiteTasks;
  final Map<String, BitmapDescriptor> bitmaps;
  late bool showCompleted = true;
  late bool showUnassigned = true;
  late bool showAssigned = true;
  
  List<SiteTask> getSiteTasks() {
    return _assignedSiteTasks + _unassignedSiteTasks;
  }

  void toggleSiteTaskCompletion(SiteTask updatedSiteTask) {
    for (SiteTask siteTask in getSiteTasks()) {
      if (siteTask.number == updatedSiteTask.number) {
        siteTask.completed = updatedSiteTask.completed;
      } 
    }
  }
  Set<Marker> buildMarkers(BuildContext context, Function callback) {
    Set<Marker> markers = {};
    if (showUnassigned) {
      markers = markers.union(_buildUnAssignedMarkers(context, callback));
    }
    if (showAssigned) {
      markers = markers.union(_buildAssignedMarkers(context, callback));
    }
    return markers;
  
  }
  Set<Marker> _buildAssignedMarkers(BuildContext context, Function callback) {
    Set<Marker> markers = {};
    for (SiteTask siteTask in _assignedSiteTasks) {
      
      if (!showCompleted && siteTask.completed) {
        continue;
      }
      
      markers.add(SiteTaskMarkerFactory.generateMarker(siteTask,context,true,bitmaps,callback));
    }
    return markers;
  }
  Set<Marker> _buildUnAssignedMarkers(BuildContext context, Function callback) {
    Set<Marker> markers = {};
    for (SiteTask siteTask in _unassignedSiteTasks) {
      if (!showCompleted && siteTask.completed) {
        continue;
      }
      markers.add(SiteTaskMarkerFactory.generateMarker(siteTask,context,false,bitmaps,callback));
    }
    return markers;
  }
}