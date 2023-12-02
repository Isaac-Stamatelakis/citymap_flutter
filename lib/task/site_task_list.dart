import 'package:city_map/task/site_task.dart';
import 'package:flutter/material.dart';

class SiteTaskDisplayList extends StatelessWidget {
  final List<SiteTask>? siteTasks;
  const SiteTaskDisplayList(this.siteTasks,{super.key});
  @override
  Widget build(BuildContext context) {
    return 
      Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: siteTasks!.length,
          separatorBuilder: (_,__) => const SizedBox(),
          itemBuilder: (context,int index) {
              return TaskContent(siteTasks![index]);
          } 
        )
      );
  }
}

class TaskContent extends StatelessWidget {
  final SiteTask siteTask;
  const TaskContent(this.siteTask, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: ListTile(
        leading: const Icon(Icons.agriculture),
        title: Text(siteTask.number.toString()),
        subtitle: Text(siteTask.description),
        trailing: _getTrailingIcon(),
      ),
    );
  }
  Icon _getTrailingIcon() {
    return  siteTask.completed ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.close, color: Colors.red);
  }
}