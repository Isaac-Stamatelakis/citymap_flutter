import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/task/driversheet/driversheet.dart';
import 'package:flutter/material.dart';

class DriverSheetDialog extends StatefulWidget {
  final String driversheetID;
  const DriverSheetDialog({super.key, required this.driversheetID});

  @override
  State<DriverSheetDialog> createState() => _DriverSheetDialogState();
}

class _DriverSheetDialogState extends State<DriverSheetDialog> {
  @override
  Widget build(BuildContext context) {

    
    return Helper.commonFutureBuilder(
      DriverSheetDatabaseHelper(widget.driversheetID).fromDatabase(),
      buildFromFuture
    );
  }

  Widget buildFromFuture(AsyncSnapshot<dynamic> snapshot) {
    DriverSheet driverSheet = snapshot.data as DriverSheet;
    print(driverSheet.dbID);
    return _DialogContent(driverSheet:driverSheet);
  }
}

class _DialogContent extends StatelessWidget {
  final DriverSheet driverSheet;

  const _DialogContent({required this.driverSheet});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          Center(
            child: AppBar(
            title: const Text(
                "Driver Sheet",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          _DialogTile("Vehicle: ${driverSheet.vehicleID}" ),
          TextField(
            decoration: InputDecoration(
              labelText: "End KM: "
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Start KM: "
            ),
          ),
          Container(
            height: 300.0, // Change as per your requirement
            width: 300.0, // Change as per your requirement
            child: ListView.builder(
              
              itemCount: driverSheet.checks?.length,
              itemBuilder: (context, index) {
                return _ListTile(map: driverSheet.checks?[index]);
              },
            )
          )
          
        ]
      )
    );
  }
}



class _DialogTile extends StatelessWidget {
  final String? _title;
  const _DialogTile(this._title);

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


class _ListTile extends StatefulWidget {
  final Map<String, dynamic>? map;

  const _ListTile({required this.map});

  @override
  State<_ListTile> createState() => _ListTileState();
}

class _ListTileState extends State<_ListTile> {
  late final TextEditingController _controller = TextEditingController(text:widget.map?['description']);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.map?['type']),
        Switch(value: widget.map?['switched'], onChanged: (value){
            setState(() {
              widget.map?['switched'] = value;
            });
          }
        ),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "Describe State if Damaged"
          ),
        )
      ],
    );

    
  }
}