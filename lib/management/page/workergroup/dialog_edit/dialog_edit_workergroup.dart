import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/management/page/workergroup/dialog_edit/manage_group_state/group_manage_dialogstate.dart';
import 'package:city_map/management/page/workergroup/dialog_edit/worker_manage.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:flutter/material.dart';

class EditWorkerGroupDialog extends StatefulWidget {
  final WorkerGroup workerGroup;
  final Manager? manager;
  const EditWorkerGroupDialog({super.key, required this.workerGroup, required this.manager});

  @override
  State<StatefulWidget> createState() => _EditWorkerGroupDialogState();

}

class _EditWorkerGroupDialogState extends State<EditWorkerGroupDialog> {
  late _DialogState currentState = _DialogState.Manage_Group;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content:Container(
        height: double.infinity,
        width: GlobalHelper.getPreferredWidth(context),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
            child:  SingleChildScrollView(
              child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.indigo,
                  title: const Text(
                    "Manage Worker Group",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back, 
                      color: Colors.white
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  centerTitle: true,
                ),
                const SizedBox(height: 20),
                _DialogStateSelector(
                  onSelect: _onDialogStateSelected, 
                  options: _DialogState.values, 
                  initalSelect: currentState, 
                  size: const Size(300,80), 
                  color: Colors.white, 
                  textColor: Colors.black
                ),
                const SizedBox(height: 20),
                buildDialogState()
            ],
          )
        ) 
      ),
    );
  }

  void _onDialogStateSelected(_DialogState? state) {
    if (state == null) {
      return;
    }
    currentState = state;
    setState(() {
      
    });
  }

  Widget buildDialogState() {
    switch (currentState) {
      case _DialogState.Manage_Workers:
        return ManageWorkerLoader(managerID: widget.manager!.id, workerGroup: widget.workerGroup);
      case _DialogState.Manage_Group:
        return GroupManageDialogState(workerGroup: widget.workerGroup, manager: widget.manager);
    }
  }
}

enum _DialogState {
  Manage_Workers,
  Manage_Group,
}


class EnumFactory {
  static String stateToString(Enum val) {
    return val.toString().split(".")[1];
  }
  static String stateToFormattedString(Enum val) {
    return stateToString(val).replaceAll("_", " ");
  }
}


class _DialogStateSelector extends AbstractDropDownSelector<_DialogState> {
  const _DialogStateSelector({required super.onSelect, required super.options, required super.initalSelect, required super.size, required super.color, required super.textColor});

  @override
  State<StatefulWidget> createState() => _DialogStateSelectorState();

}

class _DialogStateSelectorState extends AbstractDropDownSelectorState<_DialogState> {
  @override
  String optionToString(_DialogState option) {
    return EnumFactory.stateToFormattedString(option);
  }
}


