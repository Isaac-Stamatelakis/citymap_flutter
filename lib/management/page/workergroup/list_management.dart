
import 'package:city_map/consts/global_list.dart';
import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/management/page/workergroup/dialog_edit/dialog_edit_workergroup.dart';
import 'package:city_map/worker/worker.dart';
import 'package:city_map/worker/worker_group/list_worker_group.dart';
import 'package:city_map/worker/worker_group/uploader_worker_group.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ManagerWorkerGroupList<Manager> extends AbstractWorkerGroupList {
  const ManagerWorkerGroupList({super.key, required super.user, required super.list});
  @override
  State<StatefulWidget> createState() => _ManagerWorkerGroupListState();

}
class _ManagerWorkerGroupListState<Manager> extends AbstractWorkerGroupListState {
  @override
  onLongPress(WorkerGroup element, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog<WorkerGroup>(
          displayText: "Are You Sure You Want To Delete This WorkerGroup?", 
          onConfirmCallback: _onDeleteConfirmed, 
          value: element,
        );
      }
    );
  }

  void _onDeleteConfirmed(WorkerGroup? workerGroup, BuildContext context) async  {
    await WorkerGroupUploader().delete(workerGroup);
    setState(() {
      widget.list!.remove(workerGroup);
    });
  }
  @override
  onPress(WorkerGroup element, BuildContext context) async {
    if (element.id == null) {
      return;
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditWorkerGroupDialog(
          workerGroup: element, 
          manager: widget.user,
        );
      }
    );
    WorkerGroupUploader().update(element);
    setState(() {
       
    });
    
  }

}