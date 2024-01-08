import 'package:city_map/database/database_helper.dart';
import 'package:city_map/task/dailycheck/dailycheck.dart';
import 'package:city_map/task/driversheet/driversheet.dart';
import 'package:city_map/worker/worker.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class WorkerGroupUploader implements IDBManager<WorkerGroup?> {
  @override
  Future<void> delete(WorkerGroup? value) async {
    if (value == null) {
      return;
    }
    if (value.id == null) {
      return;
    }
    await FirebaseFirestore.instance.collection("WorkerGroups").doc(value.id).delete();
    Logger().i("Deleted WorkerGroup ${value.id}");
    if (value.driverSheetID != null) {
      await FirebaseFirestore.instance.collection("DriverSheets").doc(value.driverSheetID).delete();
      Logger().i("Deleted DriverSheet ${value.driverSheetID}");
    }
    if (value.dailySheetID != null) {
      await FirebaseFirestore.instance.collection("DailyChecks").doc(value.dailySheetID).delete();
      Logger().i("Deleted DailyCheck ${value.dailySheetID}");
    }
    List<Worker>? workers = await WorkerGroupWorkerQuery(workerGroupID: value.id!).fromDatabase();
    for (Worker worker in workers!) {
      FirebaseFirestore.instance.collection("Workers").doc(worker.id).update({
        'workerGroup' : null
      });
    }
  }

  @override
  Map<String, dynamic> toJson(WorkerGroup? value) {
    if (value == null) {
      return {};
    }
    return {
      'areas' : value.areaIDs,
      'dailySheet' : value.dailySheetID,
      'driverSheet' : value.driverSheetID,
      'driver_id' : value.driverID,
      'manager_id' : value.managerID,
      'siteTasks' : value.siteTaskIDs
    };
  }

  @override
  Future<void> update(WorkerGroup? value) async {
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
    await FirebaseFirestore.instance.collection("WorkerGroups").doc(value.id).update(json);
  }

  @override
  Future<String?> upload(WorkerGroup? value) async {
    if (value == null) {
      return "";
    }
    if (value.id != null) {
      return "";
    }
    
    DailyCheckContainer dailyChecks = DailyCheckContainerFactory.initChecks();
    String? dailyCheckID = await DailyCheckUploader.upload(dailyChecks);
    value.dailySheetID = dailyCheckID;

    DriverSheet driverSheet = DriverSheetFactory.initSheet();
    String? driverSheetID = await DriverSheetUploader.upload(driverSheet);
    value.driverSheetID = driverSheetID;
    
    Map<String,dynamic> json = toJson(value);
    if (json.isEmpty) {
      return "";
    }

    DocumentReference documentReference = await FirebaseFirestore.instance.collection("WorkerGroups").add(json);
    Logger().i("Added Worker Group ${documentReference.id}");
    value.id = documentReference.id;
    return documentReference.id;
  }

}
