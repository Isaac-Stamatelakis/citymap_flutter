
import 'package:city_map/consts/global_constants.dart';
import 'package:city_map/database/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Worker {
  Worker(this._id,this._firstName,this._lastName,this._groupID,this._managerID,this._payroll);
  String _id;
  String _firstName;
  String _lastName;
  String _managerID;
  String _payroll;
  String _groupID;
  String get id => this._id;

  set id(String value) {
    this._id = value;
  }

  get firstName => this._firstName;

  set firstName( value) => this._firstName = value;

  get lastName => this._lastName;

  set lastName( value) => this._lastName = value;

  get managerID => this._managerID;

  set managerID( value) => this._managerID = value;

  get payroll => this._payroll;

  set payroll( value) => this._payroll = value;

  get groupID => this._groupID;

  set groupID( value) => {this._groupID = value};
}

class WorkerDatabaseHelper extends DatabaseHelper {
  final String workerID;
  WorkerDatabaseHelper({required this.workerID});
  @override
  Worker? fromDocument(DocumentSnapshot<Object?> snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return Worker(snapshot.id, snapshotData['firstName'], snapshotData['lastName'], snapshotData['workerGroup'], snapshotData['manager_id'], snapshotData['payroll']);
  }

  @override
  dynamic getDatabaseReference() {
    return FirebaseFirestore.instance.collection("Workers").doc(workerID);
  }
}

class WorkerFactory {
  static Worker? fromDocument(DocumentSnapshot<Object?> snapshot) {
    if (!snapshot.exists) {
      return null;
    } 
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return Worker(snapshot.id, snapshotData['firstName'], snapshotData['lastName'], snapshotData['workerGroup'], snapshotData['manager_id'], snapshotData['payroll']);
  }
}

