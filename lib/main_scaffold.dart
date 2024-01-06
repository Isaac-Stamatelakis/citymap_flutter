// ignore_for_file: constant_identifier_names

import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/global_widgets.dart';
import 'package:city_map/map/map_fragment.dart';
import 'package:city_map/task/task_fragment.dart';
import 'package:flutter/material.dart';

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
        return BottomNavigationBarItem(icon: const Icon(Icons.view_list), label: 'Areas',backgroundColor: color);
      case MainPage.Management:
        return BottomNavigationBarItem(icon: const Icon(Icons.view_list), label: 'Management',backgroundColor: color);
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
  const MainScaffold({super.key, required this.content, required this.title, required this.initalPage, required this.userID,});
  
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
        _setContent(MapFragmentLoader(startingCoordinates: null, workerID: widget.userID!), "Map");
        return;
      case MainPage.Tasks:
        _setContent(TaskFragmentLoader(workerID: widget.userID!, size: const Size(200,200)), "Tasks");
        return;
      case MainPage.Areas:
        // TODO: Handle this case.
      case MainPage.Management:
        // TODO: Handle this case.
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
                colors: [Colors.blue.shade200,Colors.blue.shade100],
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
