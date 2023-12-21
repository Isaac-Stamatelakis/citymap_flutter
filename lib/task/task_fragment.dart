import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/global_constants.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/area_display_list.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/task/site_task/site_task_list.dart';
import 'package:city_map/task/task_dialogs/daily_sheet_dialog.dart';
import 'package:city_map/task/task_dialogs/driver_sheet_dialog.dart';
import 'package:city_map/worker/worker.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


class TaskFragment extends StatefulWidget {
  const TaskFragment ({super.key});

  @override
  State<TaskFragment> createState() => _TaskFragmentState();

}

class _TaskFragmentState extends State<TaskFragment> {
  final CollectionReference users = FirebaseFirestore.instance.collection("Workers");
  @override
  Widget build(BuildContext context) {
    Size deviceSize = Helper.getDeviceSize(context);
    return Column(
      
      crossAxisAlignment: CrossAxisAlignment.center,
      
      children: [
        
        AppBar(
          backgroundColor: CustomColors.coeBlue,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(onPressed: (){
                Scaffold.of(context).openDrawer();
              }, 
              icon: Icon(Icons.menu));
            },
          ),
          title: Text("Tasks"),
          centerTitle: true,
        ),       
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
        Expanded(
          child: PageView(
            children: [
              SiteTaskDisplay(Provider.of<WorkerGroup>(context).siteTaskIDs,"Assigned Sites"),
              NeighborhoodDisplay(Provider.of<WorkerGroup>(context).areaIDs,"Assigned Areas")
            ]
          )  
        )
      ],
    );
  }

  void _driverButtonPress() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return const DriverSheetDialog();
      }
    );
  }
  void _dailyButtonPress() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return const DailySheetDialog();
      }
    );
  }
}

/// a widget which can be displayed on a page in TaskFragment
abstract class TaskDisplay extends StatelessWidget {
  final String title;
  const TaskDisplay(this.title,{super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: Helper.getDeviceSize(context).width*0.2,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.blue, // background color of the card
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20
            ),
            )
        ),
        const SizedBox(
          height: 30,
        ),
        _getListWidget(),
        
      ],
    );
  }
  Widget _getListWidget();
}

// Neighborhood Display for task fragment
class NeighborhoodDisplay extends TaskDisplay {
  final List<String>? _ids;
  const NeighborhoodDisplay(this._ids,super.title,{super.key});
  @override
  Widget _getListWidget() {
    return FutureBuilder(
          future: AreaMultiDatabaseRetriever(_ids).fromDatabase(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return AreaDisplayList(snapshot.data?.cast<Area>());
            }
          }
      );
  }

}

// SiteTaskDisplay 
class SiteTaskDisplay extends TaskDisplay {
  final List<String>? _ids;
  const SiteTaskDisplay(this._ids,super.title,{super.key});
  
  @override
  Widget _getListWidget() {
    return FutureBuilder(
          future: SiteTaskMultiRetriever(_ids).fromDatabase(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return SiteTaskDisplayList(snapshot.data?.cast<SiteTask>());
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


