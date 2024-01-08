import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/main_scaffold.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/management/page/workergroup/list_management.dart';
import 'package:city_map/task/dailycheck/dailycheck.dart';
import 'package:city_map/task/driversheet/driversheet.dart';
import 'package:city_map/worker/worker.dart';
import 'package:city_map/worker/worker_group/uploader_worker_group.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:city_map/worker/worker_uploader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/async.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:logger/logger.dart';

class ManageWorkerGroupPageLoader extends WidgetLoader {
  final Manager manager;

  const ManageWorkerGroupPageLoader({super.key, required this.manager});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return MainScaffold(
      title: "Manage WorkerGroups", 
      initalPage: MainPage.Management, 
      userID: manager.workerID,
      content: _ManageWorkerGroupPage(
        manager: manager, 
        workerGroups: snapshot.data['worker_groups'], 
        workers: snapshot.data['workers']
      )
    );
  }

  @override
  Future getFuture() async {
    List<WorkerGroup>? workerGroups = await ManagerWorkerGroupQuery(managerID: manager.id).fromDatabase();
    List<Worker>? workers = await ManagerWorkerQuery(managerID: manager.id).fromDatabase();
    return {
      'worker_groups' : workerGroups,
      'workers' : workers,
    };
  }

}
class _ManageWorkerGroupPage extends StatefulWidget {
  final Manager manager;
  final List<WorkerGroup> workerGroups;
  final List<Worker> workers;
  const _ManageWorkerGroupPage({super.key, required this.manager, required this.workerGroups, required this.workers});
  @override
  State<StatefulWidget> createState() => _ManageWorkerGroupPageState();

}

