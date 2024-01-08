import 'package:city_map/consts/global_list.dart';
import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/worker/worker.dart';
import 'package:flutter/material.dart';

abstract class AbstractAreaDisplayList<T> extends AbstractList<T,Area> {
  const AbstractAreaDisplayList({super.key, required super.user, required super.list});
}

abstract class AbstractAreaDisplayListState<T> extends AbstractListState<T,Area> {
  @override
  Widget getListTitleText(Area? element) {
    return Text(
      element!.name.toString(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white
      ),
    );
  }
  @override
  List<Color> getTileColors() {
    return [Colors.purple, Colors.purple.shade300];
  }
}

