
import 'package:city_map/consts/global_constants.dart';
import 'package:city_map/database/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Worker {
  Worker({required this.id,required this.firstName,required this.lastName,required this.groupID,required this.managerID,required this.payroll});
  late String? id;
  late String? firstName;
  late String? lastName;
  late String? managerID;
  late String? payroll;
  late String? groupID;

  String? getFullName() {
    return "$firstName $lastName";
  }

}

class WorkerFactory {
  static Worker? fromDocument(DocumentSnapshot<Object?> snapshot) {
    if (!snapshot.exists) {
      return null;
    } 
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return Worker(
      id: snapshot.id, 
      firstName: snapshotData['firstName'], 
      lastName: snapshotData['lastName'], 
      groupID : snapshotData['workerGroup'], 
      managerID : snapshotData['manager_id'], 
      payroll : snapshotData['payroll']
    );
  }
}

class WorkerDatabaseHelper extends DatabaseHelper {
  final String workerID;
  WorkerDatabaseHelper({required this.workerID});
  @override
  Worker? fromDocument(DocumentSnapshot<Object?> snapshot) {
    return WorkerFactory.fromDocument(snapshot);
  }

  @override
  dynamic getDatabaseReference() {
    return FirebaseFirestore.instance.collection("Workers").doc(workerID);
  }
}

class ManagerWorkerQuery extends DatabaseQuery<Worker> {
  final String managerID;

  ManagerWorkerQuery({required this.managerID});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return WorkerFactory.fromDocument(snapshot);
  }

  @override
  getQuery() {
    return FirebaseFirestore.instance.collection("Workers").where("manager_id",isEqualTo: managerID);
  }
}

class WorkerGroupWorkerQuery extends DatabaseQuery<Worker> {
  final String workerGroupID;

  WorkerGroupWorkerQuery({required this.workerGroupID});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return WorkerFactory.fromDocument(snapshot);
  }

  @override
  getQuery() {
    return FirebaseFirestore.instance.collection("Workers").where("workerGroup",isEqualTo: workerGroupID);
  }

}

class WorkerNotInGroupQuery extends DatabaseQuery<Worker> {
  final String managerID;

  WorkerNotInGroupQuery({required this.managerID});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return WorkerFactory.fromDocument(snapshot);
  }

  @override
  getQuery() {
    return FirebaseFirestore.instance.collection("Workers")
    .where("manager_id",isEqualTo: managerID)
    .where("workerGroup",isEqualTo: null);
  }
}
