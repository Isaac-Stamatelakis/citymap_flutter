import 'package:city_map/database/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class DailyCheckContainer {
  late String? dbID;
  late List<Map<String,dynamic>> checks;
  DailyCheckContainer({required this.checks, required this.dbID});
}


class DailyCheckContainerRetriver extends DatabaseHelper {
  final String? dbID;

  DailyCheckContainerRetriver({required this.dbID});
  @override
  fromDocument(DocumentSnapshot<Object?> snapshot) {
    return DailyCheckContainerFactory.fromDocument(snapshot);
  }

  @override
  getDatabaseReference() {
    return FirebaseFirestore.instance.collection("DailyChecks").doc(dbID);
  }

}
class DailyCheckUploader {
 static Map<String, dynamic> toJson(DailyCheckContainer dailyCheck) {
  return {
    'dailyChecks' : dailyCheck.checks
  };
 } 
static Future<void> upload(DailyCheckContainer check) async {
  if (check.dbID != null) {
    return;
  }
  Map<String, dynamic> json = toJson(check);
  DocumentReference reference = await FirebaseFirestore.instance.collection("DailyChecks").add(json);
  Logger().i("Added driversheet : ${reference.id}");
  check.dbID = reference.id;
}

static Future<void> update(DailyCheckContainer check) async {
  Map<String, dynamic> json = toJson(check);
  await FirebaseFirestore.instance.collection("DailyChecks").doc(check.dbID).update(json);
}

 static DailyCheckContainer initChecks() {
  return DailyCheckContainer(checks: _DailyCheckFactory.initCheckMap(), dbID: null);
 }
}

enum _DailyCheck {
  Tools,
  First_Aid_Kit,
  Bug_Spray,
  Fuel,
  Tarps,
  Litter_Picker,
  SunScreen,
  Bug_Repellent,
  Weed_Wacker_Wire
}

class _DailyCheckFactory {
  static String toFormattedString(_DailyCheck check) {
    return check.toString().split(".")[1].replaceAll("_", " ");
  }

  static List<Map<String, dynamic>> initCheckMap() {
    List<Map<String,dynamic>> list = [];
    for (_DailyCheck check in _DailyCheck.values) {
      list.add({
        'checkName' : toFormattedString(check),
        'checked' : false
      });
    }
    return list;
  }
}

class DailyCheckContainerFactory {
  static DailyCheckContainer fromDocument(DocumentSnapshot snapshot) {
    List<Map<String,dynamic>> checkListJson = [];
    for (Map<String,dynamic> map in snapshot['dailyChecks']) {
      checkListJson.add(map);
    }
    return DailyCheckContainer(checks: checkListJson, dbID: snapshot.id);
  }
}