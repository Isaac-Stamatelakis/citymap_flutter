

import 'dart:js_interop_unsafe';

import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/main_scaffold.dart';
import 'package:city_map/map/map_fragment.dart';
import 'package:city_map/task/Area/Area.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:city_map/task/site_task/uploader_site_task.dart';
import 'package:city_map/worker/worker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*
Stateful Widgets
*/
abstract class _SiteTaskDialog extends StatefulWidget {
  final Worker? worker;
  final SiteTask siteTask;
  const _SiteTaskDialog({super.key, required this.worker, required this.siteTask});
}

class SiteTaskListDialog extends _SiteTaskDialog {
  const SiteTaskListDialog({super.key, required super.worker, required super.siteTask});
  @override
  State<StatefulWidget> createState() => _SiteTaskListDialogState();
}


class _SiteTaskListDialogState extends State<SiteTaskListDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BaseContent(siteTask: widget.siteTask,),
          _SiteTaskCompleteButton(siteTask: widget.siteTask, callback: completePress),
          const SizedBox(height: 20),
          _ViewOnMapButton(siteTask: widget.siteTask, worker: widget.worker)
        ],
      ),
    );
  }

  void completePress(BuildContext context) {
    setState(() {
      widget.siteTask.completed = !widget.siteTask.completed;
    });
    SiteTaskUploader().update(widget.siteTask);
  }
}

class MapSiteTaskDialog extends _SiteTaskDialog {
  const MapSiteTaskDialog({super.key, required super.worker, required super.siteTask});
  @override
  State<StatefulWidget> createState() => _MapSiteDialogState();

}

class _MapSiteDialogState extends State<MapSiteTaskDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BaseContent(siteTask: widget.siteTask,),
          _SiteTaskCompleteButton(siteTask: widget.siteTask, callback: completePress),
        ],
      ),
    );
  }
  void completePress(BuildContext context) {
    setState(() {
      widget.siteTask.completed = !widget.siteTask.completed;
    });
    SiteTaskUploader().update(widget.siteTask);
  }
}


/*
Widgets inside stateful widgets
*/
class _ViewOnMapButton extends StatelessWidget {
  final SiteTask siteTask;
  final Worker? worker;
  const _ViewOnMapButton({required this.siteTask, required this.worker});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SquareGradientButtonSizeable(
        onPress: (BuildContext context) {
          while (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => 
            MainScaffold(
              content: MapFragmentLoader(
                workerID: worker!.id, 
                startingCoordinates:  geoPointtoLatLng()
              ),
              title: '', 
              initalPage: MainPage.Map, 
              userID: worker!.id,
              ),
            ),
          );
        }, 
        text: "View on Map", 
        colors: [Colors.blue,Colors.blue.shade300], 
        size: const Size(200,50)
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
  final Function(BuildContext) callback;
  const _SiteTaskCompleteButton({required this.siteTask, required this.callback});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SquareGradientButtonSizeable(
        onPress: callback, 
        text: _getText(), 
        colors: _getColors(), 
        size: const Size(200,50)
      )
    );
  }

  String _getText() {
    if (siteTask.completed) {
      return "Set Not Complete"; 
    } else {
      return "Set Complete";
    }
  }
  List<Color> _getColors() {
    if (siteTask.completed) {
      return [Colors.red, Colors.red.shade300];
    } else {
      return [Colors.green, Colors.green.shade300];
    }
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
            height: GlobalHelper.getDeviceSize(context).height*0.05,
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