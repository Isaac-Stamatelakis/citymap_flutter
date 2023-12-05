import 'dart:html';
import 'dart:js';
import 'dart:ui';

import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/global_constants.dart';
import 'package:city_map/management/management_fragment.dart';
import 'package:city_map/map/map_fragment.dart';
import 'package:city_map/task/task_fragment.dart';
import 'package:city_map/worker/worker.dart';
import 'package:city_map/worker/worker_group/worker_group.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:city_map/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  // Can be replaced with other authentatior services
  GlobalValues.user_id = "5e9e198fd2454634";
  Worker? worker = await WorkerDatabaseHelper().fromDatabase();
  print(worker?.firstName);
  runApp(
    ChangeNotifierProvider(
      create: (context) => worker,
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      title: 'Flutter Demo',
      /*
      builder: (context, child) {
        return const Scaffold(
          body: Text("Hello"),
        );
      },
      */
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  final List<Widget> _fragments = [];

  

  void _buildFragments(BuildContext context) {  
    _fragments.addAll(
      [
        const MapFragment(),
        FutureBuilder(future: _retrieveWorkerGroup(context),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            return ChangeNotifierProvider.value(
              value: snapshot.data,
              child: const TaskFragment(),
            );
          } 
        }
        ),
        const ManagementFragment(),
      ]
    );
  }

  Future<WorkerGroup> _retrieveWorkerGroup(BuildContext context) async {
     Worker worker = Provider.of<Worker>(context);
     return await WorkerGroupDatabaseHelper(worker.groupID).fromDatabase();
  }
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    //_retriveInformation(context);
    _buildFragments(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body:  _fragments[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CustomColors.coeBlue,
        selectedItemColor: CustomColors.antiflashWhite,
        unselectedItemColor: CustomColors.niceGrey,
        currentIndex: _currentIndex,
        items: const [
        BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
        BottomNavigationBarItem(icon: Icon(Icons.view_list), label: 'Tasks'),
        BottomNavigationBarItem(icon: Icon(Icons.manage_accounts_rounded), label: "Management")
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        }
      ),
    );
  }
}
