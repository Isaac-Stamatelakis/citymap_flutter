import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/task/Area/Area.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:flutter/material.dart';

class SiteTaskDialog extends StatefulWidget {
  final Function _onCompletionChanged;
  final SiteTask _siteTask;
  const SiteTaskDialog(this._siteTask,this._onCompletionChanged,{super.key});

  @override
  State<StatefulWidget> createState() => _SiteTaskDialogState();

}

class _SiteTaskDialogState extends State<SiteTaskDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: AppBar(
            title: Text(
                "Site#${widget._siteTask.number}",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SiteTaskDialogTile("Site Type: ${widget._siteTask.siteType}"),
          SiteTaskDialogTile(widget._siteTask.description),
          SiteTaskDialogTile("Square Meters: ${widget._siteTask.squareMeters}"),
          SiteTaskDialogTile("Number of Beds: ${widget._siteTask.bedAmount}"),
          SiteTaskDialogTile("Completed: ${widget._siteTask.completed}"),
          FutureBuilder(
            future: (widget._siteTask.areaID != "") ? AreaDatabaseRetriever(widget._siteTask.areaID).fromDatabase() : Future(() => null),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                if (snapshot.hasData) {
                  Area area = snapshot.data;
                  return SiteTaskDialogTile("Area: ${area.name}");
                }
                return Container();
              }
            }
          ),
          SizedBox(
            height: Helper.getDeviceSize(context).height*0.05,
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.darkGreen
              ),
              onPressed: (){},
              child: const Text(
                "View on Map",
                style: TextStyle(
                  color: CustomColors.antiflashWhite
                ),
              ) 
            )
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.darkGreen
              ),
              onPressed: (){
                setState(() {
                  widget._siteTask.completed=!widget._siteTask.completed;
                });
                widget._onCompletionChanged(widget._siteTask);
              },
              child: const Text(
                "Set Complete",
                style: TextStyle(
                  color: CustomColors.antiflashWhite
                ),
              ) 
            )
          )
        ],
      ),
    );
  }

}
class SiteTaskDialogTile extends StatelessWidget {
  final String? _title;
  const SiteTaskDialogTile(this._title,{super.key});

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
