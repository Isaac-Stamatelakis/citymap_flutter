import 'package:city_map/management/page/site/dialog_site_edit.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:flutter/material.dart';

abstract class ManageSearchList<T> extends StatefulWidget {
  final WorkerGroup workerGroup;
  final List<T> list;
  const ManageSearchList({super.key, required this.workerGroup, required this.list});
}

abstract class ManageSearchListState<T> extends State<ManageSearchList<T>> {
  late List<T> displayedList = [];
  late String search = "";
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    sortAreas();
    return Column(
      children: [
        CustomTextField(
          controller: textEditingController, 
          inputFormatters: const [], 
          labelText: "Search", 
          onChange: (String value) {
            setState(() {
              search = value;
            });
          }
        ),
        getList()
      ],
    );
  }

  void sortAreas() {
    displayedList.clear();
    List<T> listTop = [];
    List<T> listBottom = [];
    for (T element in widget.list) {
      if (searchCheck(element)) {
        if (sortCheck(element)) {
          listTop.add(element);
        } else {
          listBottom.add(element);
        }
      }
    }
    displayedList.addAll(listTop);
    displayedList.addAll(listBottom);
  }

  bool searchCheck(T element);
  bool sortCheck(T element);
  Widget getList();
}