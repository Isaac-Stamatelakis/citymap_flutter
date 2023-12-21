import 'package:city_map/consts/colors.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/task/site_task/site_task_dialog.dart';
import 'package:city_map/task/task_fragment.dart';
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

/*
class TaskContent extends StatelessWidget {
  final SiteTask _siteTask;
  const TaskContent(this._siteTask, {super.key});
  @override
  Widget build(BuildContext context) {
    return
        Container(
          color: Colors.brown,
          child: GestureDetector(
            child: ListTile(
              leading: const Icon(Icons.agriculture),
              title: Text(_siteTask.number.toString()),
              subtitle: Text("Type${_siteTask.siteType}\n${_siteTask.description}"),
              trailing: _getTrailingIcon(),
              onTap: () {
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return SiteTaskDialog(_siteTask);
                  }
                );
              }
          )
        ),
    );
    
    
  }
  Icon _getTrailingIcon() {
    return _siteTask.completed ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.error_outline, color: Colors.red);
  }
}
*/

class TaskContent extends StatefulWidget {
  final SiteTask _siteTask;
  const TaskContent(this._siteTask,{super.key});
  
  @override
  State<StatefulWidget> createState() => _TaskContentState();

}


class _TaskContentState extends State<TaskContent> {
  void _onCompletionChanged(SiteTask siteTask) {
    setState(() {
      widget._siteTask.completed = siteTask.completed;
    });
  }
  @override
  Widget build(BuildContext context) {
    return
        Container(
          color: Colors.brown,
          child: GestureDetector(
            child: ListTile(
              leading: const Icon(Icons.agriculture),
              title: Text(widget._siteTask.number.toString()),
              subtitle: Text("Type${widget._siteTask.siteType}\n${widget._siteTask.description}"),
              trailing: _getTrailingIcon(),
              onTap: () {
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return SiteTaskDialog(widget._siteTask,_onCompletionChanged);
                  }
                );
              }
          )
        ),
    );
  }

  Icon _getTrailingIcon() {
    return widget._siteTask.completed ? const Icon(Icons.check, color: Colors.green) : const Icon(Icons.error_outline, color: Colors.red);
  }
}
