import 'package:city_map/database/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Area {
  Area(this._name,this.primaryLocation,this._id);
  String? _name; String? get name => this._name; set name(String? value) => this._name = value;
  String? _id; get id => this._id; set id( value) => this._id = value;
  GeoPoint? primaryLocation;
  
}

class AreaFactory {
  static Area? fromDocument(DocumentSnapshot<Object?> snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return Area(snapshot['name'], snapshotData['primaryLocation'], snapshot.id);
  }
}
class AreaDatabaseRetriever extends DatabaseRetriever {
  AreaDatabaseRetriever({required super.id});
  @override
  Area? fromDocument(DocumentSnapshot<Object?> snapshot) {
    return AreaFactory.fromDocument(snapshot);
  }

  @override
  dynamic getDatabaseReference() {
    return FirebaseFirestore.instance.collection("Areas").doc(super.id);
  }

}


class AreaMultiDatabaseRetriever extends MultiDatabaseRetriever<Area> {
  AreaMultiDatabaseRetriever(super.ids);

  @override
  DatabaseRetriever getRetriever(String id) {
    return AreaDatabaseRetriever(id:id);
  }

}

class AreaManagerQuery extends DatabaseQuery {
  final String managerID;

  AreaManagerQuery({required this.managerID});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return AreaFactory.fromDocument(snapshot);
  }

  @override
  getQuery() {
    return FirebaseFirestore.instance.collection("Areas").where("manager_id",isEqualTo:managerID);
  }

}

class AreaUploader implements IDBManager<Area> {
  @override
  Future<void> delete(Area? value) async {
    if (value == null) {
      return;
    }
    await FirebaseFirestore.instance.collection("Areas").doc(value.id).delete();
    Logger().i("Deleted area ${value.id}");
  }

  @override
  Map<String, dynamic> toJson(Area? value) {
    if (value == null) {
      return {};
    }
    return {
      'name' : value.name,
      'primaryLocation' : value.primaryLocation
    };
  }

  @override
  Future<void> update(Area? value) async {
    if (value == null) {
      return;
    }
    dynamic map = toJson(value);
    if (map.isEmpty) {
      return;
    }
    await FirebaseFirestore.instance.collection("Areas").doc(value.id).update(map);
  }

  @override
  Future<String?> upload(Area? value) async {
    if (value == null) {
      return null;
    }
    if (value.id != null) {
      return null;
    }
    dynamic map = toJson(value);
    if (map.isEmpty) {
      return null;
    }
    DocumentReference reference = await FirebaseFirestore.instance.collection("Areas").add(map);
    Logger().i("Area uploaded ${reference.id}");
    value.id = reference.id;
    return reference.id;
  }

}