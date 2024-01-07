import 'dart:html';

import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/main_scaffold.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/Area/area_display_list.dart';
import 'package:city_map/task/Area/area_list.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/worker/worker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditAreaListLoader extends WidgetLoader {
  final Manager manager;
  const EditAreaListLoader({super.key, required this.manager});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return MainScaffold(
      content:_EditAreaFragment(manager: manager, areas: snapshot.data),
      title: "Edit Areas", 
      initalPage: MainPage.Management, 
      userID: manager.workerID
    );
  }

  @override
  Future getFuture() {
    return AreaManagerQuery(managerID : manager.id).fromDatabase();
  }
}

class _EditAreaFragment extends StatefulWidget {
  final Manager manager;
  final List<Area> areas;

  const _EditAreaFragment({required this.manager, required this.areas});

  @override
  State<_EditAreaFragment> createState() => _EditAreaFragmentState();
}

class _EditAreaFragmentState extends State<_EditAreaFragment> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _EditAreaList(areas:widget.areas, user: widget.manager)
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
    Area newArea = Area(name: "New Area", primaryLocation: const GeoPoint(0,0), id: null, managerID: widget.manager.id);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditAreaDialog(
          area: newArea
        );
      }
    );
     setState(() {
      widget.areas.add(newArea);
    });
    await AreaUploader().upload(newArea);
  }
}

class _EditAreaList extends AbstractAreaDisplayList<Manager> {
  const _EditAreaList({required super.user, required super.areas});
  @override
  State<StatefulWidget> createState() => _EditAreaListState();
}

class _EditAreaListState extends AbstractAreaDisplayListState<Manager> implements IInteractableList<Area> {
  @override
  onLongPress(Area element, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog<Area>(
          displayText: 'Are you sure you want to delete ${element.name}?', onConfirmCallback: onDelete, value: element,
        );
      }
    );
  }

  onDelete(Area? area, BuildContext context) async {
    if (area == null) {
      return;
    }
    setState(() {
      widget.areas!.remove(area);
    });
    AreaUploader().delete(area);

    
    

  }
  @override
  onPress(Area element, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditAreaDialog(
          area: element
        );
      }
    );
    setState(() {
      
    });
    await AreaUploader().update(element);
  }
}

class EditAreaDialog extends StatefulWidget {
  final Area area;
  const EditAreaDialog({super.key, required this.area});

  @override
  State<StatefulWidget> createState() => _EditAreaDialog();

}

class _EditAreaDialog extends State<EditAreaDialog> {
  late final TextEditingController _nameController = TextEditingController(text: widget.area.name);
  late final TextEditingController _longController = TextEditingController(text: widget.area.primaryLocation!.longitude.toString());
  late final TextEditingController _latController = TextEditingController(text: widget.area.primaryLocation!.latitude.toString());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content:Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
            child:  Column(
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
                TextField(
                  controller: _nameController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: Colors.grey
                    ),
                  ),
                  onChanged: (value) {
                    widget.area.name = value;
                  },
                ),
               Row(
                children: [
                  Expanded(
                      child: TextField(
                      controller: _latController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}$'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                        labelStyle: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                      onChanged: (value) {
                        widget.area.primaryLocation = GeoPoint(double.parse(value), widget.area.primaryLocation!.longitude);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                      child: TextField(
                      controller: _longController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}$'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Longitude ',
                        labelStyle: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                      onChanged: (value) {
                        widget.area.primaryLocation = GeoPoint(widget.area.primaryLocation!.latitude,double.parse(value));
                      },
                    ),
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}
