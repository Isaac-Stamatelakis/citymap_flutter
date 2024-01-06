import 'dart:html';

import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/map/map_fragment.dart';
import 'package:city_map/task/Area/Area.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*
Stateful Widgets
*/
abstract class _SiteTaskDialog extends StatefulWidget {
  final Function _onCompletionChanged;
  final SiteTask _siteTask;
  const _SiteTaskDialog(this._siteTask,this._onCompletionChanged,{super.key});
}

abstract class _SiteTaskDialogState extends State<_SiteTaskDialog> {
  void completePress() {
    setState(() {
      widget._siteTask.completed = !widget._siteTask.completed;
    });
    widget._onCompletionChanged(widget._siteTask);
  }
}

class SiteTaskListDialog extends _SiteTaskDialog {
  const SiteTaskListDialog(super.siteTask, super.onCompletionChanged, {super.key});
  @override
  State<StatefulWidget> createState() => _SiteTaskListDialogState();
}


class _SiteTaskListDialogState extends _SiteTaskDialogState {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BaseContent(siteTask: widget._siteTask,),
          _SiteTaskCompleteButton(siteTask: widget._siteTask, callback: completePress),
          _ViewOnMapButton(siteTask: widget._siteTask,)
        ],
      ),
    );
  }
}

class MapSiteTaskDialog extends _SiteTaskDialog {
  const MapSiteTaskDialog(super.siteTask, super.onCompletionChanged, {super.key});
  @override
  State<StatefulWidget> createState() => _MapSiteDialogState();

}

class _MapSiteDialogState extends _SiteTaskDialogState {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BaseContent(siteTask: widget._siteTask,),
          _SiteTaskCompleteButton(siteTask: widget._siteTask, callback: completePress),
        ],
      ),
    );
  }
}


/*
Widgets inside stateful widgets
*/
class _ViewOnMapButton extends StatelessWidget {
  final SiteTask siteTask;

  const _ViewOnMapButton({required this.siteTask});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.darkGreen
        ),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MapFragmentLoader(
              startingCoordinates: geoPointtoLatLng(),
              workerID: 'null'
              )
            ),
          );
        },
        child: const Text(
          "View on Map",
          style: TextStyle(
            color: CustomColors.antiflashWhite
          ),
        ) 
      )
    );
  }

  LatLng geoPointtoLatLng() {
    GeoPoint geoPoint = siteTask.primaryLocation;
    return LatLng(
      geoPoint.latitude, geoPoint.longitude
    );
  }
}
class _SiteTaskCompleteButton extends StatelessWidget {
  final SiteTask siteTask;
  final Function() callback;
  const _SiteTaskCompleteButton({required this.siteTask, required this.callback});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.darkGreen
        ),
        onPressed: (){
          callback();
        },
        child: const Text(
          "Set Complete",
          style: TextStyle(
            color: CustomColors.antiflashWhite
          ),
        ) 
      )
    );
  }
}



class _BaseContent extends StatelessWidget {
  final SiteTask siteTask;
  const _BaseContent({required this.siteTask});
  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
          Center(
            child: AppBar(
            title: Text(
                "Site#${siteTask.number}",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          _SiteTaskDialogTile("Site Type: ${siteTask.siteType}"),
          _SiteTaskDialogTile(siteTask.description),
          _SiteTaskDialogTile("Square Meters: ${siteTask.squareMeters}"),
          _SiteTaskDialogTile("Number of Beds: ${siteTask.bedAmount}"),
          _SiteTaskDialogTile("Completed: ${siteTask.completed}"),
          FutureBuilder(
            future: (siteTask.areaID != "") ? AreaDatabaseRetriever(id:siteTask.areaID).fromDatabase() : Future(() => null),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                if (snapshot.hasData) {
                  Area area = snapshot.data;
                  return _SiteTaskDialogTile("Area: ${area.name}");
                }
                return Container();
              }
            }
          ),
          SizedBox(
            height: Helper.getDeviceSize(context).height*0.05,
          ),
      ]
    );
  }
}


class _SiteTaskDialogTile extends StatelessWidget {
  final String? _title;
  const _SiteTaskDialogTile(this._title);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      tileColor: CustomColors.coeBlue,
      textColor: CustomColors.antiflashWhite,
      title: Text("$_title"),
    );
  }
}