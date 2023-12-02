import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/global_constants.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/task/site_task.dart';
import 'package:city_map/task/site_task_list.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class _TaskFragmentState extends State<TaskFragment> {
  WorkerGroup? _workerGroup;
  final CollectionReference users = FirebaseFirestore.instance.collection("Workers");
  @override
  Widget build(BuildContext context) {
    _workerGroup = Provider.of<WorkerGroup>(context);
    print(_workerGroup?.siteTaskIDs?.length);
    //print(workerGroup.dailySheetID);
    Size deviceSize = Helper.getDeviceSize(context);
    return Column(
      
      crossAxisAlignment: CrossAxisAlignment.center,
      
      children: [
        
        AppBar(
          backgroundColor: CustomColors.coeBlue,
          leading: Icon(Icons.agriculture, color: Colors.amber),
          title: Text("Task Fragment"),
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
        child: 
        PageView(
          children: [
            SiteTaskDisplay(_workerGroup?.siteTaskIDs,"yoyo"),
            const NeighborhoodDisplay("Yo")
          ],
        )  
       ) 
      ],
    );
  }

  void _driverButtonPress() {

  }
  void _dailyButtonPress() {

  }
}

class TaskFragment extends StatefulWidget {
  const TaskFragment ({super.key});

  @override
  State<TaskFragment> createState() => _TaskFragmentState();

}
abstract class TaskDisplay extends StatelessWidget {
  final String title;
  const TaskDisplay(this.title,{super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        _getListWidget()
      ],
    );
  }
  Widget _getListWidget();
}
class NeighborhoodDisplay extends TaskDisplay {
  const NeighborhoodDisplay(super.title,{super.key});
  @override
  Widget _getListWidget() {
    return Text("THIS WILL BE SOMETHING EVENTUALLY!");
  }

}

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
              return SiteTaskDisplayList(snapshot.data);
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
