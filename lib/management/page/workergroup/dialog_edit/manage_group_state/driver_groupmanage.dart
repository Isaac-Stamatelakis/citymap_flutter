import 'package:city_map/consts/loader.dart';
import 'package:city_map/management/page/workergroup/dialog_edit/search_select_manage.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/area_list.dart';
import 'package:city_map/worker/worker.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:city_map/worker/worker_list.dart';
import 'package:flutter/material.dart';

class ManageDriverLoader extends WidgetLoader {
  final WorkerGroup workerGroup;

  const ManageDriverLoader({super.key, required this.workerGroup});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return _ManageDriver(list: snapshot.data, workerGroup: workerGroup);
  }

  @override
  Future getFuture() {
    return WorkerGroupWorkerQuery(workerGroupID: workerGroup.id!).fromDatabase();
  }

}


class _ManageDriver extends ManageSearchList<Worker> {
  const _ManageDriver({required super.workerGroup, required super.list});
  @override
  State<StatefulWidget> createState() => _ManageAreaState();
}

class _ManageAreaState extends ManageSearchListState<Worker> {
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
    if (widget.workerGroup.driverID == null) {
      return false;
    }
    return widget.workerGroup.driverID! == element.id;
  }
  
}

class _ManageWorkerGroupWorkerList extends AbstractWorkerList<WorkerGroup> {
  const _ManageWorkerGroupWorkerList({required super.user, required super.list});
  @override
  State<StatefulWidget> createState() => _ManageWorkerGroupAreaListState();
}

class _ManageWorkerGroupAreaListState extends AbstractWorkerListState<WorkerGroup> {
  @override
  onLongPress(Worker element, BuildContext context) {
    // Do Nothing
  }

  @override
  onPress(Worker element, BuildContext context) {
    setState(() {
      widget.user!.driverID = element.id;
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
    if (widget.user!.driverID == null) {
      return null;
    }
    if (widget.user!.driverID! == element.id) {
      return Icon(
        Icons.car_rental_outlined,
        color: Colors.black,
        size: size,
      );
    }
    return null;
  }
}