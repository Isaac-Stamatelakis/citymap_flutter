import 'package:city_map/database/database_helper.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

class SiteTaskUploader implements IDBManager<SiteTask?> {
  @override
  Future<void> delete(SiteTask? value) async {
    if (value == null) {
      return;
    }
    if (value.dbID == null) {
      return;
    }
    await FirebaseFirestore.instance.collection("Sites").doc(value.dbID).delete();
    Logger().i("Deleted SiteTask ${value.dbID}");
  }

  @override
  Map<String, dynamic> toJson(SiteTask? value) {
    if (value == null){
      return {};
    }
    if (value is ASiteTask) {
      return {
        'area' : value.areaID,
        'bedAmount' : value.bedAmount,
        'completed' : value.completed,
        'completedBy' : value.completedBy,
        'description' : value.description,
        'number' : value.number,
        'manager_id' : value.managerID,
        'primaryLocation' : value.primaryLocation,
        'siteType' : value.siteType,
        'squareMeters' : value.squareMeters
      };
    } else if (value is BSiteTask) {
      return {
        'area' : value.areaID,
        'bedAmount' : value.bedAmount,
        'completed' : value.completed,
        'completedBy' : value.completedBy,
        'description' : value.description,
        'number' : value.number,
        'primaryLocation' : value.primaryLocation,
        'siteType' : value.siteType,
        'squareMeters' : value.squareMeters,
        'manager_id' : null
      };
    }
    return {};
  }

  @override
  Future<void> update(SiteTask? value) async {
    if (value == null) {
      return;
    }
    if (value.dbID == null) {
      return;
    }
    Map<String,dynamic> json = toJson(value);
    if (json.isEmpty) {
      return;
    }
    await FirebaseFirestore.instance.collection("Sites").doc(value.dbID).update(json);
  }

  @override
  Future<String?> upload(SiteTask? value) async {
    if (value == null) {
      return null;
    }
    if (value.dbID != null) {
      return null;
    }
    Map<String,dynamic> json = toJson(value);
    if (json.isEmpty) {
      return null;
    }
    DocumentReference reference = await FirebaseFirestore.instance.collection("Sites").add(json);
    Logger().i("Uploaded SiteTask ${reference.id}");
    value.dbID = reference.id;
    return reference.id;
  }
  
}