import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/helper.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/task/driversheet/driversheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class DriverSheetDialog extends StatefulWidget {
  final DriverSheet driverSheet;

  const DriverSheetDialog({super.key, required this.driverSheet});

  @override
  State<DriverSheetDialog> createState() => _DialogContentState();
}

class _DialogContentState extends State<DriverSheetDialog> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _startController.text = widget.driverSheet.startKiloMeters.toString();
    _endController.text = widget.driverSheet.endKiloMeters.toString();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: AppBar(
              title: const Text(
                  "Driver Sheet",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            getVehicleID(),
            TextField(
              controller: _startController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}$'),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'Start KM',
                labelStyle: TextStyle(
                  color: Colors.grey
                ),
              ),
              onChanged: (value) {
                widget.driverSheet.startKiloMeters = double.parse(value);
              },
            ),
            TextField(
              controller: _endController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}$'),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'End KM',
                labelStyle: TextStyle(
                  color: Colors.grey
                ),
              ),
              onChanged: (value) {
                widget.driverSheet.endKiloMeters = double.parse(value);
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height, // Change as per your requirement
              width: GlobalHelper.getPreferredWidth(context), // Change as per your requirement
              child: ListView.builder(
                itemCount: widget.driverSheet.checks?.length,
                itemBuilder: (context, index) {
                  return _ListTile(map: widget.driverSheet.checks?[index]);
                },
              )
            )
          ]
        )
      )
    );
  }

  Widget getVehicleID() {
    if (widget.driverSheet.vehicleID != null) {
      return _DialogTile("Vehicle: ${widget.driverSheet.vehicleID}");
    }
    return Container();
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
            hintText: "Describe State if Failed"
          ),
        )
      ],
    );
  }
}