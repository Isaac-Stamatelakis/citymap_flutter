import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/area_list.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/task/site_task/site_task_dialog.dart';
import 'package:city_map/task/task_fragment.dart';
import 'package:city_map/worker/worker.dart';
import 'package:flutter/material.dart';

abstract class AbstractSiteTaskDisplayList<T> extends StatefulWidget {
  final T user;
  final List<SiteTask>? siteTasks;
  const AbstractSiteTaskDisplayList({required this.siteTasks, super.key,required this.user });

}

abstract class AbstractSiteTaskDisplayListState<T> extends State<AbstractSiteTaskDisplayList<T>> implements IInteractableList<SiteTask> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.siteTasks!.length,
      separatorBuilder: (_,__) => const SizedBox(),
      itemBuilder: (context,int index) {
          return buildTile(widget.siteTasks![index], context);
      }  
    );
  }

  Widget buildTile(SiteTask siteTask, BuildContext context) {
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
                "Site#${siteTask.number.toString()}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                "Type${siteTask.siteType}\n${siteTask.description}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70
                ),
              ),
              trailing: _getTrailingIcon(siteTask),
              onTap: () {
                onPress(siteTask, context);
              },
              onLongPress: () {
                onLongPress(siteTask, context);
              },
            ),
          )
        ],
      )
    );
  }

  Icon _getTrailingIcon(SiteTask siteTask) {
    double size = 50;
    return siteTask.completed 
    ? Icon(
        Icons.check, 
        color: Colors.green,
        size: size,
      ) 
    : Icon(
        Icons.error_outline, 
        color: Colors.red,
        size: size,
    );
  }
}

class SiteTaskDisplayList extends AbstractSiteTaskDisplayList<Worker> {
  const SiteTaskDisplayList({super.key, required super.siteTasks, required super.user});
  @override
  State<StatefulWidget> createState() => _SiteTaskDisplayListState();
}

class _SiteTaskDisplayListState extends AbstractSiteTaskDisplayListState {
  @override
  onLongPress(SiteTask element, BuildContext context) {
    // Do nothing
  }

  @override
  onPress(SiteTask element, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SiteTaskListDialog(
          worker: widget.user, siteTask: element,
        );
      }
    );
  }
  

}