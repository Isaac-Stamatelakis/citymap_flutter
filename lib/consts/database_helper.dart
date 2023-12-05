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