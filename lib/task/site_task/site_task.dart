import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:city_map/database/database_helper.dart';
import 'package:city_map/consts/global_constants.dart';
import 'package:city_map/task/site_task/site_task_dialog.dart';
import 'package:city_map/task/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
/// Represents a Site
class SiteTask implements Task {
  SiteTask(this._bedAmount,this._completed,this._completedBy,this._description,this._number,this._primaryLocation,this._siteType,this._squareMeters,this._areaID,this._dbID);
  int _bedAmount; int get bedAmount => _bedAmount; set bedAmount(int value) => (_bedAmount = value);
  bool _completed; bool get completed => _completed; set completed(bool value) => (_completed = value);
  String _completedBy; String get completedBy => _completedBy; set completedBy(String value) => (_completedBy = value);
  String _description; String get description => _description; set description(String value) => (_description = value);
  int _number; int get number => this._number; set number(int value) => this._number = value;
  GeoPoint _primaryLocation; get primaryLocation => this._primaryLocation; set primaryLocation(value) => this._primaryLocation = value;
  String _siteType; String get siteType => this._siteType; set siteType(String value) => this._siteType = value;
  double _squareMeters; double get squareMeters => this._squareMeters; set squareMeters(double value) => this._squareMeters = value;
  String _dbID; String get dbID => this._dbID; set dbID(String value) => this._dbID = value;
   String _areaID; set areaID(String value) => this._areaID = value;  String get areaID => this._areaID; 
}
/// ASiteTasks have a managerID which overrides the manager of the areaID
class ASiteTask extends SiteTask {
  String _managerID;
  ASiteTask(this._managerID,super.bedAmount, super.completed, super.completedBy, super.description, super.number, super.primaryLocation, super.siteType, super.squareMeters, super.areaID, super.dbID); String get managerID => this._managerID; set managerID(String value) => this._managerID = value;
}
/// BSiteTasks have an area, and that area is managed by a manager
class BSiteTask extends SiteTask {
  BSiteTask(super.bedAmount, super.completed, super.completedBy, super.description, super.number, super.primaryLocation, super.siteType, super.squareMeters, super.areaID, super.dbID);
}
class SiteTaskFactory {
  static SiteTask? fromDocument(DocumentSnapshot<Object?> snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    String siteType = snapshotData['siteType'];
    if (siteType == "A") {
      return ASiteTask(
        snapshotData['manager_id'],
        snapshotData['bedAmount'], 
        snapshotData['completed'], 
        snapshotData['completedBy'], 
        snapshotData['description'], 
        snapshotData['number'], 
        snapshotData['primaryLocation'], 
        siteType, 
        snapshotData['squareMeters'], 
        snapshotData['area'], 
        snapshot.id
      );
    } else if (siteType == "B") {
      return BSiteTask(
        snapshotData['bedAmount'], 
        snapshotData['completed'], 
        snapshotData['completedBy'], 
        snapshotData['description'], 
        snapshotData['number'], 
        snapshotData['primaryLocation'], 
        siteType, 
        snapshotData['squareMeters'], 
        snapshotData['area'], 
        snapshot.id
      );
    } else {
      // TODO put error
      return null;
    }
  }
}
/// Retrieves SiteTask with given id
class SiteTaskDatabaseRetriever extends DatabaseRetriever {
  SiteTaskDatabaseRetriever(super.id);
  @override
  SiteTask? fromDocument(DocumentSnapshot<Object?> snapshot) {
    return SiteTaskFactory.fromDocument(snapshot);
  }
  @override
  dynamic getDatabaseReference() {
    return FirebaseFirestore.instance.collection("Sites").doc(super.id);
  }
}

/// Retrieves multi sitetasks in ids
class SiteTaskMultiRetriever extends MultiDatabaseRetriever {
  SiteTaskMultiRetriever(super.ids);
  
  @override
  DatabaseRetriever getRetriever(String id) {
    return SiteTaskDatabaseRetriever(id);
  }
}

/// Retrieves siteTask with given _areaID
class SiteTaskAreaQuery extends DatabaseQuery {
  final List<String>? _areaIDs;

  SiteTaskAreaQuery(this._areaIDs);
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return SiteTaskFactory.fromDocument(snapshot);
  }

  @override
  getQuery() {
    return FirebaseFirestore.instance.collection("Sites").where("area",whereIn:_areaIDs);
  }

}

class SiteTaskMarkerFactory {
  static Marker generateMarker(SiteTask siteTask,BuildContext context,bool assigned,Map<String,BitmapDescriptor> bitmaps,Function callback) {
    BitmapDescriptor? customIcon;
    if (siteTask.completed) {
      customIcon = bitmaps['assets/marker_completed.png'];
    } else {
      if (assigned) {
        customIcon = bitmaps['assets/marker_assigned.png'];
      } else {
        customIcon = bitmaps['assets/marker_not_completed.png'];
      }
    }
    GeoPoint geoPoint = siteTask.primaryLocation;
    return Marker(
      markerId: MarkerId(siteTask.number.toString()),
      position: LatLng(geoPoint.latitude,geoPoint.longitude),
      infoWindow: InfoWindow(
        title: siteTask.description,
      ),
      icon: customIcon!,
      onTap: () {
        showDialog(
          context: context, 
          builder: (BuildContext context) {
            return MapSiteTaskDialog(siteTask,callback);
          }
        );
      }
    );
    
  }
  
  static Future<Map<String,BitmapDescriptor>> buildBitMaps(List<String> files, double size) async {
    Size vectorSize = Size(size,size*786/512);
    Map<String, BitmapDescriptor> bitmaps = {};
    for (String file in files) {
      await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: vectorSize),file).then((value) {
          bitmaps[file] = value;
        });
    }
    return bitmaps;
  }

}