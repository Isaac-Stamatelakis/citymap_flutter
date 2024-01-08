import 'package:city_map/consts/loader.dart';
import 'package:city_map/management/page/workergroup/dialog_edit/search_select_manage.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/task/site_task/site_task_list.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:flutter/material.dart';

class ManageSiteLoader extends WidgetLoader {
  final String managerID;
  final WorkerGroup workerGroup;

  const ManageSiteLoader({super.key, required this.managerID, required this.workerGroup});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return _ManageSite(list: snapshot.data, workerGroup: workerGroup);
  }

  @override
  Future getFuture() {
    return SiteTaskManagerQuery(managerID: managerID).retrieve();
  }

}


class _ManageSite extends ManageSearchList<SiteTask> {
  const _ManageSite({required super.workerGroup, required super.list});
  @override
  State<StatefulWidget> createState() => _ManageSiteState();
}

class _ManageSiteState extends ManageSearchListState<SiteTask> {
  @override
  Widget getList() {
    return _ManageWorkerGroupSiteList(user: widget.workerGroup, list: displayedList);
  }

  @override
  bool searchCheck(SiteTask element) {
    return element.number.toString().toLowerCase().contains(search.toLowerCase());
  }

  @override
  bool sortCheck(SiteTask element) {
    return widget.workerGroup.siteTaskIDs!.contains(element.dbID);
  }
  
}

class _ManageWorkerGroupSiteList extends AbstractSiteTaskDisplayList<WorkerGroup> {
  const _ManageWorkerGroupSiteList({required super.user, required super.list});
  @override
  State<StatefulWidget> createState() => _ManageWorkerGroupSiteListState();
}

class _ManageWorkerGroupSiteListState extends AbstractSiteTaskDisplayListState<WorkerGroup> {
  @override
  onLongPress(SiteTask element, BuildContext context) {
    // Do Nothing
  }

  @override
  onPress(SiteTask element, BuildContext context) {
    setState(() {
      if (widget.user!.siteTaskIDs!.contains(element.dbID)) {
        widget.user!.siteTaskIDs!.remove(element.dbID!);
      } else {
        widget.user!.siteTaskIDs!.add(element.dbID!);
      }
    });
  }
  @override
  Widget? getTrailing(SiteTask element) {
    return getIcon(element);
  }
  @override
  Widget? getLeading(SiteTask element) {
    return getIcon(element);
  }

  Widget? getIcon(SiteTask element) {
    double size = 30;
    if (widget.user!.siteTaskIDs!.contains(element.dbID)) {
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