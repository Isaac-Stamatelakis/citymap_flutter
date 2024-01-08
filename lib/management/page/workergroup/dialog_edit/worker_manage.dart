import 'package:city_map/consts/loader.dart';
import 'package:city_map/management/page/workergroup/dialog_edit/search_select_manage.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/area_list.dart';
import 'package:city_map/worker/worker.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:city_map/worker/worker_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageWorkerLoader extends WidgetLoader {
  final String managerID;
  final WorkerGroup workerGroup;

  const ManageWorkerLoader({super.key, required this.managerID, required this.workerGroup});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return _ManageWorker(list: snapshot.data, workerGroup: workerGroup);
  }

  @override
  Future getFuture() async {
    List<Worker>? workersNotInGroup = await WorkerNotInGroupQuery(managerID: managerID).fromDatabase();
    List<Worker>? workersInThisGroup = await WorkerGroupWorkerQuery(workerGroupID: workerGroup.id!).fromDatabase();
    List<Worker>? allWorkers = [];
    allWorkers.addAll(workersNotInGroup!);
    allWorkers.addAll(workersInThisGroup!);
    return allWorkers;
  }

}


class _ManageWorker extends ManageSearchList<Worker> {
  const _ManageWorker({required super.workerGroup, required super.list});
  @override
  State<StatefulWidget> createState() => _ManageWorkerState();
}

class _ManageWorkerState extends ManageSearchListState<Worker> {
  @override
  Widget getList() {
    return _ManageWorkerGroupWorkerList(user: widget.workerGroup, list: displayedList);
  }

  @override
  bool searchCheck(Worker element) {
    return element.getFullName()!.toString().toLowerCase().contains(search.toLowerCase());
  }

  @override
  bool sortCheck(Worker element) {
    return element.groupID == widget.workerGroup.id;
  }
  
}

class _ManageWorkerGroupWorkerList extends AbstractWorkerList<WorkerGroup> {
  const _ManageWorkerGroupWorkerList({required super.user, required super.list});
  @override
  State<StatefulWidget> createState() => _ManageWorkerGroupWorkerListState();
}

class _ManageWorkerGroupWorkerListState extends AbstractWorkerListState<WorkerGroup> {
  @override
  onLongPress(Worker element, BuildContext context) {
    // Do Nothing
  }

  @override
  onPress(Worker element, BuildContext context) {
    setState(() {
      if (widget.user!.id == element.groupID) {
        element.groupID = null;
      } else {
        element.groupID = widget.user!.id;
      }
    });
    FirebaseFirestore.instance.collection("Workers").doc(element.id).update({
      'workerGroup' : element.groupID
    });
  }
  
  @override
  Widget? getTrailing(Worker element) {
    return getIcon(element);
  }
  @override
  Widget? getLeading(Worker element) {
    return getIcon(element);
  }

  Widget? getIcon(Worker element) {
    double size = 30;
    if (widget.user!.id == element.groupID) {
      return Icon(
        Icons.radio_button_on,
        color: Colors.green,
        size: size,
      );
    } else {
      return Icon(
        Icons.radio_button_off,
        color: Colors.red,
        size: size,
      );
    }
  }
}