class _ManageWorkerGroupPageState extends State<_ManageWorkerGroupPage> {
  final double seperation = 60;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ManagerWorkerGroupList(
                user: widget.manager, 
                list: widget.workerGroups
              )
            ) 
          ],
        ),
        Positioned(
          bottom: 20+seperation*3,
          left: 20,
          child: FloatingActionButton(
            heroTag: 'addButton',
            backgroundColor: Colors.blue,
            onPressed: (){_onAddPress(context);},
            child:  const Icon(
              Icons.add,
              color: Colors.white
            )
          )
        ),
        Positioned(
          bottom: 20+seperation*2,
          left: 20,
          child: FloatingActionButton(
            heroTag: 'resetButton',
            backgroundColor: Colors.red,
            onPressed: (){_onResetPress(context);},
            child:  const Icon(
              Icons.restart_alt,
              color: Colors.white
            )
          )
        ),
        Positioned(
          bottom: 20+seperation,
          left: 20,
          child: FloatingActionButton(
            heroTag: 'randomizeButton',
            backgroundColor: Colors.red,
            onPressed: (){_onRandomizePress(context);},
            child:  const Icon(
              Icons.shuffle,
              color: Colors.white
            )
          )
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: FloatingActionButton(
            heroTag: 'deleteButton',
            backgroundColor: Colors.red,
            onPressed: (){_onDeletePress(context);},
            child:  const Icon(
              Icons.delete,
              color: Colors.white
            )
          )
        ),
      ],
    );
  }

  void _onAddPress(BuildContext context) async {
    WorkerGroup workerGroup = _initWorkerGroup();
    await WorkerGroupUploader().upload(workerGroup);
    setState(() {
      widget.workerGroups.add(workerGroup);
    });
  }

  void _onResetPress(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog<dynamic>(
          displayText: "Are you sure you want to reset all tasks of your worker groups?", 
          onConfirmCallback: _onResetConfirmed, 
          value: widget.workerGroups,
        );
      }
    );
  }

  void _onResetConfirmed(dynamic value, BuildContext context) async {
    for (WorkerGroup workerGroup in widget.workerGroups) {
      workerGroup.areaIDs = []; 
      workerGroup.siteTaskIDs = [];
      workerGroup.driverID = null;
      await WorkerGroupUploader().update(workerGroup);

      DailyCheckContainer dailyCheckContainer = DailyCheckContainerFactory.initChecks();
      dailyCheckContainer.dbID = workerGroup.dailySheetID;
      await DailyCheckUploader.update(dailyCheckContainer);

      DriverSheet driverSheet = DriverSheetFactory.initSheet();
      driverSheet.dbID = workerGroup.driverSheetID;
      await DriverSheetUploader.update(driverSheet);
    }
    Logger().i("Reset Complete");
  }

  void _onDeleteConfirmed(dynamic value, BuildContext context) async {
    await _deleteAll();
    setState(() {
      widget.workerGroups.clear();
    });
  }

  Future<void> _deleteAll() async {
    for (WorkerGroup workerGroup in widget.workerGroups) {
      await WorkerGroupUploader().delete(workerGroup);
    }
  }

  void _onDeletePress(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog<dynamic>(
          displayText: "Are you sure you want to clear all your worker groups?", 
          onConfirmCallback: _onDeleteConfirmed, 
          value: widget.workerGroups,
        );
      }
    );
  }

  void _onRandomizePress(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog<dynamic>(
          displayText: "Are you sure you want to randomize all worker groups?", 
          onConfirmCallback: _onRandomizePressConfirmed, 
          value: widget.workerGroups,
        );
      }
    );
  }

  void _onRandomizePressConfirmed(dynamic value, BuildContext context) async{
    await _deleteAll();
    setState(() {
      widget.workerGroups.clear();
    });
    List<Worker>? managedWorkers = await ManagerWorkerQuery(managerID: widget.manager.id).fromDatabase();
    if (managedWorkers == null) {
      return;
    }
    List<WorkerGroup> workerGroups = [];
    if (managedWorkers.length == 1) {
      WorkerGroup workerGroup = _initWorkerGroup();
      String? id = await WorkerGroupUploader().upload(workerGroup);
      await _updateWorkerGroupID(managedWorkers[0],id);
      workerGroup.id = id;
      setState(() {
         workerGroups.add(workerGroup);
      });
      return;
    }
    int groupsOfThree = 0; int groupsOfTwo = 0;
    switch (managedWorkers.length%3) {
      case 0:
        groupsOfThree = (managedWorkers.length/3).floor();
        break;
      case 1:
        groupsOfThree = (managedWorkers.length/3-1).floor()-1;
        groupsOfTwo = 2;
        break;
      case 2:
        groupsOfThree = (managedWorkers.length/3+1).floor()-1;
        groupsOfTwo = 1;
        break;
    }
    int i = 0;
    while (groupsOfThree > 0) {
      WorkerGroup workerGroup = _initWorkerGroup();
      String? id = await WorkerGroupUploader().upload(workerGroup);
      for (int j = 0; j < 3; j ++) {
        await _updateWorkerGroupID(managedWorkers[j+i],id);
      }
      workerGroup.id = id;
      i += 3;
      groupsOfThree -= 1;
    }
    while (groupsOfTwo > 0) {
      WorkerGroup workerGroup = _initWorkerGroup();
      String? id = await WorkerGroupUploader().upload(workerGroup);
      for (int j = 0; j < 2; j ++) {
        await _updateWorkerGroupID(managedWorkers[j+i],id);
      }
      workerGroup.id = id;
      i += 2;
      groupsOfTwo -= 1;
    }
    List<WorkerGroup>? newGroups = await ManagerWorkerGroupQuery(managerID: widget.manager.id).fromDatabase();
    setState(() {
      widget.workerGroups.addAll(newGroups!);
    });
    
  }

  void _addWorker(BuildContext context) {
    Worker worker = Worker(id: null, firstName: "Joe", lastName: "Mom", groupID: null, managerID: widget.manager.id, payroll: "1234567");
    WorkerUploader().upload(worker);
  }

  WorkerGroup _initWorkerGroup() {
    return WorkerGroup(
      dailySheetID: null, 
      driverSheetID: null, 
      driverID: null, 
      managerID: widget.manager.id, 
      siteTaskIDs: [], 
      areaIDs: [], 
      id: null
    );
  }

  Future<void> _updateWorkerGroupID(Worker worker, String? id) async {
    await FirebaseFirestore.instance.collection("Workers").doc(worker.id).update({
      'workerGroup': id
    });
  }
}