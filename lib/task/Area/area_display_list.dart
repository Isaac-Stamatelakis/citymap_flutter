import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/area_list.dart';
import 'package:city_map/task/Area/dialog_area.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/worker/worker.dart';
import 'package:flutter/material.dart';

class AreaListLoaderID extends SizedWidgetLoader {
  final List<String> areaIDs;
  final Worker worker;
  const AreaListLoaderID({super.key, required super.size, required this.areaIDs, required this.worker});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return BaseAreaDisplayList(areas:snapshot.data, worker: worker);
  }

  @override
  Future getFuture() {
    return AreaMultiDatabaseRetriever(areaIDs).fromDatabase();
  }
}

class ManagerAreaListLoader extends SizedWidgetLoader {
  final String workerID;
  const ManagerAreaListLoader({super.key, required this.workerID}) : super(size: const Size(200,200));
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    Map<String,dynamic> data = snapshot.data;
    return Column(
      children: [
        BaseAreaDisplayList(areas:data['areas'], worker: data['worker'])
      ],
    );
  }

  @override
  Future getFuture() async {
    Worker worker = await WorkerDatabaseHelper(workerID: workerID).fromDatabase();
    Manager manager = await ManagerDatabaseRetriever(id: worker.managerID).fromDatabase();
    List<Area> areas = await AreaMultiDatabaseRetriever(manager.managedAreaIDs).fromDatabase();
    return {
      'worker' : worker,
      'areas' : areas
    };
  }
}


class BaseAreaDisplayList extends AbstractAreaDisplayList {
  const BaseAreaDisplayList({super.key, required super.worker, required super.areas});

  @override
  State<StatefulWidget> createState() => _BaseAreaDisplayListState();

}

class _BaseAreaDisplayListState extends AbstractAreaDisplayListState {
  @override
  onLongPress(Area element, BuildContext context) {
     // Do Nothing
  }

  @override
  onPress(Area element, BuildContext context) {
    _navigateAreaDialog(element,widget.worker!);
  }

  void _navigateAreaDialog(Area area, Worker worker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AreaDialogLoader(area: area, worker: worker);
      }
    );
  }

}