// ignore_for_file: constant_identifier_names

import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/global_constants.dart';
import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/area_display_list.dart';
import 'package:city_map/task/dailycheck/dailycheck.dart';
import 'package:city_map/task/dailycheck/dialoge_dailycheck.dart';
import 'package:city_map/task/driversheet/driversheet.dart';
import 'package:city_map/task/driversheet/driversheet_dialog.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/task/site_task/site_task_list.dart';
import 'package:city_map/worker/worker.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


class TaskFragmentLoader extends SizedWidgetLoader {
  final String workerID;
  const TaskFragmentLoader({super.key, required this.workerID, required super.size});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    Map<String,dynamic> map = snapshot.data;
    return TaskFragment(
      worker: map['worker'], 
      workerGroup: map['worker_group']
    );
  }

  @override
  Future getFuture() async {
    Worker worker = await WorkerDatabaseHelper(workerID: workerID).fromDatabase();
    WorkerGroup workerGroup = await WorkerGroupDatabaseHelper(id: worker.groupID).fromDatabase();
    return {
      'worker' : worker,
      'worker_group' : workerGroup
    };
  }
}


class TaskFragment extends StatefulWidget {
  final Worker worker;
  final WorkerGroup workerGroup;
  const TaskFragment ({super.key, required this.worker, required this.workerGroup});

  @override
  State<TaskFragment> createState() => _TaskFragmentState();

}

class _TaskFragmentState extends State<TaskFragment> {
  late _TaskState selectedState = _TaskState.AssignedSites;
  @override
  Widget build(BuildContext context) {
    Size deviceSize = GlobalHelper.getDeviceSize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [      
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox( 
              width: deviceSize.width*0.3,
              height: 40,
              child: ElevatedButton(
                onPressed: () {_driverButtonPress();},
                child: const Text('Driver Sheet')
              ),
            ),
            SizedBox(
              width: deviceSize.width*0.025,
            ),
            SizedBox(
              width: deviceSize.width*0.3,
              height: 40,
              child: ElevatedButton(
                onPressed: () {_dailyButtonPress();},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Daily Sheet'),
                    SizedBox(
                      width: deviceSize.width*0.005,
                    ),
                    const Icon(Icons.edit)
                  ],
                ) 
              ),
            ),
          ]
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
              colors: [Colors.green, Colors.green.shade300],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: _TaskDropDownSelector(
            onSelect:_onMenuSelect, 
            size: Size(MediaQuery.of(context).size.width/2,50), 
            color: Colors.green, 
            textColor: Colors.white,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(child: _getTaskContent()) 
      ],
    );
  }

  void _onMenuSelect(_TaskState? state) {
    selectedState = state!;
    setState(() {
      
    });
  }
  Widget _getTaskContent() {
    switch (selectedState) {
      case _TaskState.AssignedSites:
        return SiteTaskDisplay(ids: widget.workerGroup.siteTaskIDs, worker: widget.worker);
      case _TaskState.AssignedAreas:
        return NeighborhoodDisplay(ids: widget.workerGroup.areaIDs, worker: widget.worker);
    }
  }
  
  void _driverButtonPress() async {
    DriverSheet driverSheet = await DriverSheetDatabaseHelper(widget.workerGroup.driverSheetID!).fromDatabase();
    _showDriverSheet(driverSheet);
  }
  void _showDriverSheet(DriverSheet driverSheet) async {
    await showDialog(
      context: context, 
      builder: (BuildContext context) {
        return DriverSheetDialog(driverSheet: driverSheet);
      }
    );
    DriverSheetUploader.update(driverSheet);

  }
  void _dailyButtonPress() async {
    DailyCheckContainer dailyCheckContainer = await DailyCheckContainerRetriver(dbID: widget.workerGroup.dailySheetID).fromDatabase();
    _showDailyCheck(dailyCheckContainer);
  }

  void _showDailyCheck(DailyCheckContainer checkContainer) async {
    await showDialog(
      context: context, 
      builder: (BuildContext context) {
        return DailyCheckDialog(checkContainer: checkContainer);
      }
    );
    DailyCheckUploader.update(checkContainer);
  }
}

enum _TaskState {
  AssignedSites,
  AssignedAreas,
}
class _TaskDropDownSelector extends AbstractDropDownSelector<_TaskState> {
  const _TaskDropDownSelector({
    required super.onSelect, 
    required super.size, 
    required super.color, 
    required super.textColor
  }) : super(initalSelect: _TaskState.AssignedSites, options: _TaskState.values);

  @override
  State<StatefulWidget> createState() => _TaskDropDownSelectorState();

}
class _TaskDropDownSelectorState extends AbstractDropDownSelectorState<_TaskState> {
  @override
  String optionToString(_TaskState option) {
    return option.toString().split(".")[1];
  }

}


/// a widget which can be displayed on a page in TaskFragment
abstract class TaskDisplay extends StatelessWidget {
  final Worker worker;
  const TaskDisplay({super.key, required this.worker});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getListWidget(),
        
      ],
    );
  }
  Widget _getListWidget();
}

// Neighborhood Display for task fragment
class NeighborhoodDisplay extends TaskDisplay {
  final List<String>? ids;
  const NeighborhoodDisplay({super.key, required this.ids, required super.worker});

  @override
  Widget _getListWidget() {
    return FutureBuilder(
          future: AreaMultiDatabaseRetriever(ids).fromDatabase(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return BaseAreaDisplayList(areas:snapshot.data?.cast<Area>(), worker: worker);
            }
          }
      );
  }

}

// SiteTaskDisplay 
class SiteTaskDisplay extends TaskDisplay {
  final List<String>? ids;
  const SiteTaskDisplay({super.key, required this.ids, required super.worker});
  
  @override
  Widget _getListWidget() {
    return FutureBuilder(
          future: SiteTaskMultiRetriever(ids).fromDatabase(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Expanded(child: SiteTaskDisplayList(snapshot.data?.cast<SiteTask>(), worker: worker,));
            }
          }
      );
  }
  
}

class TaskContent extends StatelessWidget {
  final int val;
  const TaskContent(this.val, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: const ListTile(
        leading: Icon(Icons.date_range),
        title: Text("Hello"),
        subtitle: Text("subtitle"),
        trailing: Icon(Icons.developer_mode),
      ),
    );
  }
}


