import 'dart:html';
import 'dart:js';
import 'dart:ui';

import 'package:city_map/consts/colors.dart';
import 'package:city_map/consts/global_constants.dart';
import 'package:city_map/main_scaffold.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      title: 'City Map',
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScaffold(
          initalPage: MainPage.Tasks, 
          content: null,
          title: '',
          userID: "5e9e198fd2454634", 
        ),
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
