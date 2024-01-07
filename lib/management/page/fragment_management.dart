import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/management/page/area_edit_dialog.dart';
import 'package:city_map/worker/worker.dart';
import 'package:flutter/material.dart';

class ManagementFragmentLoader extends SizedWidgetLoader {
  final String workerID;

  const ManagementFragmentLoader({super.key, required this.workerID}) : super(size: const Size(200,200));
  @override
  Widget generateContent(AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return _ManagementFragment(manager: snapshot.data);
    } else {
      return _ManagementNoAccessFragment();
    }
  }

  @override
  Future getFuture() async {
    List<Manager?>? matchedManagers = await WorkerManagerQuery(workerID: workerID).fromDatabase();
    if (matchedManagers!.isEmpty) {
      return null;
    }
    Manager? manager = matchedManagers[0];
    if (manager == null) {
      return null;
    }
    return manager;
  }

}

class _ManagementNoAccessFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "You are not a manager. If you think this is a mistake please contact IT.",
        style: TextStyle(
          color: Colors.black,
          fontSize: 30,
        ),
      )
    );
  }
  
}
class _ManagementFragment extends StatelessWidget {
  final Manager manager;
  const _ManagementFragment({super.key, required this.manager});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SquareGradientButtonSizeable(
                onPress: _navigateManageWorkerGroups,
                text: "Manager WorkerGroups", 
                colors: [Colors.red,Colors.red.shade300],
                size: const Size(200,100)
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareGradientButtonSizeable(
                    onPress: _navigateManageSites,
                    text: "Manage Sites", 
                    colors: [Colors.blue,Colors.blue.shade300],
                    size: const Size(200,100)
                  ),
                  const SizedBox(width: 20),
                  SquareGradientButtonSizeable(
                    onPress: _navigateManageAreas,
                    text: "Manage Areas", 
                    colors: [Colors.blue,Colors.blue.shade300],
                    size: const Size(200,100)
                  ),
                ],
              )
            ],
          )
        )
      ],
    );
  }

  void _navigateManageSites(BuildContext context) {
    
  }

  void _navigateManageWorkerGroups(BuildContext context) {

  }

  void _navigateManageAreas(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => 
      EditAreaListLoader(
          manager: manager,
        ) 
      )
    );
  }
}