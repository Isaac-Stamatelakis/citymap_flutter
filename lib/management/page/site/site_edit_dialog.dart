import 'dart:html';

import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/main_scaffold.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/management/page/site/dialog_site_edit.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/area_list.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/task/site_task/site_task_list.dart';
import 'package:city_map/task/site_task/uploader_site_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/async.dart';
import 'package:flutter/src/widgets/framework.dart';

class SiteEditPageLoader extends WidgetLoader {
  final Manager manager;
  const SiteEditPageLoader({super.key, required this.manager});

  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return MainScaffold(
      content: _SiteEditPage(manager: manager, managerSiteTasks: snapshot.data['sites']), 
      title: "Edit Sites", 
      initalPage: MainPage.Management, 
      userID: manager.workerID
    );
  }

  @override
  Future getFuture() async {
     List<SiteTask>? managerSiteTasks = await (SiteTaskManagerQuery(managerID: manager.id).retrieve());
     return {
      'sites' : managerSiteTasks,
    };
  }

}

class _SiteEditPage extends StatefulWidget {
  final Manager manager;
  final List<SiteTask> managerSiteTasks;

  const _SiteEditPage({required this.manager, required this.managerSiteTasks});
  @override
  State<StatefulWidget> createState() => _SiteEditPageState();

}
class _SiteEditPageState extends State<_SiteEditPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _SiteTaskEditList(user: widget.manager, siteTasks: widget.managerSiteTasks)
          ],
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: FloatingActionButton(
            heroTag: 'addButton',
            backgroundColor: Colors.blue,
            onPressed: (){_onAddPress(context);},
            child:  const Icon(
              Icons.add,
              color: Colors.white
            )
          )
        ),
      ],
    );
  }

  void _onAddPress(BuildContext context) async {
    SiteTask siteTask = BSiteTask(0, false, "", "", -1, const GeoPoint(0,0), "B", 0, "", null);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SiteEditDialog(
          siteTask: siteTask, 
          manager: widget.manager,
        );
      }
    );
    setState(() {
      widget.managerSiteTasks.add(siteTask);
    });
    await SiteTaskUploader().upload(siteTask);
  }
}

class _SiteTaskEditList extends AbstractSiteTaskDisplayList<Manager> {
  const _SiteTaskEditList({required super.siteTasks, required super.user});
  @override
  State<StatefulWidget> createState() => _SiteTaskEditListState();

}
class _SiteTaskEditListState extends AbstractSiteTaskDisplayListState<Manager> {
  @override
  onLongPress(SiteTask element, BuildContext context) {
   showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog<SiteTask>(
          displayText: 'Are you sure you want to delete ${element.number.toString()}?', onConfirmCallback: _deleteSite, value: element,
        );
      }
    );
    
  }

  void _deleteSite(SiteTask? siteTask, BuildContext context) {
    setState(() {
      widget.siteTasks!.remove(siteTask);
    });
    SiteTaskUploader().delete(siteTask);
  }
  @override
  onPress(SiteTask element, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SiteEditDialog(
          siteTask: element, 
          manager: widget.user,
        );
      }
    );
    // Change type. Probably a better way of doing this
    if (element.siteType == "A") {
      element = ASiteTask(
        widget.user.id, element.bedAmount, element.completed, element.completedBy, element.description, element.number, element.primaryLocation, element.siteType, element.squareMeters, element.areaID, element.dbID
      );
    } else if (element.siteType == "B") {
      element = BSiteTask(element.bedAmount, element.completed, element.completedBy, element.description, element.number, element.primaryLocation, element.siteType, element.squareMeters, element.areaID, element.dbID
      );
    }
    SiteTaskUploader().update(element);
    setState(() {
      
    });
  }
  
  
}