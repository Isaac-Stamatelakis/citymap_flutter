import 'package:city_map/consts/global_list.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/main_scaffold.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/worker/worker.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:city_map/worker/worker_uploader.dart';
import 'package:flutter/material.dart';

abstract class AbstractWorkerGroupList<H> extends AbstractList<H,WorkerGroup> {
  const AbstractWorkerGroupList({super.key, required super.user, required super.list});
}

abstract class AbstractWorkerGroupListState<H> extends AbstractListState<H,WorkerGroup> {
  @override
  Widget getListTitleText(WorkerGroup element) {
    if (element.id == null) {
      return const Text(
        "Empty Group",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white
        ),
      );
    }
    return _WorkerGroupTextLoader(workerGroupID: element.id!);
  }
  @override
  List<Color> getTileColors() {
    return [Colors.blue,Colors.blue.shade300];
  }
}

class _WorkerGroupTextLoader extends WidgetLoader {
  final String workerGroupID;

  const _WorkerGroupTextLoader({required this.workerGroupID});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    String string = "";
    List<Worker> workers = snapshot.data;
    for (int i = 0; i < workers.length; i ++) {
      string += "${workers[i].firstName} ${workers[i].lastName}";
      if (i < workers.length-1) {
        string += ", ";
      }
    }
    if (string.isEmpty) {
      string = "Empty Group";
    }
    return Text(
      string,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white
      ),
    );
  }
  @override
  Future getFuture() {
    return WorkerGroupWorkerQuery(workerGroupID: workerGroupID).fromDatabase();
  }
}