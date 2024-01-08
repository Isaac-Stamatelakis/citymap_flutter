import 'dart:js_interop';

import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/management/page/site/dialog_site_edit.dart';
import 'package:city_map/management/page/workergroup/dialog_edit/dialog_edit_workergroup.dart';
import 'package:city_map/management/page/workergroup/dialog_edit/manage_group_state/area_groupmanage.dart';
import 'package:city_map/management/page/workergroup/dialog_edit/manage_group_state/driver_groupmanage.dart';
import 'package:city_map/management/page/workergroup/dialog_edit/manage_group_state/site_groupmanage.dart';
import 'package:city_map/management/page/workergroup/dialog_edit/search_select_manage.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/area_list.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/task/site_task/site_task_list.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:flutter/material.dart';

class GroupManageDialogState extends StatefulWidget {
  final WorkerGroup workerGroup;
  final Manager? manager;
  const GroupManageDialogState({super.key, required this.workerGroup, required this.manager});
  @override
  State<StatefulWidget> createState() => _State();

}

class _State extends State<GroupManageDialogState> {
  late _DialogManageWorkerState currentState = _DialogManageWorkerState.Manage_SiteTasks;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DialogManageGroupStateSelector(
          onSelect: _onStateSelected, 
          options: _DialogManageWorkerState.values, 
          initalSelect: currentState, 
          size: const Size(300,80), 
          color: Colors.white, 
          textColor: Colors.black
        ),
        buildState()
      ],
    );
  }

  void _onStateSelected(_DialogManageWorkerState? state) {
    setState(() {
      currentState = state!;
    }); 
  }
  Widget buildState() {
   switch(currentState) {
     case _DialogManageWorkerState.Manage_Areas:
       return ManageAreaLoader(managerID: widget.manager!.id, workerGroup: widget.workerGroup);
     case _DialogManageWorkerState.Manage_SiteTasks:
       return ManageSiteLoader(managerID: widget.manager!.id, workerGroup: widget.workerGroup);
     case _DialogManageWorkerState.Manage_Driver:
       return ManageDriverLoader(workerGroup: widget.workerGroup);
    } 
  }

}

enum _DialogManageWorkerState {
  Manage_Areas,
  Manage_SiteTasks,
  Manage_Driver
}

class _DialogManageGroupStateSelector extends AbstractDropDownSelector<_DialogManageWorkerState> {
  const _DialogManageGroupStateSelector({required super.onSelect, required super.options, required super.initalSelect, required super.size, required super.color, required super.textColor});

  @override
  State<StatefulWidget> createState() => _DialogManageGroupStateSelectorState();

}

class _DialogManageGroupStateSelectorState extends AbstractDropDownSelectorState<_DialogManageWorkerState> {
  @override
  String optionToString(_DialogManageWorkerState option) {
    return EnumFactory.stateToFormattedString(option);
  }
}





