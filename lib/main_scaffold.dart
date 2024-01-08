// ignore_for_file: constant_identifier_names

import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/consts/loader.dart';
import 'package:city_map/management/manager.dart';
import 'package:city_map/management/page/fragment_management.dart';
import 'package:city_map/map/map_fragment.dart';
import 'package:city_map/task/Area/area_display_list.dart';
import 'package:city_map/task/task_fragment.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MainPage {
  Map,
  Tasks,
  Areas,
  Management,
}

class MainPageFactory {
  static BottomNavigationBarItem getNavigatorBarWidget(MainPage page, Color color) {
    switch (page) {
      case MainPage.Map:
        return BottomNavigationBarItem(icon: const Icon(Icons.map), label: "Map", backgroundColor: color);
      case MainPage.Tasks:
        return BottomNavigationBarItem(icon: const Icon(Icons.view_list), label: 'Tasks', backgroundColor: color);
      case MainPage.Areas:
        return BottomNavigationBarItem(icon: const Icon(Icons.area_chart_outlined), label: 'Areas',backgroundColor: color);
      case MainPage.Management:
        return BottomNavigationBarItem(icon: const Icon(Icons.manage_accounts), label: 'Management',backgroundColor: color);
    }
  }
  static List<BottomNavigationBarItem> getNavigatorBarItems(Color color) {
    List<BottomNavigationBarItem> items = [];
    for (MainPage page in MainPage.values) {
      items.add(getNavigatorBarWidget(page,color));
    }
    return items;
  }
}


class MainScaffold extends StatefulWidget {
  final String? userID;
  final Widget? content;
  final String title;
  final MainPage initalPage;
  const MainScaffold({super.key, required this.content, required this.title, required this.initalPage, required this.userID});
  
  @override
  State<MainScaffold> createState() => _State();
}

class _State extends State<MainScaffold> {
  final Color darkIndigo = const Color.fromARGB(255, 17, 32, 117);
  final Color lightIndigo = const Color.fromARGB(255, 25, 44, 138);
  late Widget displayContent;
  late String displayTitle;
  late MainPage currentPage;
  @override
  void initState() {
    currentPage = widget.initalPage;
    displayTitle = widget.title;
    if (widget.content == null) {
      _buildFragments();
    } else {
      displayContent = widget.content!;
    }
    super.initState();
  }
  void _buildFragments() {  
    switch (currentPage) {
      case MainPage.Map:
        _setContent(MapFragmentLoader(startingCoordinates:null, workerID: widget.userID!), "Map");
        return;
      case MainPage.Tasks:
        _setContent(TaskFragmentLoader(workerID: widget.userID!, size: const Size(200,200)), "Tasks");
        return;
      case MainPage.Areas:
        _setContent(ManagerAreaListLoader(workerID: widget.userID!), "Areas");
      case MainPage.Management:
        _setContent(ManagementFragmentLoader(workerID: widget.userID!), "Management");
    }
  }

  void _setContent(Widget content, String title) {
    setState(() {
      displayContent = content;
      displayTitle = title; 
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,  
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100,Colors.white70],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              )
            ),
          ),
          displayContent,
        ],
      ),
      appBar: AppBar(
        title: Text(
          displayTitle,
          style: const TextStyle(
            color: Colors.white,
          )
        ),
        centerTitle: true,
        backgroundColor: darkIndigo,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.home, 
                color: Colors.white
              ),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined, 
                color: Colors.white
              ),
              onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context): null;
              },
            ), 
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: MainPageFactory.getNavigatorBarItems(lightIndigo),
        backgroundColor: lightIndigo,
        selectedItemColor: CustomColors.antiflashWhite,
        unselectedItemColor: Colors.black,
        currentIndex: MainPage.values.indexOf(currentPage),
        onTap: (index) {
          setState(() {
            if (MainPage.values[index] == currentPage) {
              return;
            }
            currentPage = MainPage.values[index];
            _buildFragments();
          });
        }
      ),
    );
  }
}
