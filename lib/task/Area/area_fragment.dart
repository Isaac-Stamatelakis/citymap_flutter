import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:flutter/material.dart';

class AreaFragment extends StatelessWidget {
  final Area? _area;
  final List<SiteTask>? _siteTasks;

  const AreaFragment(this._area, this._siteTasks,{super.key});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Text("Hello"),
    );
  }
}