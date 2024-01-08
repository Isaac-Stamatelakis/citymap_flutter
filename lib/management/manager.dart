import 'dart:html';

import 'package:city_map/database/database_helper.dart';
import 'package:city_map/worker/worker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Manager {
  Manager(this._workerID,this._id,this._teamLeadID);
  String? _workerID; get workerID => this._workerID; set workerID( value) => this._workerID = value;
  String? _id; get id => this._id; set id( value) => this._id = value;
  String? _teamLeadID; get teamLeadID => this._teamLeadID; set teamLeadID( value) => this._teamLeadID = value;  
}

class ManagerFactory {
  static Manager? fromDocument(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return Manager(snapshotData['worker_id'], snapshot.id, snapshotData['team_lead_id']);
  }
}
class ManagerDatabaseRetriever extends DatabaseRetriever {
  ManagerDatabaseRetriever({required super.id});

  @override
  Manager? fromDocument(DocumentSnapshot<Object?> snapshot) {
    return ManagerFactory.fromDocument(snapshot);
  }

  @override
  DocumentReference getDatabaseReference() {
    return FirebaseFirestore.instance.collection("Managers").doc(super.id);
  }
}

class WorkerManagerQuery extends DatabaseQuery<Manager?> {
  final String? workerID;

  WorkerManagerQuery({required this.workerID});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return ManagerFactory.fromDocument(snapshot);
  }

  @override
  getQuery() {
    return FirebaseFirestore.instance.collection("Managers").where("worker_id",isEqualTo:workerID);
  }

}