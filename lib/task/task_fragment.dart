import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/global_constants.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class _TaskFragmentState extends State<TaskFragment> {
  final CollectionReference users = FirebaseFirestore.instance.collection("Workers");
  @override
  Widget build(BuildContext context) {
    WorkerGroup workerGroup = Provider.of<WorkerGroup>(context);
    print(workerGroup.siteTaskIDs?.length);
    //print(workerGroup.dailySheetID);
    Size deviceSize = Helper.getDeviceSize(context);
    return Column(
      
      crossAxisAlignment: CrossAxisAlignment.center,
      
      children: [
        
        AppBar(
          backgroundColor: CustomColors.coeBlue,
          leading: Icon(Icons.ac_unit),
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
          children: const [
            TaskDisplay("Hello2"),
            TaskDisplay("Yo")
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
class TaskDisplay extends StatelessWidget {
  final String title;
  const TaskDisplay(this.title,{super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: 10,
            separatorBuilder: (_,__) => const SizedBox(),
            itemBuilder: (context,int index) {
                return TaskContent(index);
            } 
          )
        )
        
      ],

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
