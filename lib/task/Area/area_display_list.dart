import 'package:city_map/consts/helper.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/dialog_area.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/worker/worker.dart';
import 'package:flutter/material.dart';

class AreaListLoaderID extends SizedWidgetLoader {
  final List<String> areaIDs;
  final Worker worker;
  const AreaListLoaderID({super.key, required super.size, required this.areaIDs, required this.worker});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return AreaDisplayList(snapshot.data, worker: worker);
  }

  @override
  Future getFuture() {
    return AreaMultiDatabaseRetriever(areaIDs).fromDatabase();
  }
}

class ManagerAreaListLoader extends SizedWidgetLoader {
  final String workerID;
  const ManagerAreaListLoader({super.key, required this.workerID}) : super(size: const Size(200,200));
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    Map<String,dynamic> data = snapshot.data;
    return Column(
      children: [
        AreaDisplayList(data['areas'], worker: data['worker'])
      ],
    );
  }

  @override
  Future getFuture() async {
    Worker worker = await WorkerDatabaseHelper(workerID: workerID).fromDatabase();
    Manager manager = await ManagerDatabaseRetriever(id: worker.managerID).fromDatabase();
    List<Area> areas = await AreaMultiDatabaseRetriever(manager.managedAreaIDs).fromDatabase();
    return {
      'worker' : worker,
      'areas' : areas
    };
  }
}
class AreaDisplayList extends StatelessWidget {
  final Worker worker;
  final List<Area>? _areas;
  const AreaDisplayList(this._areas,{super.key, required this.worker});
  @override
  Widget build(BuildContext context) {
    return 
      Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _areas!.length,
          separatorBuilder: (_,__) => const SizedBox(),
          itemBuilder: (context,int index) {
              return AreaContent(_areas[index], worker: worker);
          } 
        )
      );
  }
}

class AreaContent extends StatelessWidget {
  final Worker worker;
  final Area _area;
  const AreaContent(this._area, {super.key, required this.worker});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
          Container(
            height: 80,
            alignment: Alignment.center,
            width: GlobalHelper.getPreferredWidth(context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
              colors: [Colors.purple, Colors.purple.shade300],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: GestureDetector(
            child: ListTile(
              title: Text(
                  _area.name.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white
                  ),
                ),
              onTap: () {
                _toAreaFragment(context);
              }
            )
          ),
        )
      ],
    );
    
    
  }
  void _toAreaFragment(BuildContext context) async{
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AreaDialogLoader(area: _area, worker: worker);
      }
    );
  }
}