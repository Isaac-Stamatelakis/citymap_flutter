import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/task/site_task/site_task_dialog.dart';
import 'package:city_map/task/task_fragment.dart';
import 'package:city_map/worker/worker.dart';
import 'package:flutter/material.dart';

class SiteTaskDisplayList extends StatelessWidget {
  final Worker worker;
  final List<SiteTask>? siteTasks;
  const SiteTaskDisplayList(this.siteTasks,{super.key, required this.worker});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: siteTasks!.length,
      separatorBuilder: (_,__) => const SizedBox(),
      itemBuilder: (context,int index) {
          return TaskContent(siteTasks![index], worker: worker);
      }  
    );
  }
}

class TaskContent extends StatefulWidget {
  final Worker worker;
  final SiteTask _siteTask;
  const TaskContent(this._siteTask,{super.key, required this.worker});
  
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
    return GestureDetector(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 80,
            width: GlobalHelper.getPreferredWidth(context),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue.shade300],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListTile(
              leading: const Icon(
                  Icons.hourglass_empty,
                  color: Colors.white,
                  size: 50,
                ),
              title: Text(  
                "Site#${widget._siteTask.number.toString()}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                "Type${widget._siteTask.siteType}\n${widget._siteTask.description}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70
                ),
              ),
              trailing: _getTrailingIcon(),
              onTap: () {
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return SiteTaskListDialog(widget._siteTask,_onCompletionChanged, worker: widget.worker);
                  }
                );
              }
            ),
          )
        ],
      )
    );
  }

  Icon _getTrailingIcon() {
    double size = 50;
    return widget._siteTask.completed 
      ? Icon(
          Icons.check, 
          color: Colors.yellow,
          size: size,
        ) 
      : Icon(
          Icons.error_outline, 
          color: Colors.red,
          size: size,
        );
  }
}
