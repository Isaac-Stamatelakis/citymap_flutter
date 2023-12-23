import 'dart:html';

import 'package:city_map/database/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverSheet {
  DriverSheet(this._endKiloMeters,this._startKiloMeters,this._vehicleID,this._checks,this._dbID);

  double? _endKiloMeters;
  double? get endKiloMeters => this._endKiloMeters;
  set endKiloMeters(double? value) => this._endKiloMeters = value;

  double? _startKiloMeters;
  double? get startKiloMeters => this._startKiloMeters;
  set startKiloMeters(double? value) => this._startKiloMeters = value;
  
  String? _vehicleID;
  String? get vehicleID => this._vehicleID;
  set vehicleID(String? value) => this._vehicleID = value;

  List<Map<String,dynamic>>? _checks;
  List<Map<String,dynamic>>? get checks => this._checks;
  set checks(List<Map<String,dynamic>>? value) => this._checks = value;

  String? _dbID;
  String? get dbID => this._dbID;
   set dbID(String? value) => this._dbID = value;
  

  static DriverSheet fromDocument(DocumentSnapshot documentSnapshot) {
    var snapshotData = documentSnapshot.data() as Map<String, dynamic>;
    List<dynamic> dynamicList = snapshotData['vehicleChecks'];
    List<Map<String,dynamic>> mapList = [];
    for (dynamic element in dynamicList) {
      mapList.add(element as Map<String,dynamic>);
    }
    return DriverSheet(snapshotData['endKM'], snapshotData['startKM'], snapshotData['vehicleID'], mapList, documentSnapshot.id);
  }
}

class DriverSheetDatabaseHelper extends DatabaseHelper {
  final String driversheetID;
  DriverSheetDatabaseHelper(this.driversheetID);
  @override
  DriverSheet? fromDocument(DocumentSnapshot<Object?> snapshot) {
    return DriverSheet.fromDocument(snapshot);
  }

  @override
  dynamic getDatabaseReference() {
    return FirebaseFirestore.instance.collection("DriverSheets").doc(driversheetID);
  }
}