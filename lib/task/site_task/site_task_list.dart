import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/global_list.dart';
import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/area_list.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/task/site_task/site_task_dialog.dart';
import 'package:city_map/task/site_task/uploader_site_task.dart';
import 'package:city_map/task/task_fragment.dart';
import 'package:city_map/worker/worker.dart';
import 'package:flutter/material.dart';

abstract class AbstractSiteTaskDisplayList<T> extends AbstractList<T,SiteTask> {
  const AbstractSiteTaskDisplayList({super.key, required super.user, required super.list});
}

 class AbstractSiteTaskDisplayListState<T> extends AbstractListState<T,SiteTask> {
  @override
  Widget? getTrailing(SiteTask element) {
    double size = 50;
    return element.completed 
    ? Icon(
        Icons.check, 
        color: Colors.green,
        size: size,
      ) 
    : Icon(
        Icons.error_outline, 
        color: Colors.red,
        size: size,
    );
  }

  @override
  Widget getListTitleText(SiteTask element) {
    return Text(  
      "Site#${element.number.toString()}",
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }
  
  @override
  List<Color> getTileColors() {
    return [Colors.blue, Colors.blue.shade300];
  }
  
  @override
  Widget? getListSubTitleText(SiteTask element) {
    return Text(
      "Type${element.siteType}\n${element.description}",
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white70
      ),
    );
  }
  
  @override
  onLongPress(SiteTask element, BuildContext context) {
    // TODO: implement onLongPress
    throw UnimplementedError();
  }
  
  @override
  onPress(SiteTask element, BuildContext context) {
    // TODO: implement onPress
    throw UnimplementedError();
  }
}

class SiteTaskDisplayList extends AbstractSiteTaskDisplayList<Worker> {
  const SiteTaskDisplayList({super.key, required super.user, required super.list});
  @override
  State<StatefulWidget> createState() => _SiteTaskDisplayListState();
}

class _SiteTaskDisplayListState extends AbstractSiteTaskDisplayListState {
  @override
  onLongPress(SiteTask element, BuildContext context) {
    // Do nothing
  }

  @override
  onPress(SiteTask element, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SiteTaskListDialog(
          worker: widget.user, siteTask: element,
        );
      }
    );
    setState(() {});
  }
  

}