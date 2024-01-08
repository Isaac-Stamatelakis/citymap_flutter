import 'package:city_map/consts/loader.dart';
import 'package:city_map/management/page/workergroup/dialog_edit/search_select_manage.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/area_list.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:flutter/material.dart';

class ManageAreaLoader extends WidgetLoader {
  final String managerID;
  final WorkerGroup workerGroup;

  const ManageAreaLoader({super.key, required this.managerID, required this.workerGroup});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return _ManageArea(list: snapshot.data, workerGroup: workerGroup);
  }

  @override
  Future getFuture() {
    return AreaManagerQuery(managerID: managerID).fromDatabase();
  }

}


class _ManageArea extends ManageSearchList<Area> {
  const _ManageArea({required super.workerGroup, required super.list});
  @override
  State<StatefulWidget> createState() => _ManageAreaState();
}

class _ManageAreaState extends ManageSearchListState<Area> {
  @override
  Widget getList() {
    return _ManageWorkerGroupAreaList(user: widget.workerGroup, list: displayedList);
  }

  @override
  bool searchCheck(Area element) {
    return element.name!.toString().toLowerCase().contains(search.toLowerCase());
  }

  @override
  bool sortCheck(Area element) {
    return widget.workerGroup.areaIDs!.contains(element.id);
  }
  
}

class _ManageWorkerGroupAreaList extends AbstractAreaDisplayList<WorkerGroup> {
  const _ManageWorkerGroupAreaList({required super.user, required super.list});
  @override
  State<StatefulWidget> createState() => _ManageWorkerGroupAreaListState();
}

class _ManageWorkerGroupAreaListState extends AbstractAreaDisplayListState<WorkerGroup> {
  @override
  onLongPress(Area element, BuildContext context) {
    // Do Nothing
  }

  @override
  onPress(Area element, BuildContext context) {
    setState(() {
      if (widget.user!.areaIDs!.contains(element.id)) {
        widget.user!.areaIDs!.remove(element.id!);
      } else {
        widget.user!.areaIDs!.add(element.id!);
      }
    });
  }
  @override
  Widget? getTrailing(Area element) {
    return getIcon(element);
  }
  @override
  Widget? getLeading(Area element) {
    return getIcon(element);
  }

  Widget? getIcon(Area element) {
    double size = 30;
    if (widget.user!.areaIDs!.contains(element.id)) {
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