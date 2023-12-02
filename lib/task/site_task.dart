import 'dart:async';
import 'dart:math';

import 'package:city_map/consts/global_constants.dart';
import 'package:city_map/task/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
/// Represents a Site
class SiteTask implements Task {
  SiteTask(this._bedAmount,this._completed,this._completedBy,this._description,this._number,this._primaryLocation,this._siteType,this._squareMeters,this._dbID);
  int _bedAmount; int get bedAmount => _bedAmount; set bedAmount(int value) => (_bedAmount = value);
  bool _completed; bool get completed => _completed; set completed(bool value) => (_completed = value);
  String _completedBy; String get completedBy => _completedBy; set completedBy(String value) => (_completedBy = value);
  String _description; String get description => _description; set description(String value) => (_description = value);
  int _number; int get number => this._number; set number(int value) => this._number = value;
  GeoPoint _primaryLocation; get primaryLocation => this._primaryLocation; set primaryLocation(value) => this._primaryLocation = value;
  String _siteType; String get siteType => this._siteType; set siteType(String value) => this._siteType = value;
  double _squareMeters; double get squareMeters => this._squareMeters; set squareMeters(double value) => this._squareMeters = value;
  String _dbID; String get dbID => this._dbID; set dbID(String value) => this._dbID = value;


  
}
/*
class SiteTaskDatabaseHelper {
  
  Future<List<SiteTask>> getSites() async {

    await Future(
      FirebaseFirestore.instance.collection("Workers").doc(GlobalValues.user_id).get() as FutureOr Function(),
    );
    final List<Map<String, dynamic>> result = 
  }
  static SiteTask fromDatabase(DocumentSnapshot snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return SiteTask(snapshotData['bedAmount'], snapshotData['completed'], snapshotData['completedBy'], snapshotData['description'], snapshotData['number'], snapshotData['primaryLocation'], snapshotData['siteType'], snapshotData['squareMeters'], snapshot.id);
  }

  Future<String?> getWorkerGroup() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("Sites").doc(GlobalValues.user_id).get();
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        String? workerGroupID = (documentSnapshot.data()as Map<String, dynamic>)['workerGroup'];
        return workerGroupID;
      } else {
        return null;
      }
    } catch (e) {
      Logger().e('Error retrieving workerGroupID: $e');
      return null;
    }
  }
}
*/
