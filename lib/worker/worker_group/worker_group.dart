

import 'package:city_map/database/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkerGroup {
  WorkerGroup({required this.dailySheetID,required this.driverSheetID,required this.driverID,required this.managerID,required this.siteTaskIDs,required this.areaIDs, required this.id});
  late String? dailySheetID;
  late String? driverSheetID;
  late String? driverID;
  late String? managerID;
  late List<String>? siteTaskIDs;
  late List<String>? areaIDs;
  late String? id;
}

class WorkerGroupFactory {
  static WorkerGroup? fromDocument(DocumentSnapshot snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>; //snapshotData["siteTasks"]
    return WorkerGroup(
      id: snapshot.id,
      dailySheetID: snapshotData["dailySheet"], 
      driverSheetID : snapshotData["driverSheet"], 
      driverID: snapshotData["driver_id"], 
      managerID: snapshotData["manager_id"],
      siteTaskIDs: (snapshotData["siteTasks"] as List).map((item) => item as String).toList(),
      areaIDs: (snapshotData["areas"] as List).map((item) => item as String).toList()
    );
  }
}

class WorkerGroupDatabaseHelper extends DatabaseRetriever {
  WorkerGroupDatabaseHelper({required super.id});
  @override
  WorkerGroup? fromDocument(DocumentSnapshot<Object?> snapshot) {
    return WorkerGroupFactory.fromDocument(snapshot);
  }

  @override
  dynamic getDatabaseReference() {
    return FirebaseFirestore.instance.collection("WorkerGroups").doc(super.id);
  }
}

class ManagerWorkerGroupQuery extends DatabaseQuery<WorkerGroup> {
  final String managerID;
  ManagerWorkerGroupQuery({required this.managerID});

  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return WorkerGroupFactory.fromDocument(snapshot);
  }

  @override
  getQuery() {
    return FirebaseFirestore.instance.collection("WorkerGroups")
    .where("manager_id",isEqualTo: managerID);
  }

}