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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
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
              width: 300.0, // Change as per your requirement
              height: MediaQuery.of(context).size.height, // Change as per your requirement
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
        ],
      );
  }
}