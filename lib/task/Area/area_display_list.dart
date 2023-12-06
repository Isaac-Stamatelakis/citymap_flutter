import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/area_fragment.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:flutter/material.dart';

class AreaDisplayList extends StatelessWidget {
  final List<Area>? _areas;
  const AreaDisplayList(this._areas,{super.key});
  @override
  Widget build(BuildContext context) {
    return 
      Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _areas!.length,
          separatorBuilder: (_,__) => const SizedBox(),
          itemBuilder: (context,int index) {
              return AreaContent(_areas![index]);
          } 
        )
      );
  }
}

class AreaContent extends StatelessWidget {
  final Area _area;
  const AreaContent(this._area, {super.key});
  @override
  Widget build(BuildContext context) {
    return
        Container(
          color: Colors.brown,
          child: GestureDetector(
            child: ListTile(
              leading: const Icon(Icons.agriculture),
              title: Text(_area.name.toString()),
              onTap: () {
                _toAreaFragment(context);
              }
          )
        ),
    );
  }
  void _toAreaFragment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FutureBuilder(
        future: SiteTaskAreaQuery(_area.id).fromDatabase(), 
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              //List<SiteTask>? siteTasks = snapshot.data as List<SiteTask>?;
              List<SiteTask>? siteTasks = snapshot.data?.cast<SiteTask>();
              return AreaFragment(_area, siteTasks);
            }
          }
        )
      )
    );
  }
}