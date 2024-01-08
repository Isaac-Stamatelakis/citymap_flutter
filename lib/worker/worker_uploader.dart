import 'dart:html';

import 'package:city_map/database/database_helper.dart';
import 'package:city_map/worker/worker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class WorkerUploader implements IDBManager<Worker?> {
  @override
  Future<void> delete(Worker? value) async {
    if (value == null) {
      return;
    }
    if (value.id == null) {
      return;
    }
    Map<String,dynamic> json = toJson(value);
    if (json.isEmpty) {
      return;
    }
    await FirebaseFirestore.instance.collection("Workers").doc(value.id).delete();
    Logger().i("Deleted Worker ${value.id}");
  }

  @override
  Map<String, dynamic> toJson(Worker? value) {
    if (value == null) {
      return {};
    }
    return {
      'firstName' : value.firstName,
      'lastName' : value.lastName,
      'manager_id' : value.managerID,
      'payroll' : value.payroll,
      'workerGroup' : value.groupID,
    };
  }

  @override
  Future<void> update(Worker? value) async {
    if (value == null) {
      return;
    }
    if (value.id == null) {
      return;
    }
    Map<String,dynamic> json = toJson(value);
    if (json.isEmpty) {
      return;
    }
    await FirebaseFirestore.instance.collection("Workers").doc(value.id).update(json);
  }

  @override
  Future<String?> upload(Worker? value) async {
    if (value == null) {
      return "";
    }
    if (value.id != null) {
      return "";
    }
    Map<String,dynamic> json = toJson(value);
    if (json.isEmpty) {
      return "";
    }
    
    json['created'] = DateTime.now();
    DocumentReference documentReference = await FirebaseFirestore.instance.collection("Workers").add(json);
    Logger().i("Added Worker ${documentReference.id}");
    value.id = documentReference.id;
    return documentReference.id;
  }
  
}