import 'package:city_map/consts/helper.dart';
import 'package:flutter/material.dart';

class TaskFragment extends StatelessWidget {
  
  const TaskFragment({super.key});
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
          child: ListView(children : List.generate(20, (index) =>  TaskContent(index))))
        
        
      
      
        
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