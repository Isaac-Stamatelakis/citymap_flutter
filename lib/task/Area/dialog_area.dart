import 'package:city_map/consts/helper.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/task/site_task/site_task_list.dart';
import 'package:city_map/worker/worker.dart';
import 'package:flutter/material.dart';


class AreaDialogLoader extends WidgetLoader {
  final Area area;
  final Worker worker;
  const AreaDialogLoader({super.key,required this.worker, required this.area});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return AreaDialog(area: area, siteTasks: snapshot.data, worker: worker);
  }

  @override
  Future getFuture() {
    return SiteTaskAreaQuery(area.id!).fromDatabase();
  }

}
class AreaDialog extends StatefulWidget {
  final Worker worker;
  final Area area;
  final List<SiteTask> siteTasks;
  const AreaDialog({super.key, required this.area, required this.siteTasks, required this.worker});

  @override
  State<StatefulWidget> createState() => _AreaDialogState();

}

class _AreaDialogState extends State<AreaDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content:Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
          child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.indigo,
              title: Text(
                widget.area.name!,
                style: const TextStyle(
                  color: Colors.white
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back, 
                  color: Colors.white
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              height: MediaQuery.of(context).size.height/2,
              width: GlobalHelper.getPreferredWidth(context),
              child:  SiteTaskDisplayList(list:widget.siteTasks, user: widget.worker)
            )
          ],
        )
      ),
    );
  }

}