import 'package:city_map/database/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Manager {
  Manager(this._managedAreaIDs,this._workerID,this._id,this._teamLeadID);
  List<String>? _managedAreaIDs; List<String>? get managedAreaIDs => this._managedAreaIDs;set managedAreaIDs(List<String>? value) => this._managedAreaIDs = value;
  String? _workerID; get workerID => this._workerID; set workerID( value) => this._workerID = value;
  String? _id; get id => this._id; set id( value) => this._id = value;
  String? _teamLeadID; get teamLeadID => this._teamLeadID; set teamLeadID( value) => this._teamLeadID = value;  
}

class ManagerFactory {
  static Manager fromDocument(DocumentSnapshot snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return Manager((snapshotData["managed_areas"] as List).map((item) => item as String).toList(), snapshotData['worker_id'], snapshot.id, snapshotData['team_lead_id']);
  }
}
class ManagerDatabaseRetriever extends DatabaseRetriever {
  ManagerDatabaseRetriever(super.id);
  @override
  Manager fromDocument(DocumentSnapshot<Object?> snapshot) {
    return ManagerFactory.fromDocument(snapshot);
  }

  @override
  DocumentReference getDatabaseReference() {
    return FirebaseFirestore.instance.collection("Managers").doc(super.id);
  }

}