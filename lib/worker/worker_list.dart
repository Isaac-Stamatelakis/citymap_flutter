import 'dart:ui';

import 'package:city_map/consts/global_list.dart';
import 'package:city_map/worker/worker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

abstract class AbstractWorkerList<H> extends AbstractList<H,Worker> {
  const AbstractWorkerList({super.key, required super.user, required super.list});

}

abstract class AbstractWorkerListState<H> extends AbstractListState<H,Worker> {
  @override
  Widget getListTitleText(Worker element) {
    return Text(
      element.getFullName()!,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white
      ),
    );
  }

  @override
  List<Color> getTileColors() {
    return [Colors.blue, Colors.blue.shade300];
  }
}