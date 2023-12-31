import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/task/dailycheck/dailycheck.dart';
import 'package:city_map/task/driversheet/driversheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class DailyCheckDialog extends StatefulWidget {
  final DailyCheckContainer checkContainer;

  const DailyCheckDialog({super.key, required this.checkContainer});

  @override
  State<DailyCheckDialog> createState() => _State();
}

class _State extends State<DailyCheckDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
          children: [
            Center(
              child: AppBar(
              title: const Text(
                  "Daily Checks",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200, // Change as per your requirement
              height: MediaQuery.of(context).size.height, // Change as per your requirement
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.checkContainer.checks.length,
                  itemBuilder: (context, index) {
                    return _ListTile(map: widget.checkContainer.checks[index]);
                  },
                )
              )
            ]
          ),
        )
      )
    );
  }
}

class _ListTile extends StatefulWidget {
  final Map<String, dynamic>? map;
  const _ListTile({required this.map});
  @override
  State<_ListTile> createState() => _ListTileState();
}

class _ListTileState extends State<_ListTile> {
  @override
  Widget build(BuildContext context) {
    return 
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.map?['checkName'],
            textAlign: TextAlign.center,
          ),
          Switch(value: widget.map?['checked'], onChanged: (value){
            setState(() {
              widget.map?['checked'] = value;
              });
            }
          ),
          const SizedBox(height: 5)
        ],
      );
  }
}