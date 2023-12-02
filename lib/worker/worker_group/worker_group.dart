import 'package:city_map/consts/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkerGroup extends ChangeNotifier {
  WorkerGroup(this.dailySheetID,this.driverSheetID,this.driverID,this.managerID,this.siteTaskIDs);
  String? dailySheetID;
  String? driverSheetID;
  String? driverID;
  String? managerID;
  List<String>? siteTaskIDs;
  String? get getDailySheetID => this.dailySheetID;

  set setDailySheetID(String? dailySheetID) => this.dailySheetID = dailySheetID;

  get getDriverSheetID => this.driverSheetID;

  set setDriverSheetID( driverSheetID) => this.driverSheetID = driverSheetID;

  get getDriverID => this.driverID;

  set setDriverID( driverID) => this.driverID = driverID;

  get getManagerID => this.managerID;

  set setManagerID( managerID) => this.managerID = managerID;

  get getSiteTaskIDs => this.siteTaskIDs;

  set setSiteTaskIDs( siteTaskIDs) => this.siteTaskIDs = siteTaskIDs;
}

class WorkerGroupDatabaseHelper extends DatabaseHelper {
  final String _id;
  WorkerGroupDatabaseHelper(this._id);
  @override
  WorkerGroup? fromDocument(DocumentSnapshot<Object?> snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>; //snapshotData["siteTasks"]
    return WorkerGroup(
      snapshotData["dailySheet"], 
      snapshotData["driverSheet"], 
      snapshotData["driver_id"], 
      snapshotData["manager_id"],
      (snapshotData["siteTasks"] as List).map((item) => item as String).toList()
    );
  }

  @override
  dynamic getDatabaseReference() {
    return FirebaseFirestore.instance.collection("WorkerGroups").doc(_id);
  }
  
  
  

}