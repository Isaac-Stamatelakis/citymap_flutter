// ignore_for_file: unused_element

import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/task/Area/area.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SiteEditDialog extends StatefulWidget {
  final SiteTask siteTask;
  final Manager manager;
  const SiteEditDialog({super.key, required this.siteTask, required this.manager});
  @override
  State<StatefulWidget> createState() => _SiteEditDialogState();
}


class _SiteEditDialogState extends State<SiteEditDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      content:Container(
        height: MediaQuery.of(context).size.height,
        width: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
            child:  SingleChildScrollView(
              child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.indigo,
                  title: const Text(
                    "Edit Site",
                    style: TextStyle(
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
                Row(
                  children: [
                    Expanded(
                      child: _AreaSelectorLoader(onAreaSelect: _onAreaSelect,managerID: widget.manager.id, siteTask: widget.siteTask),
                    ),
                    const SizedBox(height: 20),
                    Expanded(child: _SiteTypeDropDownSelector(
                      onSelect: (_SiteType? type) {
                        if (widget.siteTask.areaID.isEmpty) {
                          return;
                        }
                        widget.siteTask.siteType = type.toString().split(".")[1];
                      } , 
                      options: _SiteType.values, 
                      initalSelect: _SiteTypeFactory.stringToType(widget.siteTask.siteType), 
                      size: const Size(300,80), 
                      color: Colors.white, 
                      textColor: Colors.black
                    ),) 
                    
                  ],
                ),
                
                const SizedBox(height: 20),
                CustomTextField(
                  controller: TextEditingController(
                    text: widget.siteTask.number.toString()
                  ), 
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$'))], 
                  labelText: 'Site Number', 
                  onChange: (String value) {  
                    widget.siteTask.number = int.parse(value);
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: TextEditingController(
                    text: widget.siteTask.description
                  ), 
                  inputFormatters: const [], 
                  labelText: 'Description', 
                  onChange: (String value) {  
                    widget.siteTask.description = value;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: TextEditingController(
                    text: widget.siteTask.squareMeters.toString()
                  ), 
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*\.?[0-9]*$'))], 
                  labelText: 'Square Meters', 
                  onChange: (String value) {  
                    widget.siteTask.squareMeters = double.parse(value);
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: TextEditingController(
                    text: widget.siteTask.bedAmount.toString()
                  ), 
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$'))], 
                  labelText: 'Number of Beds', 
                  onChange: (String value) {  
                    widget.siteTask.bedAmount = int.parse(value);
                  },
                ),
                Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: TextEditingController(
                        text: widget.siteTask.primaryLocation.latitude.toString()
                      ), 
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*\.?[0-9]*$'))], 
                      labelText: 'Latitude', 
                      onChange: (String value) {  
                        widget.siteTask.primaryLocation = GeoPoint(double.parse(value),(widget.siteTask.primaryLocation!.longitude));
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomTextField(
                      controller: TextEditingController(
                        text: widget.siteTask.primaryLocation.latitude.toString()
                      ), 
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*\.?[0-9]*$'))], 
                      labelText: 'Longitude', 
                      onChange: (String value) {  
                        widget.siteTask.primaryLocation = GeoPoint(widget.siteTask.primaryLocation!.latitude,double.parse(value));
                      },
                    ),
                  ),
                ],
              )
            ],
          )
        ) 
      ),
    );
  }
  void _onAreaSelect(Area? area) {
    if (area == null) {
      if (widget.siteTask.siteType == "B") {
        return;
      }
      widget.siteTask.areaID = ""; 
    } else {
      widget.siteTask.areaID = area.id!;
    }
  }
}

enum _SiteType {
  A,
  B
}

class _SiteTypeFactory {
  static _SiteType stringToType(String input) {
    for (_SiteType type in _SiteType.values) {
      if (type.toString().split(".")[1] ==input) {
        return type;
      }
    }
    return _SiteType.B;
  }
}
class _AreaSelectorLoader extends WidgetLoader {
  final SiteTask siteTask;
  final String managerID;
  final Function(Area?) onAreaSelect;
  const _AreaSelectorLoader({super.key, required this.siteTask, required this.managerID, required this.onAreaSelect});
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    return _AreaSelector(
      onSelect: onAreaSelect, 
      options: getAreas(snapshot.data), 
      initalSelect: getInitalSelect(snapshot.data), 
      size: const Size(300,80), 
      color: Colors.white, 
      textColor: Colors.black
    );
  }

  @override
  Future getFuture() {
    return AreaManagerQuery(managerID: managerID).fromDatabase();
  }

  

  Area? getInitalSelect(List<Area> areas) {
    for (Area area in areas) {
      if (siteTask.areaID == area.id) {
        return area;
      }
    }
    return null;
  }
  List<Area?> getAreas(List<Area> areas) {
    List<Area?> list = [null];
    list.addAll(areas);
    return list;
  }

}
class _AreaSelector extends AbstractDropDownSelector<Area?> {
  const _AreaSelector({required super.onSelect, required super.options, required super.initalSelect, required super.size, required super.color, required super.textColor});
  @override
  State<StatefulWidget> createState() => _AreaSelectorState();

}

class _AreaSelectorState extends AbstractDropDownSelectorState<Area?> {
  @override
  String optionToString(Area? option) {
    if (option == null) {
      return "None";
    }
    return option.name!;
  }
}

class _SiteTypeDropDownSelector extends AbstractDropDownSelector<_SiteType> {
  const _SiteTypeDropDownSelector({required super.onSelect, required super.options, required super.initalSelect, required super.size, required super.color, required super.textColor});
  @override
  State<StatefulWidget> createState() => _SiteTypeDropdownSelectorState();

}

class _SiteTypeDropdownSelectorState extends AbstractDropDownSelectorState<_SiteType> {
  @override
  String optionToString(_SiteType option) {
    return option.toString().split(".")[1];
  }

}
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final List<FilteringTextInputFormatter> inputFormatters;
  final String labelText;
  final Function(String) onChange;

  const CustomTextField({super.key, required this.controller, required this.inputFormatters, required this.labelText, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey
        ),
      ),
      onChanged: (value) {
        onChange(value);
      },
    );
  }

}