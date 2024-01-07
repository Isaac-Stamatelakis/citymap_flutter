import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/worker/worker.dart';
import 'package:flutter/material.dart';

abstract class AbstractAreaDisplayList extends StatefulWidget {
  final Worker? worker;
  final List<Area>? areas;
  const AbstractAreaDisplayList({super.key, required this.worker, required this.areas});

}

abstract class AbstractAreaDisplayListState extends State<AbstractAreaDisplayList> implements IInteractableList<Area>{
  @override
  Widget build(BuildContext context) {
    return 
    Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: widget.areas!.length,
        separatorBuilder: (_,__) => const SizedBox(),
        itemBuilder: (context,int index) {
          return buildTile(widget.areas![index], widget.worker);
        } 
      )
    );
  }

  Widget buildTile(Area area, Worker? worker) {
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
                  area.name.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white
                  ),
                ),
              onTap: () {
                onPress(area, context);
              },
              onLongPress: (){
                onLongPress(area, context);
              },
            )
          ),
        )
      ],
    );
  }
}