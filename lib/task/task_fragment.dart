import 'package:city_map/consts/global_constants.dart';
import 'package:city_map/consts/helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class _TaskFragmentState extends State<TaskFragment> {
  final CollectionReference users = FirebaseFirestore.instance.collection("Workers");
  @override
  Widget build(BuildContext context) {
    Size deviceSize = Helper.getDeviceSize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      
      children: [
        const SizedBox(
          height: 20,
        ),
        Center(
        child: SizedBox(
          width: deviceSize.width*0.3,
          height: 40,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Button 1')
          ),
        ),
        ),
        
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: deviceSize.width*0.3,
          height: 40,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Button 2')
          ),
        ),
        Expanded(
          child: PageView(
            children: [
              FutureBuilder(
                future: users.doc(GlobalValues.user_id).get(), 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    var userData = snapshot.data!.data() as Map<String, dynamic>;
                    return Center(
                      child: Text('User Name: ${userData['firstName']}'),
                    );
                  }
                  }
                )
            ],
          )  
        )
      ],
    );
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
    return Stack(
      children: [
        Text(title),
        ListView(children : List.generate(20, (index) =>  TaskContent(index))),
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