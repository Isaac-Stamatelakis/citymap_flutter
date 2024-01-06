import 'package:city_map/database/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Area {
  Area(this._name,this._primaryLocation,this._id);
  String? _name; String? get name => this._name; set name(String? value) => this._name = value;
  String? _id; get id => this._id; set id( value) => this._id = value;
  GeoPoint? _primaryLocation; get getPrimaryLocation => this._primaryLocation; set setPrimaryLocation( primaryLocation) => this._primaryLocation = primaryLocation;
  
}

class AreaDatabaseRetriever extends DatabaseRetriever {
  AreaDatabaseRetriever({required super.id});
  @override
  Area? fromDocument(DocumentSnapshot<Object?> snapshot) {
    var snapshotData = snapshot.data() as Map<String, dynamic>;
    return Area(snapshot['name'], snapshotData['primaryLocation'], snapshot.id);
  }

  @override
  dynamic getDatabaseReference() {
    return FirebaseFirestore.instance.collection("Areas").doc(super.id);
  }

}


class AreaMultiDatabaseRetriever extends MultiDatabaseRetriever {
  AreaMultiDatabaseRetriever(super.ids);

  @override
  DatabaseRetriever getRetriever(String id) {
    return AreaDatabaseRetriever(id:id);
  }

}