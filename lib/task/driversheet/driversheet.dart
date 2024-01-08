// ignore_for_file: constant_identifier_names

import 'dart:html';

import 'package:city_map/database/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

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
  

  
}

class DriverSheetFactory {
  static DriverSheet initSheet() {
    return DriverSheet(0, 0, null, _DriverCheckFactory.getChecks(), null);
  }
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
    return DriverSheetFactory.fromDocument(snapshot);
  }

  @override
  dynamic getDatabaseReference() {
    return FirebaseFirestore.instance.collection("DriverSheets").doc(driversheetID);
  }
}

class DriverSheetUploader{
 static Map<String, dynamic> toJson(DriverSheet driverSheet) {
  return {
    'endKM' : driverSheet.endKiloMeters,
    'startKM' : driverSheet.startKiloMeters,
    'vehicleChecks' : driverSheet.checks
  };
 } 
static Future<String?> upload(DriverSheet driverSheet) async {
  if (driverSheet.dbID != null) {
    return null;
  }
  Map<String, dynamic> json = toJson(driverSheet);
  DocumentReference reference = await FirebaseFirestore.instance.collection("DriverSheets").add(json);
  Logger().i("Added driversheet : ${reference.id}");
  driverSheet.dbID = reference.id;
  return reference.id;
}

static Future<void> update(DriverSheet driverSheet) async {
  Map<String, dynamic> json = toJson(driverSheet);
  await FirebaseFirestore.instance.collection("DriverSheets").doc(driverSheet.dbID).update(json);
}
}

enum _DriverCheck {
  TirePressure,
  VehicleBodyDamage,
  Strobes,
  ArrowBoard,
  RearViewCamera,
  Headlights,
  WindshieldWasher,
  TurnSignals,
  CheckEngineLight
}

class _DriverCheckFactory {
  static String toFormattedString(_DriverCheck check) {
    switch (check) {
      case _DriverCheck.TirePressure:
        return "Tire Pressure";
      case _DriverCheck.VehicleBodyDamage:
         return "Vehicle Body Damage";
      case _DriverCheck.Strobes:
        return "Strobes";
      case _DriverCheck.ArrowBoard:
        return "Arrow Board";
      case _DriverCheck.RearViewCamera:
        return "Rear View Camera";
      case _DriverCheck.Headlights:
        return "Head Lights";
      case _DriverCheck.WindshieldWasher:
        return "Windshield Washer Fluid";
      case _DriverCheck.TurnSignals:
        return "Turn Signals";
      case _DriverCheck.CheckEngineLight:
        return "Check Engine Light";
    }
  }
  static List<Map<String, dynamic>> getChecks() {
    List<Map<String,dynamic>> list = [];
    for (_DriverCheck check in _DriverCheck.values) {
      list.add({
        'type' : toFormattedString(check),
        'switched' : false,
        'description' : null
      });
    }
    return list;
  }
  
}