import 'package:city_map/task/site_task/site_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

abstract class DatabaseHelper {
  Future<dynamic> fromDatabase() async {
    try {
      DocumentSnapshot documentSnapshot = await getDatabaseReference().get();
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        return fromDocument(documentSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      Logger().e('Error retrieving from database: $e');
      return null;
    }
  }
  dynamic fromDocument(DocumentSnapshot snapshot);

  dynamic getDatabaseReference();
}


abstract class DatabaseRetriever extends DatabaseHelper {
  final String id;
  DatabaseRetriever({required this.id});
  
}

abstract class MultiDatabaseRetriever {
  final List<String>? _ids;
  MultiDatabaseRetriever(this._ids);
  Future<List<dynamic>> fromDatabase() async {
    List<dynamic> retrieved = [];
    for (String id in _ids!) {
      retrieved.add(await getRetriever(id).fromDatabase());
    }
    return retrieved;
  }
  DatabaseRetriever getRetriever(String id);
}

abstract class DatabaseQuery {
  Future<List<dynamic>?> fromDatabase() async {
    try {
      List<dynamic> queryResults = [];
      QuerySnapshot querySnapshot = await getQuery().get();
      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        queryResults.add(fromDocument(snapshot));
      }
      return queryResults;
    } catch (e) {
      Logger().e('Error retrieving from database: $e');
      return null;
    }
  }
  dynamic fromDocument(DocumentSnapshot snapshot);

  dynamic getQuery();
}

