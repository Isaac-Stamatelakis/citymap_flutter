import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/task/Area/Area.dart';
import 'package:city_map/task/site_task/site_task.dart';
import 'package:flutter/material.dart';

class SiteTaskDialog extends StatelessWidget {
  final SiteTask _siteTask;
  const SiteTaskDialog(this._siteTask,{super.key});
  
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
                "Site#${_siteTask.number}",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SiteTaskDialogTile("Site Type: ${_siteTask.siteType}"),
          SiteTaskDialogTile(_siteTask.description),
          SiteTaskDialogTile("Square Meters: ${_siteTask.squareMeters}"),
          SiteTaskDialogTile("Number of Beds: ${_siteTask.bedAmount}"),
          FutureBuilder(
            future: AreaDatabaseHelper(_siteTask.areaID).fromDatabase(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                Area area = snapshot.data;
                return SiteTaskDialogTile("Area: ${area.name}");
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
